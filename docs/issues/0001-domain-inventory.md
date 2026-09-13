# Local issue draft: inventory and first shared domain extraction

Status: proposed; no GitHub issue has been created.
This filename is a local proposal identifier, not GitHub issue #1 (bootstrap).
After promotion, replace local status tracking with a link to the canonical
GitHub issue; do not evolve both copies independently.

## Problem

Jocaagura backend applications need shared contracts without depending on an
application's server, framework, transport or persistence implementation.

## Scope

Inspect actual source contracts and consumers, identify shared semantics, and
propose the smallest useful extraction. Record repository, commit, path, license,
serialization/error semantics, compatibility requirements and migration impact.
Define a bounded implementation issue after the inventory is reviewed.

## Exclusions

No server deployment, speculative generalized APIs, breaking consumer migration,
runtime dependencies or publication as part of this inventory.

## Acceptance criteria

- [ ] Source inventory has exact repository/commit/path provenance.
- [ ] At least two intended consumers and their interoperability needs are named.
- [ ] Proposed contracts have explicit invariants and compatibility boundaries.
- [ ] Existing application-specific behavior remains outside the shared package.
- [ ] Extraction, tests, examples and documentary evidence are planned together.
- [ ] Open decisions and required consumer migrations are explicit.

## Validation and certification

Link the inventory and review to docs/certification/manifest.json. Inspection is
not implementation, and documentation structure validation is not certification.
