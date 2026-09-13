# Internal documentary certification

This process records evidence and accountable review. It is not external
accreditation, a legal certificate, or proof supplied by a passing CI badge alone.

For each extraction, maintain requirement -> source -> implementation -> test ->
result -> review. Use TEMPLATE.md and link the report from the issue and PR.
Record exact source commits, public contract/version compatibility and migration.

The machine-readable manifest lists requirements as pending or verified.
Each verified requirement needs a report file and its SHA-256. For an approved
manifest every requirement must be verified, and reviewed_by/reviewed_at must be
set after actual review. Hashes detect changes; they do not prove semantic truth.
The report must identify the verified implementation commit and real check/run
results. Keep pending decisions explicit and refresh evidence after changes.

Run `python tool/verify_documentation.py` to validate structure and referenced
file integrity. Draft success means only that the draft is consistent.
Run `python tool/verify_documentation.py --require-approved` for a release review;
it must fail while the manifest is draft. Approval is an internal review record,
not a cryptographic signature. Do not invent reviewer identities or completed runs.

The certification workflow validates documents separately from Dart CI. Neither
its success nor a copied source-project report certifies this package's domain.
Attach the approved report and executable validation evidence to release review.
