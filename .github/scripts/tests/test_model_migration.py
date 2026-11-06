"""Reject dropped/reassigned contracts and stale migration evidence."""
import copy
import hashlib
import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'tool'))
from verify_model_migration import local, validate


class ModelMigrationTests(unittest.TestCase):
    def setUp(self):
        self.matrix = json.loads((ROOT / 'docs/migration/model_migration.json').read_text(encoding='utf-8'))

    def test_actual_complete_candidate_has_no_pending_model_entries(self):
        self.assertEqual(validate(ROOT, require_complete=True), (83, 183, 408, 0))

    def test_self_rehashed_source_selection_cannot_drop_a_model(self):
        self.matrix['source_files'].pop()
        rows = [{k: r[k] for k in ('path', 'sha256', 'declarations', 'target')} for r in self.matrix['source_files']]
        self.matrix['source_selection_sha256'] = hashlib.sha256(json.dumps(rows, sort_keys=True, ensure_ascii=False, separators=(',', ':')).encode()).hexdigest()
        with self.assertRaisesRegex(ValueError, 'independently pinned'):
            validate(ROOT, matrix=self.matrix)

    def test_operation_cannot_disappear_even_if_declared_count_changes(self):
        self.matrix['operations'].pop()
        self.matrix['api']['operations'] -= 1
        with self.assertRaisesRegex(ValueError, 'omitted catalog'):
            validate(ROOT, matrix=self.matrix)

    def test_evidence_cannot_be_reassigned_or_rehashed(self):
        self.matrix['api']['document_hashes']['EV-B-15-0004'] = '0' * 64
        self.matrix['api']['fingerprint'] = hashlib.sha256(json.dumps(sorted(self.matrix['api']['document_hashes'].items()), separators=(',', ':')).encode()).hexdigest()
        with self.assertRaisesRegex(ValueError, 'independently pinned'):
            validate(ROOT, matrix=self.matrix)

    def test_stale_source_implementation_hash_is_rejected(self):
        self.matrix['source_files'][0]['target_sha256'] = '0' * 64
        with self.assertRaisesRegex(ValueError, 'Stale implementation'):
            validate(ROOT, matrix=self.matrix)

    def test_pending_operation_cannot_pass_complete_validation(self):
        self.matrix['operations'][0]['status'] = 'pending'
        with self.assertRaisesRegex(ValueError, 'remains incomplete'):
            validate(ROOT, require_complete=True, matrix=self.matrix)

    def test_unknown_contract_and_unjustified_exclusion_are_rejected(self):
        for change in ('unknown', 'unjustified'):
            with self.subTest(change=change):
                matrix = copy.deepcopy(self.matrix)
                operation = matrix['operations'][0]
                if change == 'unknown':
                    operation['contracts'] = ['ApiInventedValue']
                else:
                    operation['status'] = 'not_a_model'
                with self.assertRaises(ValueError):
                    validate(ROOT, matrix=matrix)

    def test_external_evidence_file_paths_are_not_allowed(self):
        with self.assertRaisesRegex(ValueError, 'external'):
            local(ROOT, '../outside-test.dart')
