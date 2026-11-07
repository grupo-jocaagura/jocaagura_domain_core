"""Check the actual archive file list from a successful verbose Dart pub dry-run.

Run `dart pub publish --dry-run --verbose` first and require its exit code to be
zero. This check supplements pub's source validation; it never publishes.
"""

import argparse
from pathlib import Path, PurePosixPath, PureWindowsPath
import re


def selected_paths(log, root):
    """Read Dart's flat archive listing, not the abbreviated display tree.

    Dart 3.13.2 emits this verbose format. Unknown or incomplete output fails
    closed so a toolchain change cannot silently disable the check.
    """
    lines = log.splitlines()
    marker = 'FINE: Creating .tar.gz stream containing:'
    if lines.count(marker) != 1:
        raise ValueError('Expected exactly one Dart archive file list')
    index = lines.index(marker) + 1
    paths = set()
    while index < len(lines) and lines[index].startswith('    | '):
        value = lines[index][6:].replace('\\', '/')
        path_type = PureWindowsPath if re.match(r'^[A-Za-z]:/', value) else PurePosixPath
        path = path_type(value)
        if not value or '..' in path.parts or ':' in value.removeprefix(path.drive):
            raise ValueError(f'Unsupported archive path: {value!r}')
        # Pub may list absolute paths when Git supplies the package files.
        if path.is_absolute():
            try:
                path = path.relative_to(path_type(root.resolve()))
            except ValueError:
                raise ValueError(f'Archive path is outside the package: {value!r}') from None
        paths.add(path.as_posix())
        index += 1
    # The size message terminates the listing in the supported Dart version.
    if not paths or index + 1 >= len(lines) or lines[index] != 'MSG : ' or not re.fullmatch(
        r'    \| Total compressed archive size: .+\.', lines[index + 1],
    ):
        raise ValueError('Incomplete or unsupported Dart archive file list')
    return paths


def validate(root, log):
    paths = selected_paths(log, root)
    expected = {
        path.relative_to(root).as_posix()
        for path in (root / 'lib').rglob('*') if path.is_file()
    }
    if not expected:
        raise ValueError('No library files found; check the package root')
    missing = sorted(expected - paths)
    documentation = sorted(path for path in paths if path == 'docs' or path.startswith('docs/'))
    errors = []
    if missing:
        errors.append('Library files missing from the package:\n  ' + '\n  '.join(missing))
    if documentation:
        errors.append('Root documentation must stay excluded:\n  ' + '\n  '.join(documentation))
    if errors:
        raise ValueError('\n'.join(errors))
    return len(expected)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('log', type=Path, help='Combined stdout/stderr from the successful dry-run')
    parser.add_argument('--root', type=Path, default=Path.cwd(), help='Package directory (default: cwd)')
    args = parser.parse_args()
    try:
        count = validate(args.root, args.log.read_text(encoding='utf-8'))
    except (OSError, ValueError) as error:
        parser.exit(1, f'Package readiness failed: {error}\n')
    print(f'Package readiness passed: all {count} lib files included; root docs excluded.')


if __name__ == '__main__':
    main()
