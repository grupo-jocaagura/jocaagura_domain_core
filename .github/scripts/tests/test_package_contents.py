"""Regression coverage for missing production files and unreadable pub output."""

from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'tool'))
from verify_package_contents import selected_paths, validate


def archive_log(paths, separator='/'):
    return '\n'.join([
        'MSG : Publishing example (1.0.0) to https://pub.dev:',
        'FINE: Creating .tar.gz stream containing:',
        *('    | ' + ('./' + path).replace('/', separator) for path in paths),
        'MSG : ',
        '    | Total compressed archive size: 474 KB.',
        'MSG : Validating package...',
    ])


class PackageContentsTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.files = [
            'lib/jocaagura_domain_models.dart',
            'lib/src/models/docs/model_doc_block.dart',
            'lib/src/models/docs/model_doc_document.dart',
        ]
        for name in self.files:
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('// fixture\n', encoding='utf-8')

    def test_complete_selection_accepts_nested_docs_on_both_platforms(self):
        for separator in ['/', '\\']:
            with self.subTest(separator=separator):
                self.assertEqual(validate(self.root, archive_log(self.files, separator)), 3)

    def test_original_omission_reports_both_model_parts(self):
        with self.assertRaises(ValueError) as raised:
            validate(self.root, archive_log(self.files[:1]))
        for path in self.files[1:]:
            self.assertIn(path, str(raised.exception))

    def test_absolute_git_paths_are_relative_to_the_package_root(self):
        log = archive_log(self.files)
        for path in self.files:
            log = log.replace('./' + path, str(self.root / path))
        self.assertEqual(validate(self.root, log), 3)

    def test_new_library_files_are_required_without_a_hardcoded_model_list(self):
        (self.root / 'lib/new_model.dart').write_text('// fixture\n', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, 'lib/new_model.dart'):
            validate(self.root, archive_log(self.files))

    def test_root_docs_cannot_accidentally_be_published(self):
        with self.assertRaisesRegex(ValueError, 'Root documentation'):
            validate(self.root, archive_log([*self.files, 'docs/PROJECT_CONTEXT.md']))

    def test_wrong_package_root_cannot_pass_vacuously(self):
        with self.assertRaisesRegex(ValueError, 'No library files'):
            validate(self.root / 'absent', archive_log(self.files))

    def test_missing_truncated_duplicate_or_changed_format_fails_closed(self):
        complete = archive_log(self.files)
        for log in ['', 'Package has 0 warnings.', complete.split('MSG : \n')[0],
                    complete + '\n' + complete, complete.replace('FINE:', 'DEBUG:')]:
            with self.subTest(log=log[:80]), self.assertRaises(ValueError):
                selected_paths(log, self.root)

    def test_external_paths_are_rejected(self):
        for path in ['../lib/example.dart', '/lib/example.dart', 'C:/lib/example.dart']:
            log = archive_log(self.files).replace('./lib/jocaagura_domain_models.dart', path)
            with self.subTest(path=path), self.assertRaises(ValueError):
                selected_paths(log, self.root)
