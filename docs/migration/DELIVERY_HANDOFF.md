# Issue #15 delivery handoff

The model implementation is complete locally on
`feature/15-migrate-api-models-dart-only`. Signed implementation commit:
`546ed330d72f92f8767dc603daf123e3c7bd1fbd`. Documentation/evidence consolidation
follows it. No push or PR has been performed. Issue #15 remains open; its final
delivery item and MODEL-DELIVERY in the draft manifest remain pending.

## Reproduce and inspect

```sh
git status --short --branch
git log --oneline origin/feature/15-migrate-api-models-dart-only..HEAD
git verify-commit 546ed330d72f92f8767dc603daf123e3c7bd1fbd
python tool/verify_model_migration.py --require-complete
python tool/generate_api_values.py --check --dart <standalone-dart-executable>
```

Read `docs/certification/ISSUE_15_MODELS.md`, its sanitized validation JSON and
named local review for the exact commands, compatibility findings and limits.
The final full Dart suite passed 1,470 tests with 26,595/27,053 covered lines
(98.307%, required 96%). Strict analysis, formatting, 81 Python automation tests,
actionlint, validators, examples and the clean package dry run passed.
On Windows use the standalone SDK executable and put Git Bash before the Windows
Bash alias on the process PATH for the workflow tests. No Flutter tooling is used.

Exact private EV-B-15 provenance is retained outside all public checkouts and
archives. Never copy that mapping into this repository, even into ignored folders.
No downstream application was migrated or built by these checks.

## Authorized remote delivery

The working agreement requires scope authorization for a remote push. After that
authorization, push this focused branch without force and open a PR into develop,
linked to issue #15. Keep release/publication and downstream changes separate.

Suggested PR title: **Complete pure Dart domain and functional API model migration**.

Suggested PR description:

> Closes #15.
>
> Complete the missing shared domain with 83 source files/215 declarations and
> 408 functional API values covering all 183 documented operations. New model,
> API and mapper libraries use only the Dart SDK; Flutter conversions, callbacks
> and infrastructure stay in adapters. Homologated Utils comparisons/hashes,
> explicit presence/null semantics and documented compatibility corrections
> prevent duplicate domain meaning across consumers.
>
> Validation: 1,470 Dart tests; 98.307% line coverage (96% required); strict
> analysis/format; 81 Python workflow/release tests; actionlint; documentary,
> historical core/DTO and complete migration validators; reproducible generation;
> executable examples; package dry run with zero warnings. The evidence and named
> local review are in docs/certification/ISSUE_15_MODELS.md and its references.
>
> Certification remains draft until final PR/delivery evidence is recorded. No
> deployed integration, real payment, downstream migration or release is claimed.

After opening the PR, record its URL and actual remote CI results in issue #15
and the certification record. Fix relevant failures without bypassing checks.
Only close acceptance/delivery items when supported; do not infer deployment or
consumer adoption from successful local codecs or structural documentation checks.
