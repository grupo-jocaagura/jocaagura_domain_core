"""Freeze issue #15 source/API inventories without executing source applications.

Read Git archives in memory. Private provenance is written ONLY to the explicitly
supplied external file, never to a checkout (including ignored directories).
The public inventory records contracts and hashes, not private source paths.
"""

import argparse
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import tarfile

ROOT = Path(__file__).resolve().parents[1]
PUBLIC_REVISION = "56f7eba8a6041160ecf1c1501745c1249e124670"
DECLARATION = re.compile(
    r"^(?:(?:abstract|sealed|final|base|interface)\s+)*(class|enum|typedef|mixin|extension)\s+([A-Za-z]\w*)",
    re.M,
)
BASELINE_PATHS = {
    "lib/domain/error_item_model.dart", "lib/domain/internationalization/model_language.dart",
    "lib/domain/internationalization/model_localized_text.dart", "lib/domain/either.dart",
    "lib/domain/entity_util.dart", "lib/domain/debouncer.dart", "lib/domain/usecases/no_params.dart",
    "lib/date_utils.dart", "lib/per_key_fifo_executor.dart", "lib/unit.dart", "lib/utils.dart",
}
EXCLUDED_DIRECTORIES = {
    "blocs", "common_errors", "gateways", "repositories", "services", "usecases",
}
EXCLUDED_FILES = {
    "bloc.dart", "bloc_core.dart", "bloc_general.dart", "bloc_module.dart",
    "entity_bloc.dart", "entity_provider.dart", "entity_service.dart",
    "virtual_crud_service.dart", "http_request_errors.dart",
}


def archive(root, revision):
    data = subprocess.check_output(["git", "-C", str(root), "archive", revision])
    with tarfile.open(fileobj=io.BytesIO(data)) as source:
        return {entry.name: source.extractfile(entry).read() for entry in source if entry.isfile()}


def model_path(path):
    if not path.startswith("lib/domain/") or not path.endswith(".dart") or path in BASELINE_PATHS:
        return False
    pieces = Path(path).parts[2:]
    return not (set(pieces[:-1]) & EXCLUDED_DIRECTORIES or pieces[-1] in EXCLUDED_FILES)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", type=Path, required=True)
    parser.add_argument("--api-root", type=Path, required=True)
    parser.add_argument("--api-revision", default="HEAD")
    parser.add_argument("--restricted-output", type=Path, required=True)
    args = parser.parse_args()
    restricted = args.restricted_output.resolve()
    if restricted.exists():
        parser.error("Use a fresh external evidence file; never overwrite historical provenance")
    for parent in restricted.parents:
        if (parent / ".git").exists():
            parser.error("Restricted provenance must stay outside every checkout")
    public = archive(args.source_root, PUBLIC_REVISION)
    api_revision = subprocess.check_output(
        ["git", "-C", str(args.api_root), "rev-parse", args.api_revision], text=True,
    ).strip()
    api = archive(args.api_root, api_revision)
    api = {p: v for p, v in api.items() if p.startswith("docs/api/")}
    if "docs/api/catalogo.json" not in api:
        parser.error("The selected Git revision does not contain the homologated API catalog")
    old = json.loads((ROOT / "docs/migration/inventory.json").read_text(encoding="utf-8"))
    historical = {(r["provenance"]["path"], r["api"]): r["id"]
                  for r in old["candidates"] if r["source"] == "SRC-A"}
    source_rows = []
    for path, content in sorted(public.items()):
        if not model_path(path):
            continue
        text = content.decode("utf-8")
        declarations = [{"name": name, "kind": kind,
                         "historical_id": historical.get((path, name))}
                        for kind, name in DECLARATION.findall(text)]
        source_rows.append({
            "path": path, "sha256": sha(content), "declarations": declarations,
            "target": "lib/src/models/" + path.removeprefix("lib/domain/"),
            "status": "selected", "tests": [],
            "adaptation": "Flutter menu value split" if path.endswith("model_main_menu_model.dart")
            else "Offset conversions move to Flutter adapter" if path.endswith("model_vector.dart")
            else "preserve SDK-compatible data behavior; remove framework coupling",
        })
    # Parameter values are data even though their source also defines execution.
    params = "lib/domain/usecases/databases_crud/databases_crud_usecases.dart"
    params_text = public[params].decode("utf-8")
    source_rows.append({
        "path": params, "sha256": sha(public[params]), "declarations": [
            {"name": name, "kind": kind, "historical_id": historical.get((params, name))}
            for kind, name in DECLARATION.findall(params_text) if name.endswith("Params")
        ], "target": "lib/src/models/request_parameters.dart", "status": "selected",
        "tests": [], "adaptation": "extract parameter values only; execution stays in consumers",
    })
    private_rows = []
    document_ids = {}
    for index, (path, content) in enumerate(sorted(api.items()), 1):
        identifier = f"EV-B-15-{index:04d}"
        document_ids[path] = identifier
        private_rows.append({"evidence": identifier, "path": path, "sha256": sha(content)})
    catalog = json.loads(api["docs/api/catalogo.json"])
    operations = []
    for entry in catalog["operations"]:
        path = "docs/api/" + entry["documentationPath"]
        if path not in api:
            parser.error("A catalog operation has no sheet in the selected snapshot")
        operations.append({
            "id": entry["operationId"], "method": entry["method"], "path": entry["path"],
            "module": entry["module"], "evidence": document_ids[path],
            "sha256": sha(api[path]), "status": "pending", "contracts": [], "tests": [],
        })
    sheets = {p for p in api if p.startswith("docs/api/rutas/") and p.endswith(".md")}
    listed = {"docs/api/" + e["documentationPath"] for e in catalog["operations"]}
    doc_fingerprint = sha(json.dumps(
        sorted((document_ids[p], sha(v)) for p, v in api.items()), separators=(",", ":"),
    ).encode())
    matrix = {
        "issue": 15, "revision": "issue-15-inventory-v1", "status": "draft",
        "source": {"package": "jocaagura_domain", "version": "1.43.0", "commit": PUBLIC_REVISION,
                   "license_sha256": sha(public["LICENSE"])},
        "api": {"source": "SRC-B", "snapshot": "EV-B-15", "fingerprint": doc_fingerprint,
                "documents": len(api), "operations": len(operations),
                "uncatalogued_sheet_evidence": sorted(document_ids[p] for p in sheets - listed)},
        "source_files": source_rows, "operations": operations,
        "limitations": ["Selection is not implementation, review or deployed integration.",
                         "Lexical source declarations are checked by the Dart analyzer after extraction.",
                         "API contracts require per-operation implementation and behavioral evidence."],
    }
    write_json(restricted, {"issue": 15, "source_root": str(args.source_root.resolve()),
                           "api_root": str(args.api_root.resolve()), "api_commit": api_revision,
                           "api_documents": private_rows})
    write_json(ROOT / "docs/migration/model_migration.json", matrix)
    print(f"Selected {len(source_rows)} public source files; {len(operations)} API operations; "
          f"{len(sheets - listed)} uncatalogued sheets. Implementation remains pending.")


if __name__ == "__main__":
    main()
