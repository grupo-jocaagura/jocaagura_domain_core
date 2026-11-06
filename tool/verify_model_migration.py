"""Check issue #15 matrix integrity without asserting semantic certification.

--require-complete also fails on pending model/API implementation. Ordinary draft
verification never turns an inferred example shape into a verified contract.
"""

import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE_SELECTION_SHA256 = '4e1957b755f8db079a9f9493dc2cbbf09ab872118a4670e2744844816b0536ec'
API_SELECTION_SHA256 = '84619d1cdbdafb120c7e0abdf036444d8b1fde4a3972121b1d43fcc4e900b890'
API_SNAPSHOT_SHA256 = 'a9074eb0024f6de1c3acc0e7f2324d4f1c83b6996959e8e62a4af1245fd755af'


def digest(path):
    return hashlib.sha256(path.read_text(encoding='utf-8').encode()).hexdigest()


def local(root, path):
    target = (root / path).resolve()
    if not target.is_relative_to(root.resolve()) or not target.is_file():
        raise ValueError('Missing or external implementation/test path')
    return target


def validate(root=ROOT, require_complete=False, matrix=None):
    if matrix is None:
        matrix = json.loads((root / 'docs/migration/model_migration.json').read_text(encoding='utf-8'))
    if matrix.get('issue') != 15 or matrix['source']['commit'] != '56f7eba8a6041160ecf1c1501745c1249e124670':
        raise ValueError('Unexpected issue/source snapshot')
    rows = matrix['source_files']
    selection = [{key: row[key] for key in ('path', 'sha256', 'declarations', 'target')}
                 for row in rows]
    selection_hash = hashlib.sha256(json.dumps(
        selection, sort_keys=True, ensure_ascii=False, separators=(',', ':'),
    ).encode()).hexdigest()
    if selection_hash != SOURCE_SELECTION_SHA256 or matrix.get('source_selection_sha256') != selection_hash:
        raise ValueError('Source selection differs from the independently pinned inventory')
    if len(rows) != 83 or len({r['path'] for r in rows}) != len(rows):
        raise ValueError('Source model selection changed without a scoped inventory amendment')
    ids = [d['historical_id'] for r in rows for d in r['declarations'] if d.get('historical_id')]
    if len(set(ids)) != len(ids):
        raise ValueError('Historical declaration ID reused')
    pending = []
    for row in rows:
        target = local(root, row['target'])
        source = target.read_text(encoding='utf-8')
        for declaration in row['declarations']:
            if not re.search(r'\b' + re.escape(declaration['name']) + r'\b', source):
                raise ValueError('Selected declaration has no target')
        if row['status'] == 'implemented_local':
            if digest(target) != row.get('target_sha256') or not row.get('tests'):
                raise ValueError('Stale implementation hash or absent behavior-test mapping')
            local(root, row['public_entrypoint'])
            for test in row['tests']:
                local(root, test)
        else:
            pending.append(row['target'])
    definitions = json.loads((root / 'docs/DTO/api/v1/values.json').read_text(encoding='utf-8'))
    fixture = json.loads((root / 'test/fixtures/api-values.json').read_text(encoding='utf-8'))
    if fixture != definitions:
        raise ValueError('Packaged API field definitions drifted from their canonical source')
    names = {m['name'] for m in definitions['models']}
    if len(names) != len(definitions['models']):
        raise ValueError('Duplicate canonical API value name')
    code = (root / 'lib/src/api/api_values.dart').read_text(encoding='utf-8')
    document_hashes = matrix['api']['document_hashes']
    fingerprint = hashlib.sha256(json.dumps(sorted(document_hashes.items()), separators=(',', ':')).encode()).hexdigest()
    if fingerprint != API_SNAPSHOT_SHA256 or matrix['api']['fingerprint'] != fingerprint:
        raise ValueError('API document snapshot differs from the independently pinned freeze')
    for model in definitions['models']:
        if f"class {model['name']} extends ApiValue" not in code or not model.get('evidence'):
            raise ValueError('API value lacks an implementation or source-contract evidence')
        if len({field['name'] for field in model['fields']}) != len(model['fields']):
            raise ValueError('Duplicate API field')
        if not set(model['evidence']) <= document_hashes.keys() or not model.get('tests'):
            raise ValueError('API value lacks frozen evidence or independent behavior-test mapping')
        for test in model['tests']:
            local(root, test)
    operations = matrix['operations']
    if len(operations) != 183 or len(operations) != matrix['api']['operations'] or len({r['id'] for r in operations}) != len(operations):
        raise ValueError('Duplicate or omitted catalog operation')
    api_selection = [{key: row[key] for key in ('id', 'method', 'path', 'module', 'evidence', 'sha256')}
                     for row in operations]
    api_hash = hashlib.sha256(json.dumps(api_selection, sort_keys=True, ensure_ascii=False, separators=(',', ':')).encode()).hexdigest()
    if api_hash != API_SELECTION_SHA256 or matrix.get('api_selection_sha256') != api_hash:
        raise ValueError('API operation selection differs from the independently pinned freeze')
    for operation in operations:
        if not re.fullmatch(r'EV-B-15-\d{4}', operation['evidence']):
            raise ValueError('API snapshot evidence was reassigned')
        if not re.fullmatch(r'[0-9a-f]{64}', operation['sha256']):
            raise ValueError('Missing frozen API document hash')
        if document_hashes.get(operation['evidence']) != operation['sha256']:
            raise ValueError('API operation evidence does not match its frozen document')
        if operation['status'] == 'implemented_local':
            if not operation['contracts'] or not set(operation['contracts']) <= names or not operation['tests']:
                raise ValueError('Implemented operation lacks typed contracts/tests')
            for test in operation['tests']:
                local(root, test)
        elif operation['status'] == 'not_a_model':
            if not operation.get('reason'):
                raise ValueError('Non-model operation lacks a reason')
        else:
            pending.append(operation['id'])
    for source in (root / 'lib').rglob('*.dart'):
        text = source.read_text(encoding='utf-8')
        for uri in re.findall(r"(?:import|export)\s+['\"]([^'\"]+)['\"]", text):
            if uri in ('dart:ui', 'dart:io', 'dart:ffi', 'dart:html') or (
                    uri.startswith('package:') and not uri.startswith('package:jocaagura_domain_core/')):
                raise ValueError('Production code crossed the SDK-only package boundary')
    if require_complete and pending:
        raise ValueError(f'Migration remains incomplete: {len(pending)} model/operation entries are pending')
    return len(rows), len(operations), len(names), len(pending)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--require-complete', action='store_true')
    args = parser.parse_args()
    try:
        source, api, values, pending = validate(require_complete=args.require_complete)
    except (ValueError, KeyError, OSError) as error:
        parser.exit(1, f'Model matrix verification failed: {error}\n')
    print(f'Matrix structure: {source} source files, {api} operations, {values} API values, '
          f'{pending} pending entries. This is not review or deployment certification.')
