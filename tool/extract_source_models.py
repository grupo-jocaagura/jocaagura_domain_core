"""Reproduce issue #15's public-source extraction; never modifies source repos.

This is preparation tooling, not a runtime dependency. Inspect the actual diff
and run analyzer/behavior tests after extraction. Existing target files are not
overwritten, so subsequent reviewed fixes are preserved.
"""

import argparse
import json
from pathlib import Path
import re

from prepare_model_migration import PUBLIC_REVISION, ROOT, archive


def adapt(text, path):
    text = re.sub(r"^part of [^;]+;\s*", "", text, count=1)
    text = re.sub(r"^@immutable\s*\n", "", text, flags=re.M)
    text = re.sub(r"^[ \t]*debugPrint\([^\n]*\);[ \t]*\n", "", text, flags=re.M)
    if path.endswith("model_vector.dart"):
        text = re.sub(r"  /// Creates a \[ModelVector\] from an \[Offset\].*?\n  }\n", "", text, flags=re.S)
        text = re.sub(r"  /// Converts this \[ModelVector\] into an \[Offset\].\n  Offset get offset => Offset\(dx, dy\);\n", "", text)
        text = text.replace("and conversion to [Offset]", "without a rendering dependency")
        text = re.sub(r"^///   print\('Offset:.*\n", "", text, flags=re.M)
    if path.endswith("databases_crud_usecases.dart"):
        text = text[text.index("/// Parameters for read-like"):text.index("// ---------------------------------------------------------------------------")]
    # Match the released core's narrowly scoped SDK-only equality annotation.
    text = re.sub(r"^([ \t]*)(bool operator ==|int get hashCode)",
                  r"\1// SDK-only value contract; no external annotation dependency.\n"
                  r"\1// ignore: avoid_equals_and_hash_code_on_mutable_classes\n\1\2", text, flags=re.M)
    return text


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", type=Path, required=True)
    parser.add_argument("--with-tests", action="store_true")
    args = parser.parse_args()
    files = archive(args.source_root, PUBLIC_REVISION)
    matrix = json.loads((ROOT / "docs/migration/model_migration.json").read_text(encoding="utf-8"))
    parts = []
    for row in matrix["source_files"]:
        target = ROOT / row["target"]
        parts.append(row["target"].removeprefix("lib/"))
        if target.exists() or row["path"].endswith("model_main_menu_model.dart"):
            continue
        text = adapt(files[row["path"]].decode("utf-8"), row["path"])
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(
            f"// Adapted from jocaagura_domain 1.43.0 (MIT), {PUBLIC_REVISION}.\n"
            f"// Source: {row['path']}; see docs/migration/MODEL_MIGRATION.md.\n"
            "part of '../../../jocaagura_domain_models.dart';\n\n" + text,
            encoding="utf-8",
        )
        # Part URI depends on depth in the public package, not on source layout.
        depth = len(Path(row["target"]).parts) - 2
        text = target.read_text(encoding="utf-8").replace(
            "part of '../../../jocaagura_domain_models.dart';",
            "part of '" + "../" * depth + "jocaagura_domain_models.dart';",
        )
        target.write_text(text, encoding="utf-8")
    barrel = ROOT / "lib/jocaagura_domain_models.dart"
    if not barrel.exists():
        barrel.write_text(
            "/// SDK-only domain models shared by backend and Flutter adapters.\n"
            "///\n/// Legacy wire/ownership semantics are documented in the migration guide.\n"
            "/// Rendering and framework conversions belong to consumers.\nlibrary;\n\n"
            "import 'dart:async';\nimport 'dart:convert';\nimport 'dart:math';\n\n"
            "import 'jocaagura_domain_core.dart';\n\n"
            "export 'jocaagura_domain_core.dart';\n\n"
            + "\n".join(f"part '{p}';" for p in sorted(parts)) + "\n",
            encoding="utf-8",
        )
    if args.with_tests:
        selected_names = {decl["name"] for row in matrix["source_files"]
                          for decl in row["declarations"]}
        count = 0
        for path, contents in sorted(files.items()):
            if not path.endswith("_test.dart") or not path.startswith(("test/domain/", "test/user_model")):
                continue
            relative = Path(path).parts[2:]
            if (set(relative[:-1]) & {"blocs", "common_errors", "usecases", "internationalization"}
                    or Path(path).name.startswith(("bloc_", "entity_", "either", "debouncer", "mock_"))
                    or Path(path).name in {"main_menu_model_test.dart", "virtual_crud_service_test.dart", "http_request_errors_test.dart"}):
                continue
            text = contents.decode("utf-8")
            used = set(re.findall(r"\b[A-Za-z]\w*\b", text)) & selected_names
            if not used:
                continue
            text = text.replace("package:flutter_test/flutter_test.dart", "package:test/test.dart")
            text = text.replace("package:jocaagura_domain/jocaagura_domain.dart",
                                "package:jocaagura_domain_core/jocaagura_domain_models.dart")
            if Path(path).name == "model_vector_test.dart":
                text = re.sub(r"    test\('(fromOffset|offset getter|offset conversion)[\s\S]*?\n    }\);\n", "", text)
            target = ROOT / "test/models" / path.removeprefix("test/")
            if not target.exists():
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text("// Characterization adapted from public SRC-A 1.43.0 (MIT).\n" + text, encoding="utf-8")
                count += 1
        mock = "test/mock_animal.dart"
        target = ROOT / "test/models/mock_animal.dart"
        if not target.exists():
            target.write_text(files[mock].decode("utf-8").replace(
                "package:jocaagura_domain/jocaagura_domain.dart",
                "package:jocaagura_domain_core/jocaagura_domain_models.dart"), encoding="utf-8")
        print(f"Prepared {count} SDK-only source characterization files; no source test run is inherited.")
    print(f"Prepared {len(parts)} model parts. No source runtime executed; validation is required.")


if __name__ == "__main__":
    main()
