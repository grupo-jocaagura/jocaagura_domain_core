"""Validate internal evidence structure and hashes, without asserting external certification."""
import argparse
from datetime import date
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def validate(root, manifest, require_approved=False):
    if manifest.get('package') != 'jocaagura_domain_core':
        raise ValueError('Unexpected package identity')
    status = manifest.get('status')
    if status not in ('draft', 'approved') or (require_approved and status != 'approved'):
        raise ValueError('Documentary approval is incomplete')
    requirements = manifest.get('requirements')
    if not isinstance(requirements, list) or not requirements:
        raise ValueError('Nonempty requirement matrix is required')
    seen = set()
    for entry in requirements:
        identifier = entry.get('id')
        if not isinstance(identifier, str) or not identifier.strip() or identifier in seen:
            raise ValueError('Requirement IDs must be unique and nonempty')
        seen.add(identifier)
        if not isinstance(entry.get('description'), str) or not entry['description'].strip():
            raise ValueError('Requirement description is missing')
        if entry.get('status') not in ('pending', 'verified'):
            raise ValueError('Unknown requirement status')
        if status == 'approved' and entry['status'] != 'verified':
            raise ValueError('Approved manifest contains pending requirements')
        if entry['status'] == 'verified':
            relative = entry.get('report')
            if not isinstance(relative, str) or Path(relative).is_absolute():
                raise ValueError('Repository-relative report path is required')
            report = (root / relative).resolve()
            if not report.is_relative_to((root / 'docs/certification').resolve()) or not report.is_file():
                raise ValueError('Evidence report must stay inside docs/certification')
            if hashlib.sha256(report.read_bytes()).hexdigest() != entry.get('sha256'):
                raise ValueError('Stale or invalid evidence report hash')
    if status == 'approved':
        if not isinstance(manifest.get('reviewed_by'), str) or not manifest['reviewed_by'].strip():
            raise ValueError('Named reviewer is required')
        if date.fromisoformat(manifest['reviewed_at']) > date.today():
            raise ValueError('Review date is in the future')
    return status


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--require-approved', action='store_true')
    args = parser.parse_args()
    try:
        manifest = json.loads((ROOT / 'docs/certification/manifest.json').read_text(encoding='utf-8'))
        status = validate(ROOT, manifest, args.require_approved)
    except (ValueError, OSError, KeyError, TypeError, AttributeError) as error:
        parser.exit(1, f'Documentary verification failed: {error}\n')
    print(f'Document structure and referenced hashes valid; status={status}. No external certification implied.')


if __name__ == '__main__':
    main()
