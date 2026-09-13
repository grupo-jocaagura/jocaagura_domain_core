"""Validate local DTO contracts without executing or certifying source models."""
import json
from pathlib import Path
import re

from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[1]


def validate(root=ROOT):
    directory = root / 'docs/DTO'
    catalog = (directory / 'README.md').read_text(encoding='utf-8')
    schemas = sorted(directory.glob('v*/*.schema.json'))
    if not schemas:
        raise ValueError('No versioned contract schemas')
    for path in schemas:
        schema = json.loads(path.read_text(encoding='utf-8'))
        Draft202012Validator.check_schema(schema)
        name = path.name.removesuffix('.schema.json')
        page = path.with_name(name + '.md')
        example = path.parent / 'examples' / (name + '.example.json')
        if not page.is_file() or not example.is_file() or path.name not in catalog:
            raise ValueError('Unindexed or incomplete contract')
        # This small catalog has no cross-schema references. Reject remote or
        # unresolved references instead of fetching them implicitly.
        def references(value):
            if isinstance(value, dict):
                for key, child in value.items():
                    if key == '$ref':
                        raise ValueError('Explicit local reference resolution required')
                    references(child)
            elif isinstance(value, list):
                for child in value:
                    references(child)
        references(schema)
        validator = Draft202012Validator(schema)
        instance = json.loads(example.read_text(encoding='utf-8'))
        validator.validate(instance)
        for key in schema['required']:
            missing = dict(instance)
            del missing[key]
            if validator.is_valid(missing):
                raise ValueError('Required field accepted as absent')
            if validator.is_valid(dict(instance, **{key: None})):
                raise ValueError('Non-null output field accepted as null')
        if validator.is_valid(dict(instance, unknownField=True)):
            raise ValueError('Unexpected output field accepted')
    for path in list(directory.rglob('*.md')) + list((root / 'docs/migration').glob('*.md')):
        for target in re.findall(r'\[[^\]]*\]\(([^)]+)\)', path.read_text(encoding='utf-8')):
            if '://' in target or target.startswith('#'):
                continue
            resolved = (path.parent / target.split('#')[0]).resolve()
            if not resolved.is_relative_to(root.resolve()) or not resolved.exists():
                raise ValueError(f'Unresolved local link in {path.name}')
    inventory = json.loads((root / 'docs/migration/inventory.json').read_text(encoding='utf-8'))
    ids = set()
    for row in inventory['candidates']:
        if row['id'] in ids:
            raise ValueError('Duplicate candidate ID')
        ids.add(row['id'])
        if row['retained'] and row['dto'] and row['dto'] not in catalog:
            raise ValueError('Retained DTO has no catalog entry')
        if row['source'] == 'SRC-B' and 'provenance' in row:
            raise ValueError('Private provenance must remain external')
        if row['decision'] not in ('extract', 'adapt', 'defer', 'exclude'):
            raise ValueError('Unknown migration decision')
    print(f'{len(schemas)} draft schemas/examples and {len(ids)} inventory rows validated; no runtime certification implied.')


if __name__ == '__main__':
    validate()
