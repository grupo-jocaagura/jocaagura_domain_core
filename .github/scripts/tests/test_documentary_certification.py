"""Check that draft, stale and escaped evidence cannot masquerade as approval."""
from copy import deepcopy
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
SPEC = importlib.util.spec_from_file_location('documentary', ROOT / 'tool/verify_documentation.py')
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class DocumentaryTests(unittest.TestCase):
    def test_real_manifest_is_consistent_and_draft_cannot_pass_approval(self):
        manifest = json.loads((ROOT / 'docs/certification/manifest.json').read_text())
        self.assertEqual(MODULE.validate(ROOT, manifest), manifest['status'])
        if manifest['status'] == 'approved':
            self.assertEqual(MODULE.validate(ROOT, manifest, True), 'approved')
        draft = deepcopy(manifest)
        draft['status'] = 'draft'
        with self.assertRaises(ValueError):
            MODULE.validate(ROOT, draft, True)

    def test_evidence_integrity_boundaries(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            report = root / 'docs/certification/report.md'
            report.parent.mkdir(parents=True)
            report.write_text('Synthetic test evidence', encoding='utf-8')
            entry = {'id': 'TEST-1', 'description': 'Fixture', 'status': 'verified',
                     'report': 'docs/certification/report.md', 'sha256': hashlib.sha256(report.read_bytes()).hexdigest()}
            manifest = {'package': 'jocaagura_domain_core', 'status': 'approved',
                        'reviewed_by': 'Synthetic fixture', 'reviewed_at': '2026-01-01', 'requirements': [entry]}
            self.assertEqual(MODULE.validate(root, manifest, True), 'approved')
            for field, value in [('report', '../../outside.md'), ('sha256', '0' * 64), ('status', 'pending')]:
                wrong = deepcopy(manifest)
                wrong['requirements'][0][field] = value
                with self.subTest(field=field), self.assertRaises(ValueError):
                    MODULE.validate(root, wrong, True)
            for wrong in [dict(manifest, requirements=[]), dict(manifest, reviewed_by=None),
                          dict(manifest, requirements=[entry, entry]), dict(manifest, reviewed_at='2999-01-01')]:
                with self.assertRaises(ValueError):
                    MODULE.validate(root, wrong, True)


if __name__ == '__main__':
    unittest.main()
