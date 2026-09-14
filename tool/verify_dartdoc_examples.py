"""Compile and run the complete issue #10 DartDoc programs with SDK assertions.

Run dart pub get first. This uses only Python's standard library and Dart;
temporary programs stay in .dart_tool and never enter the package archive.
"""
import argparse
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
FILES = (
    'either', 'error_item', 'mapper', 'date_time_iso_utils', 'date_utils',
    'clock_policy', 'debouncer', 'per_key_fifo_executor', 'model_language',
    'model_localized_text',
)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dart', default='dart', help='Standalone Dart SDK executable')
    args = parser.parse_args()
    config = ROOT / '.dart_tool/package_config.json'
    if not config.is_file():
        raise SystemExit('Run dart pub get first')
    count = 0
    with tempfile.TemporaryDirectory(prefix='dartdoc-', dir=config.parent) as folder:
        for name in FILES:
            source = (ROOT / f'lib/src/{name}.dart').read_text(encoding='utf-8')
            comments = '\n'.join(re.findall(r'^\s*/// ?(.*)$', source, re.M))
            snippets = re.findall(r'```dart\n(.*?)\n```', comments, re.S)
            if not snippets:
                raise SystemExit(f'Missing executable DartDoc example: {name}')
            for index, snippet in enumerate(snippets):
                program = Path(folder) / f'{name}_{index}.dart'
                program.write_text(snippet + '\n', encoding='utf-8')
                subprocess.run([
                    args.dart, f'--packages={config}', '--enable-asserts', str(program),
                ], cwd=ROOT, check=True, timeout=30)
                count += 1
                print(f'Passed: {name} example {index + 1}')
    print(f'{count} DartDoc programs compiled and passed assertions')


if __name__ == '__main__':
    main()
