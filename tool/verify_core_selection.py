"""Check CP-1 integrity, inventory completeness, closure and public export names.

This is structural validation, not a semantic audit or release approval.
Behavior/signature tests must run separately against the real public entrypoint.
"""
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
DISPOSITIONS = {
    'CORE', 'DOMAIN_VERTICAL', 'INFRASTRUCTURE', 'UI', 'TEST_FAKE',
    'EXTERNAL_RUNTIME', 'DUPLICATE_COUNTERPART', 'OUT_OF_SCOPE',
}


def digest(document):
    body = {k: v for k, v in document.items() if k != 'selection_sha256'}
    return hashlib.sha256(json.dumps(
        body, ensure_ascii=False, sort_keys=True, separators=(',', ':'),
    ).encode()).hexdigest()


def validate(root=ROOT, selection=None, architecture=None):
    selection = selection if selection is not None else json.loads(
        (root / 'docs/migration/core_selection.json').read_text(encoding='utf-8'))
    architecture = architecture if architecture is not None else json.loads(
        (root / 'docs/migration/architecture_inventory.json').read_text(encoding='utf-8'))
    original = json.loads((root / 'docs/migration/inventory.json').read_text(encoding='utf-8'))
    if digest(selection) != selection.get('selection_sha256'):
        raise ValueError('CP-1 content hash changed without a versioned amendment')
    ids = {r['id'] for r in original['candidates']}
    rows = architecture['candidates']
    by_id = {r['id']: r for r in rows}
    if len(ids) != 1712 or len(rows) != len(ids) or set(by_id) != ids:
        raise ValueError('Architectural inventory must preserve all 1712 original IDs exactly once')
    evidence = {r['id']: r['evidence'] for r in original['candidates']}
    libraries = {r['id'] for r in architecture['libraries']}
    for row in rows:
        if row['disposition'] not in DISPOSITIONS or row['evidence'] != evidence[row['id']]:
            raise ValueError('Invalid disposition or reassigned source evidence')
        if len(row['admission']) != 5 or not all(row['admission']):
            raise ValueError('Five explicit admission answers required')
        if not all(row.get(k) for k in ('function', 'reason', 'portability', 'compatibility', 'counterpart_resolution')):
            raise ValueError('Architectural decision lacks evidence/compatibility rationale')
        if row['source_library'] not in libraries or not set(row['source_identifier_references']) <= ids:
            raise ValueError('Unresolved inventory dependency reference')
        if row['disposition'] == 'CORE' and not row.get('canonical_target'):
            raise ValueError('CORE row must identify a canonical target')
    for library in architecture['libraries']:
        if not set(library['local_libraries']) <= libraries:
            raise ValueError('Unresolved source library closure')
    symbols = selection['symbols']
    names = {s['name'] for s in symbols}
    if len(names) != len(symbols):
        raise ValueError('Duplicate selected API')
    allowed = names | set(selection['baseline_exports']) | {
        h['name'] for h in selection['internal_helpers']
    } | {'dart:async'}
    for symbol in symbols:
        if symbol['canonical'] not in ids or by_id[symbol['canonical']]['disposition'] != 'CORE':
            raise ValueError('Selected API lacks canonical CORE evidence')
        if not set(symbol['dependencies']) <= allowed:
            raise ValueError('Selected closure imports a non-admitted dependency')
        if not symbol['signatures'] or len(symbol['admission']) != 5:
            raise ValueError('Selected contract lacks signatures or admission answers')
        for path in [symbol['implementation'], *symbol['tests']]:
            if not (root / path).is_file():
                raise ValueError('Selected implementation/test file is missing')
    for path, expected in selection['baseline_files'].items():
        # Match the logical UTF-8 source, independent of checkout CRLF policy.
        if hashlib.sha256((root / path).read_text(encoding='utf-8').encode()).hexdigest() != expected:
            raise ValueError('Released Utils/Unit source changed')
    barrel = (root / 'lib/jocaagura_domain_core.dart').read_text(encoding='utf-8')
    exports = re.findall(r"export\s+'([^']+)'\s+show\s+([^;]+);", barrel)
    expected_exports = {}
    for symbol in symbols:
        expected_exports.setdefault(symbol['implementation'].removeprefix('lib/'), set()).add(symbol['name'])
    expected_exports.update({'src/unit.dart': {'Unit', 'unit'}, 'src/utils.dart': {'Utils'}})
    actual = {path: set(re.findall(r'\w+', names)) for path, names in exports}
    if actual != expected_exports or len(exports) != len(re.findall(r'^export\s', barrel, re.M)):
        raise ValueError('Actual entrypoint exports differ from the finite CP-1 selection')
    return len(rows), len(names)


if __name__ == '__main__':
    rows, symbols = validate()
    print(f'CP-1 integrity: {rows} rows, {symbols} selected symbols plus baseline; no review/publication approval implied.')
