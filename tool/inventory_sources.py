"""Read frozen Git objects; emit sanitized inventory and external restricted evidence.

Never executes source code, checks out a source, or writes into a source repository.
Pass source locations privately. The restricted output must be outside all checkouts.
Lexical references are evidence of static references, not proof of runtime execution.
"""
import argparse
from collections import Counter, defaultdict
import io
import json
from pathlib import Path, PurePosixPath
import posixpath
import re
import subprocess
import tarfile

ROOT = Path(__file__).resolve().parents[1]
DECL = re.compile(r'^(?:(?:abstract|sealed|final|base|interface)\s+)*(class|enum|typedef|mixin|extension)\s+([A-Za-z]\w*)', re.M)
DIRECTIVE = re.compile(r"^\s*(import|export|part(?: of)?)\s+['\"]([^'\"]+)['\"]", re.M)
COMMENTS = re.compile(r'/\*.*?\*/|//[^\n]*', re.S)
PRIORITY = {'Utils', 'Unit', 'Model', 'Either', 'Left', 'Right', 'ErrorItem',
            'EntityUtil', 'NoParams', 'ModelUtils', 'DateTimeIsoUtils', 'ClockPolicy',
            'DateUtils', 'JocaDateUtils', 'MoneyUtils', 'Debouncer', 'PerKeyFifoExecutor',
            'Mapper', 'CryptoUtils', 'ErrorCatalog', 'ErrorCatalogRegistry', 'AddressModel'}
RETAIN = {'Utils', 'Unit', 'Model', 'Either', 'Left', 'Right', 'ErrorItem',
          'EntityUtil', 'NoParams', 'ModelUtils', 'DateTimeIsoUtils', 'ClockPolicy',
          'DateUtils', 'JocaDateUtils', 'MoneyUtils', 'Debouncer', 'PerKeyFifoExecutor',
          'Mapper', 'AddressModel'}


def snapshot(root, revision):
    data = subprocess.check_output(['git', '-C', str(root), 'archive', revision])
    with tarfile.open(fileobj=io.BytesIO(data)) as archive:
        return {m.name: archive.extractfile(m).read().decode('utf-8', errors='replace')
                for m in archive if m.isfile() and m.name.endswith(('.dart', '.md', '.json', '.yaml'))}


def selected(source, path):
    return path.endswith('.dart') and path.startswith('lib/') and (
        source == 'A' or path.startswith(('lib/core/', 'lib/domain/'))
        or '/domain/' in path or '/utils/' in path or '/helpers/' in path
        or bool(re.search(r'(?:utils?|helpers?)\.dart$', path)))


def code_only(text):
    # Preserve line offsets, including multiline comments. Strings remain: callers
    # classify quoted references separately rather than claiming AST resolution.
    return COMMENTS.sub(lambda m: '\n' * m.group().count('\n'), text)


