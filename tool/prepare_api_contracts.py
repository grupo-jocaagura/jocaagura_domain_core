"""Extract review proposals from frozen API examples, never certify inference.

Examples establish observed shapes, not required fields or complete contracts.
Each proposal must be reconciled with its operation/shared-schema prose before
being admitted as an implemented contract. Private provenance stays external.
"""

import argparse
import json
from pathlib import Path
import re

from prepare_model_migration import ROOT, archive, write_json


def shape(value):
    if value is None:
        return {"type": "unknown", "nullable": True}
    if isinstance(value, bool):
        return {"type": "boolean"}
    if isinstance(value, str):
        return {"type": "string"}
    if isinstance(value, int):
        return {"type": "integer"}
    if isinstance(value, float):
        return {"type": "number"}
    if isinstance(value, list):
        return {"type": "array", "items": merge_all(shape(v) for v in value)}
    return {"type": "object", "properties": {k: shape(v) for k, v in value.items()}}


def merge(left, right):
    if left == right:
        return left
    if left["type"] == "unknown":
        return {**right, **({"nullable": True} if left.get("nullable") else {})}
    if right["type"] == "unknown":
        return merge(right, left)
    if left["type"] != right["type"]:
        if {left["type"], right["type"]} == {"integer", "number"}:
            return {"type": "number", **({"nullable": True} if left.get("nullable") or right.get("nullable") else {})}
        return {"type": "json", "observed_types": sorted({left["type"], right["type"]})}
    result = dict(left)
    if right.get("nullable"):
        result["nullable"] = True
    if result["type"] == "object":
        a, b = left.get("properties", {}), right.get("properties", {})
        result["properties"] = {
            k: merge(a[k], b[k]) if k in a and k in b
            else {**(a.get(k) or b[k]), "observed_omission": True}
            for k in sorted(a.keys() | b.keys())
        }
    if result["type"] == "array":
        result["items"] = merge(left["items"], right["items"])
    return result


def merge_all(values):
    result = {"type": "unknown"}
    for value in values:
        result = merge(result, value)
    return result


def examples(text):
    request, response = [], []
    decoder = json.JSONDecoder()
    for block in re.finditer(r"```(json|http)\s*\n(.*?)```", text, re.S):
        content = block[2]
        for candidate in re.finditer(r"(?m)^\s*(?=[{\[])", content):
            try:
                value, _ = decoder.raw_decode(content[candidate.end():].lstrip())
            except ValueError:
                continue
            if block[1] == "http":
                request.append(value)
            elif isinstance(value, dict) and value.get("ok") is True and "data" in value:
                response.append(value["data"])
            elif isinstance(value, dict) and "ok" not in value:
                request.append(value)
    return request, response


def unknowns(schema, path=""):
    if schema["type"] == "unknown":
        yield path or "$"
    for key, value in schema.get("properties", {}).items():
        yield from unknowns(value, f"{path}.{key}" if path else key)
    if schema["type"] == "array":
        yield from unknowns(schema["items"], path + "[]")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--restricted-input", type=Path, required=True)
    args = parser.parse_args()
    provenance = json.loads(args.restricted_input.read_text(encoding="utf-8"))
    files = archive(Path(provenance["api_root"]), provenance["api_commit"])
    by_evidence = {r["evidence"]: r["path"] for r in provenance["api_documents"]}
    matrix = json.loads((ROOT / "docs/migration/model_migration.json").read_text(encoding="utf-8"))
    rows = []
    for op in matrix["operations"]:
        text = files[by_evidence[op["evidence"]]].decode("utf-8")
        requests, responses = examples(text)
        req, res = merge_all(map(shape, requests)), merge_all(map(shape, responses))
        rows.append({"operation": op["id"], "evidence": op["evidence"], "module": op["module"],
                     "status": "unreviewed_inference", "request_examples": len(requests),
                     "response_examples": len(responses), "request": req, "response": res,
                     "unresolved_request_shapes": list(unknowns(req)),
                     "unresolved_response_shapes": list(unknowns(res))})
    write_json(ROOT / "docs/migration/api_contract_proposals.json", {
        "issue": 15, "status": "draft", "method": "Example shape inference; NOT a canonical schema",
        "operations": rows,
    })
    for module in sorted({r["module"] for r in rows}):
        subset = [r for r in rows if r["module"] == module]
        print(f"{module}: {len(subset)} operations; "
              f"{sum(bool(r['response_examples']) for r in subset)} with success examples; "
              f"{sum(len(r['unresolved_response_shapes']) for r in subset)} unresolved output shapes")


if __name__ == "__main__":
    main()
