# Verification record: issue #3 stable API and documentary scope

Status: VERIFIED for the bounded implementation/documentary review below.
Reviewer: Codex, author review performed 2026-09-13. This is internal review,
not independent accreditation, downstream migration approval or CP-0 evidence.

Issue: [#3](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/3).
Implementation PR: [#4](https://github.com/grupo-jocaagura/jocaagura_domain_core/pull/4).
Reviewed implementation commit: `b1db04464e30a9fb1b6f71b9863403bdec83b2af`.
GitHub reported its signature `verified=true`, `reason=valid`.

## Sources, consumers and licensing

SRC-A is the intentionally frozen public jocaagura_domain 1.43.0 commit
`56f7eba8a6041160ecf1c1501745c1249e124670`. Exact paths/lines are in the
[inventory](../migration/inventory.json). SRC-B is EV-B-0001, with declaration
and call-site mappings in the maintainer's external restricted evidence. The
historical Utils/Unit extraction remains EV-B-0002; it is not relabeled.
All source access used frozen Git reads. No source writes, builds, dependency
installation, branch changes or fetches occurred; both source status checks
were clean afterward. Additional consumer repositories: none.

No new source runtime classes or private fixtures are copied by this issue.
Existing Utils/Unit reuse and license limits remain in UTILS_EXTRACTION.md;
the package MIT license is unchanged. Future extraction needs its own provenance
and applicable rights review. Old public history and published 0.0.2 remain
immutable; this cleanup does not claim to erase historical disclosures.

## Requirement -> source -> implementation -> test -> evidence

| Requirement | Contract/source | Implementation and result |
| --- | --- | --- |
| DOM-001 bounded inventory | SRC-A frozen commit; SRC-B EV-B-0001 | 345 + 1,367 declarations across 174 + 583 selected Dart files; whole-identifier references across 328 + 1,511 Dart files and tracked Markdown. Per-row categories, closure, collision candidates, usage counts, unknowns and decisions recorded. Retained contract/call-site reviews are in PLAN/NULL_SAFETY; unselected semantics remain unknown. |
| DOM-002 compatibility and migration | Existing exports; EV-A-0444/0445 and EV-B-0117/0118 | Production executable tokens match 0.0.2 exactly. Frozen SRC-B Unit matches; Utils differs only by an inline comment and optional trailing comma. No consumer migration is claimed or required. |
| DOM-002 proposed DTO studies | EV-A-0103/0230, EV-B-0122/0108 | Address/error draft field matrices, schemas, synthetic examples, constructor differences and tolerant-parser/schema discrepancies. No DTO runtime implementation or source-model test execution is claimed. |
| QA-001 executable contracts | Public entrypoint, 30 Utils methods, Unit.value/alias | Existing characterization/edge tests plus 30 signature tear-offs, constructor compatibility, const identity, nullable payload separation and error propagation. 185 Dart tests passed; 273/273 library lines covered. |
| REL-001 archive/docs and scoped review | Sanitized public documents and comments | Clean-commit pub dry-run passed with 0 warnings; 15 intended files, 31 KB compressed. Excludes docs, tooling, private maps and local logs. Intended archive files and all tracked public text were scanned for restricted source identity/revision strings: no matches. |
| CP-0 alignment only | Controlled target, helper, dispatch gate and pending evidence | All agree on 1.0.0; old version/tag/branch, wrong SHA/provenance and unknown eligibility fail closed. Real upload/audit evidence remains pending and is separate from documentary approval. |

## Validation environment and observed results

Local: Windows x64, Dart 3.13.2, Python 3.13. Commands ran in the isolated core
worktree, never in source repositories. The direct Dart SDK executable avoided
the Flutter wrapper; no Flutter toolchain command was used.

| Actual command/check | Result |
| --- | --- |
| dart pub get | Development dependencies resolved; production dependencies remain SDK-only. |
| dart format lib test example, then zero-change check | Passed, final invocation changed 0 files. |
| dart analyze --fatal-infos --fatal-warnings . | Passed, no issues. |
| dart test --coverage=coverage/issue-3 --reporter=json | 185 non-hidden tests passed; no failed/skipped tests. |
| dart run coverage:format_coverage --lcov --in=coverage/issue-3 --out=coverage/issue-3.info --report-on=lib | Utils 268/268, Unit 5/5, combined 273/273 = 100% line coverage; not branch coverage. Configured threshold 96% preserved. |
| python -m unittest discover -s .github/scripts/tests -v | 65 tests passed, including Bash guard execution and DTO schema examples. |
| python tool/verify_dto_docs.py | 2 draft schemas/examples and 1,712 rows passed structural/fixture validation; no source runtime certification. |
| python tool/verify_documentation.py | Passed draft integrity before this scoped review; approval is recorded only after the review. |
| dart pub publish --dry-run on clean signed commit | Passed, 0 warnings, no upload. Initial dirty-tree warnings were resolved by committing, not suppressed. |
| git diff --check | Passed. |

Sandbox-only initial Bash/Dart process failures were rerun with authorized normal
process/cache access. A transient text-encoding error was corrected before the
final executable-token comparison and passing tests; it is not in the reviewed
implementation. No checks or coverage limits were disabled.

Remote evidence for the reviewed implementation:

- [Dart CI 34786510265](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34786510265): successful base validation, tests/coverage and required CI result. Release readiness skipped because this PR targets develop; that is not proof of final release readiness.
- [CodeQL 34786510156](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34786510156): Actions analysis passed.
- [Documentation 34786510129](https://github.com/grupo-jocaagura/jocaagura_domain_core/actions/runs/34786510129): draft validation passed; not semantic approval by itself.

Normalized LF SHA-256 identifiers:

| Artifact | SHA-256 |
| --- | --- |
| lib/src/utils.dart | 8eaa642833a7242b748f2b48dc34f14c36f2296ca57113a4e0bbf1e3fb26128a |
| lib/src/unit.dart | 4630575490f38ce353fb800789079ba4a9cb5c15096fa92d2e9dfe60a4bad2bf |
| test/public_signature_test.dart | 3ad447123bce7ecaf1ea8356f31408b27aa749f47cf7c70a694ba8a44728c34d |
| docs/migration/inventory.json | f650a3329f5199fc82d9351ba1e7af0f07178231485601d46853dbd9776ea8c8 |
| Local LCOV | adc016a85afd91b5b0c2c3929a5b45f2caca288ba882c60867a1b41268bc68a8 |

## Review outcome and limits

The actual diff was reviewed for SDK-only boundary, unchanged executable tokens,
private-source sanitization, DTO draft/output distinctions, declaration coverage,
library coupling, nominal identity, typed success and fail-closed CP-0 alignment.
The maintainer explicitly prioritized SRC-B Either; sealed/final incompatibility
with extensible SRC-A remains documented. PerKeyFifoExecutor cleanup and
MoneyUtils mutation risks are deferred rather than silently repaired or shipped.

The documentary manifest may approve this implemented scope and the migration
plan. That does not approve unimplemented models, prove dynamic/external usage,
claim source-runtime compatibility beyond inspected evidence, or complete #3.
Final Actions version preparation, major promotion, official release-PR checks,
tag provenance, OIDC upload, downloadable archive/hash and pub.dev activity-log
attribution remain required and are tracked in #3. CP-0 stays pending until then.

GitHub protections and immutable OIDC subject were read on 2026-09-13: ruleset
23191367 requires signed PRs/current-base checks with no bypass; 23211846 restricts
v* creation to repository admins; 23211845 blocks updates/deletion/force-push for
everyone. Actions defaults read and cannot approve PR reviews. Owner ID 193098028,
repository ID 1368617594; immutable subject enabled. The maintainer confirmed
pub.dev repository/pattern v{{version}}, workflow_dispatch/push and no required
environment in this task. This is maintainer-attested configuration, not a browser
inspection: the available Chrome session lacked administration permission.