def inspect(source, root, revision):
    files = snapshot(root, revision)
    dart = {p: code_only(s) for p, s in files.items() if p.endswith('.dart')}
    graph, external = defaultdict(set), defaultdict(set)
    package = re.search(r'^name:\s*(\S+)', files['pubspec.yaml'], re.M).group(1)
    for p, s in files.items():
        if p not in dart:
            continue
        for kind, uri in DIRECTIVE.findall(s):
            if uri.startswith('package:' + package + '/'):
                target = 'lib/' + uri.split('/', 1)[1]
            elif ':' in uri:
                external[p].add(uri if source == 'A' or uri.startswith('dart:') else 'non-SDK package')
                continue
            else:
                target = posixpath.normpath(str(PurePosixPath(p).parent / uri))
            if target in dart:
                graph[p].add(target)
                if kind.startswith('part'):
                    graph[target].add(p)
            else:
                external[p].add('unresolved local directive')
    def closure(path):
        seen, pending = set(), [path]
        deps = set()
        while pending:
            item = pending.pop()
            if item in seen:
                continue
            seen.add(item)
            deps.update(external[item])
            pending.extend(graph[item] - seen)
        return sorted(deps), sorted(seen - {path})
    declarations = []
    # Append utility-directory declarations outside the initial primary roots;
    # preserve IDs already allocated to the primary frozen declaration set.
    def declaration_order(item):
        p = item[0]
        auxiliary = source == 'B' and not (
            p.startswith(('lib/core/', 'lib/domain/')) or '/domain/' in p
            or bool(re.search(r'(?:utils?|helpers?)\.dart$', p)))
        return auxiliary, p
    for p, s in sorted(dart.items(), key=declaration_order):
        if not selected(source, p):
            continue
        for m in DECL.finditer(s):
            declarations.append((p, m.group(1), m.group(2), s[:m.start()].count('\n') + 1))
    # Build a bounded token index once for all candidates, including test/example/docs.
    names = {d[2] for d in declarations}
    refs = defaultdict(list)
    for p, s in sorted(files.items()):
        if not p.endswith(('.dart', '.md')):
            continue
        category = 'production' if p.startswith(('lib/', 'bin/')) and p.endswith('.dart') else (
            'tests_examples' if p.startswith(('test/', 'example/', 'examples/', 'integration_test/')) else 'documentation')
        content = dart[p] if p in dart else s
        for number, line in enumerate(content.splitlines(), 1):
            for name in set(re.findall(r'\b[A-Za-z]\w*\b', line)) & names:
                refs[name].append((p, number, category))
    rows, restricted = [], []
    for index, (p, kind, name, line) in enumerate(declarations, 1):
        cid = f'{source}-{index:04d}'
        eid = f'EV-{source}-{index + 100:04d}'
        deps, locals_ = closure(p)
        matches = [r for r in refs[name] if r[:2] != (p, line)]
        counts = Counter(r[2] for r in matches)
        serial = kind == 'class' and ('toJson(' in dart[p] or 'fromJson(' in dart[p])
        layer = 'model' if '/models/' in p or serial else 'contract'
        runtime = bool(re.search(r'/(?:blocs?|services|gateways|repositories|usecases|ui|fake_services)/', p)) or name.startswith(('Bloc', 'Fake', 'Service', 'Gateway', 'Repository'))
        retained = name in RETAIN
        decision = 'adapt' if retained and name not in ('Utils', 'Unit') else 'extract' if retained else 'exclude' if runtime or name == 'CryptoUtils' else 'defer'
        label = name if source == 'A' or name in PRIORITY else f'{layer} {cid}'
        dto = ('error-item-v1' if name == 'ErrorItem' else 'address-v1' if name == 'AddressModel' else None)
        row = {
            'id': cid, 'source': 'SRC-' + source, 'api': label, 'kind': kind,
            'category': 'utility' if name in PRIORITY and not serial else layer,
            'dto': dto, 'dto_reason': 'indexed draft contract' if dto else 'not selected for wire-contract retention' if serial else 'no independent wire contract',
            'evidence': eid, 'dependencies': deps, 'local_dependency_count': len(locals_),
            'usage': dict(production=counts['production'], tests_examples=counts['tests_examples'], documentation=counts['documentation']),
            'usage_kind': 'static token references; dynamic/external usage unknown',
            'consumer': 'existing source code; future SDK consumers only after contract resolution',
            'risk': 'library identity and part/import closure; signatures and wire behavior need characterization',
            'decision': decision, 'retained': retained,
            'priority': 'P0' if name in ('Utils', 'Unit') else 'P1' if retained else 'P2' if not runtime else 'N/A',
            'wave': '0 (existing API)' if name in ('Utils', 'Unit') else '1 (proposal)' if retained else 'unselected',
        }
        if source == 'A':
            row['provenance'] = {'commit': revision, 'path': p, 'line': line}
        if name in ('Either', 'Left', 'Right'):
            row['risk'] += '; SRC-B selected as priority; sealed/final differs from SRC-A extensibility'
        rows.append(row)
        restricted.append({'id': cid, 'evidence': eid, 'name': name, 'commit': revision,
                           'path': p, 'line': line, 'local_dependencies': locals_, 'references': matches})
    return rows, restricted, {'selected_files': sum(selected(source, p) for p in dart),
                             'dart_files_searched': len(dart), 'candidate_count': len(rows),
                             'tracked_text_files_searched': sum(p.endswith(('.dart', '.md')) for p in files)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for source in ('a', 'b'):
        parser.add_argument('--' + source + '-root', required=True, type=Path)
        parser.add_argument('--' + source + '-revision', required=True)
    parser.add_argument('--restricted-output', required=True, type=Path)
    args = parser.parse_args()
    restricted_path = args.restricted_output.resolve()
    # Reject repository locations, including ignored folders in any Git worktree.
    for parent in [restricted_path.parent, *restricted_path.parents]:
        if (parent / '.git').exists():
            parser.error('Restricted evidence must remain outside every Git checkout')
    if restricted_path.exists():
        parser.error('Use a new external restricted output; preserve previous evidence')
    results = [inspect(s, getattr(args, s.lower() + '_root'), getattr(args, s.lower() + '_revision')) for s in ('A', 'B')]
    all_rows = [r for rows, _, _ in results for r in rows]
    names = defaultdict(list)
    for _, private, _ in results:
        for r in private:
            names[r['name']].append(r['id'])
    for rows, private, _ in results:
        for row, evidence in zip(rows, private):
            row['counterparts'] = [cid for cid in names[evidence['name']] if cid[0] != row['id'][0]]
    restricted_path.write_text(json.dumps({'sources': [str(args.a_root), str(args.b_root)], 'records': [r for _, private, _ in results for r in private]}, indent=2) + '\n', encoding='utf-8')
    target = ROOT / 'docs/migration'
    target.mkdir(parents=True, exist_ok=True)
    header = {'method': 'inventory_sources.py v1; lexical reference counts are not runtime evidence',
              'sources': {s: result[2] for s, result in zip(('SRC-A', 'SRC-B'), results)}}
    document = (json.dumps(header, indent=2)[:-2] + ',\n  "candidates": [\n'
                + ',\n'.join('    ' + json.dumps(row, ensure_ascii=False) for row in all_rows)
                + '\n  ]\n}\n')
    (target / 'inventory.json').write_text(document, encoding='utf-8')
    print(json.dumps({s: result[2] for s, result in zip(('SRC-A', 'SRC-B'), results)}))


if __name__ == '__main__':
    main()
