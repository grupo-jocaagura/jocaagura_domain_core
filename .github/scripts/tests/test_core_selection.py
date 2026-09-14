"""Fail closed on missing inventory evidence or silently broadened selections."""
import copy
import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'tool'))
from verify_core_selection import digest, validate


class CoreSelectionTests(unittest.TestCase):
    def setUp(self):
        self.selection = json.loads((ROOT / 'docs/migration/core_selection.json').read_text(encoding='utf-8'))
        self.architecture = json.loads((ROOT / 'docs/migration/architecture_inventory.json').read_text(encoding='utf-8'))

    def test_actual_selection_and_inventory_are_consistent(self):
        self.assertEqual(validate(ROOT), (1712, 20))

    def test_changed_signature_invalidates_freeze(self):
        self.selection['symbols'][0]['signatures'].append('invented()')
        with self.assertRaisesRegex(ValueError, 'content hash'):
            validate(ROOT, self.selection)

    def test_changed_signature_is_rejected_even_with_recomputed_hash(self):
        # Given contract drift, when its self-hash is recomputed, then reject it.
        self.selection['symbols'][0]['signatures'].append('invented()')
        self.selection['selection_sha256'] = digest(self.selection)
        with self.assertRaisesRegex(ValueError, 'independently pinned freeze'):
            validate(ROOT, self.selection)

    def test_unknown_architecture_revision_is_rejected(self):
        self.architecture['selection_revision'] = 'CP-1-v1.1'
        with self.assertRaisesRegex(ValueError, 'Architecture revision'):
            validate(ROOT, architecture=self.architecture)

    def test_self_rehashed_amendment_cannot_change_the_anchor(self):
        self.selection['amendments'][0]['previous_selection_sha256'] = '0' * 64
        self.selection['selection_sha256'] = digest(self.selection)
        with self.assertRaisesRegex(ValueError, 'independently pinned freeze'):
            validate(ROOT, self.selection)

    def test_missing_duplicate_and_reassigned_rows_are_rejected(self):
        for mutate in ('missing', 'duplicate', 'evidence'):
            with self.subTest(mutate=mutate):
                bad = copy.deepcopy(self.architecture)
                if mutate == 'missing':
                    bad['candidates'].pop()
                elif mutate == 'duplicate':
                    bad['candidates'][1] = bad['candidates'][0]
                else:
                    bad['candidates'][0]['evidence'] = 'EV-B-0002'
                with self.assertRaises(ValueError):
                    validate(ROOT, architecture=bad)

    def test_vertical_dependency_cannot_enter_even_with_recomputed_hash(self):
        self.selection['symbols'][0]['dependencies'].append('FinancialMovementModel')
        self.selection['selection_sha256'] = digest(self.selection)
        with self.assertRaisesRegex(ValueError, 'independently pinned freeze'):
            validate(ROOT, self.selection)

    def test_incomplete_admission_and_missing_library_fail(self):
        for field, value in [('admission', ['one answer']), ('source_library', 'missing')]:
            with self.subTest(field=field):
                bad = copy.deepcopy(self.architecture)
                bad['candidates'][0][field] = value
                with self.assertRaises(ValueError):
                    validate(ROOT, architecture=bad)
