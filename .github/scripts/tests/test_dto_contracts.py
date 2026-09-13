"""The public catalog is checked through the existing tooling test suite."""
import json
from pathlib import Path
import sys
import unittest

from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'tool'))
from verify_dto_docs import validate


class DtoDocumentationTests(unittest.TestCase):
    def test_catalog_links_examples_and_retained_candidates(self):
        validate(ROOT)

    def test_draft_output_schema_preserves_negative_postal_code_discrepancy(self):
        schema = json.loads((ROOT / 'docs/DTO/v1/address.schema.json').read_text())
        sample = json.loads((ROOT / 'docs/DTO/v1/examples/address.example.json').read_text())
        sample['postalCode'] = -1
        validator = Draft202012Validator(schema)
        self.assertTrue(validator.is_valid(sample))
        sample['postalCode'] = '001'
        self.assertFalse(validator.is_valid(sample))

    def test_error_output_enum_does_not_accept_decoder_fallback_inputs(self):
        schema = json.loads((ROOT / 'docs/DTO/v1/error-item.schema.json').read_text())
        sample = json.loads((ROOT / 'docs/DTO/v1/examples/error-item.example.json').read_text())
        sample['errorLevel'] = 'SEVERE'
        self.assertFalse(Draft202012Validator(schema).is_valid(sample))
