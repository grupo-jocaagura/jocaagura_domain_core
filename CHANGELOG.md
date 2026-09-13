# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

- **Added** for new features.
- **Changed** for changes in existing functionality.
- **Deprecated** for soon-to-be removed features.
- **Removed** for removed features.
- **Fixed** for bug fixes.
- **Security** for vulnerability fixes.

Development versions record repository progress; an entry does not imply a
pub.dev publication or approved certification. Keep one `Unreleased` section
for pending changes; Actions prepares version headings and dates when checks pass.

## Unreleased

### Changed

- Record the actual 1.0.0 OIDC publication, verified archive and pub.dev audit attribution; preserve the published version and immutable tag.

## [1.0.0] - 2026-09-13

### Added

#### 0.0.4

- Inventory frozen SRC-A/SRC-B candidates, overlaps, dependency boundaries and
  bounded usage evidence without migrating inventory-only APIs.
- Establish an indexed DTO documentation directory with draft address/error
  contracts, synthetic fixtures and explicit schema/code differences.
- Delimit the existing stable API and document Unit.value null-safety semantics,
  nominal identity, serialization and source-signature compatibility.

#### 0.0.2

- Extract all `Utils` helpers plus `Unit`/`unit` from existing source contracts, retaining
  their public behavior with SDK-only production dependencies.
- Add source characterization and edge-case tests, typed completion tests, a
  runnable example, and extraction provenance/compatibility evidence under issue #1.
- Expand the README with package purpose, dependency boundaries, local validation,
  contribution requirements, milestones and a documentation map for bootstrap #1.
- Record verified repository access, signing, CI results and remaining setup work
  in the bootstrap review handoff.

#### 0.0.1

- Establish the unpublished 0.0.1 documentary baseline by maintainer decision;
  the initial scaffold contained no domain implementation and claimed no certification.
- Initial pure Dart package structure, without a domain implementation yet.
- Adapted CI, version preparation, release promotion and guarded publication workflows.
- Issue-driven contribution instructions and documentary certification groundwork.

### Changed

#### 0.0.4

- Sanitize private-source provenance in current documentation, Dartdoc and tests;
  keep exact evidence outside public checkouts. Published 0.0.2 is immutable.
- Align the controlled CP-0 experiment and its fail-closed checks with the
  authorized 1.0.0 target. Real publication evidence remains pending.

#### 0.0.2

- Separate release PR authorization from publication on a protected version tag;
  retain tag push and tag-ref workflow dispatch pending package-specific setup.
- Clarify that certification follows the issue's review contract without adding
  human approvals, agents or lifecycle gates.
- Document the maintainer-configured coverage threshold of 96%, the 95% policy
  floor, and the coverage prerequisite for the planned 0.0.2 development bump.
- Require restricted version-tag creation as well as update/deletion protection,
  and distinguish GitHub token operations from pub.dev OIDC authentication.
- Establish GitHub Issues as the canonical tracker and Dart-only package
  validation as the working agreement for agents.

### Fixed

#### Unreleased

- Normalize the historical 0.0.1 notes into Keep a Changelog sections so the
  existing promotion planner can consolidate the real development history.

## [0.0.4] - 2026-09-13

### Added

- Inventory frozen SRC-A/SRC-B candidates, overlaps, dependency boundaries and
  bounded usage evidence without migrating inventory-only APIs.
- Establish an indexed DTO documentation directory with draft address/error
  contracts, synthetic fixtures and explicit schema/code differences.
- Delimit the existing stable API and document Unit.value null-safety semantics,
  nominal identity, serialization and source-signature compatibility.

### Changed

- Sanitize private-source provenance in current documentation, Dartdoc and tests;
  keep exact evidence outside public checkouts. Published 0.0.2 is immutable.
- Align the controlled CP-0 experiment and its fail-closed checks with the
  authorized 1.0.0 target. Real publication evidence remains pending.

## [0.0.2] - 2026-09-13

### Added

- Extract all `Utils` helpers plus `Unit`/`unit` from existing source contracts, retaining
  their public behavior with SDK-only production dependencies.
- Add source characterization and edge-case tests, typed completion tests, a
  runnable example, and extraction provenance/compatibility evidence under issue #1.
- Expand the README with package purpose, dependency boundaries, local validation,
  contribution requirements, milestones and a documentation map for bootstrap #1.
- Record verified repository access, signing, CI results and remaining setup work
  in the bootstrap review handoff.

### Changed

- Separate release PR authorization from publication on a protected version tag;
  retain tag push and tag-ref workflow dispatch pending package-specific setup.
- Clarify that certification follows the issue's review contract without adding
  human approvals, agents or lifecycle gates.
- Document the maintainer-configured coverage threshold of 96%, the 95% policy
  floor, and the coverage prerequisite for the planned 0.0.2 development bump.
- Require restricted version-tag creation as well as update/deletion protection,
  and distinguish GitHub token operations from pub.dev OIDC authentication.
- Establish GitHub Issues as the canonical tracker and Dart-only package
  validation as the working agreement for agents.

## [0.0.1] - 2026-09-13

### Added

- Establish the unpublished 0.0.1 documentary baseline by maintainer decision;
  the initial scaffold contained no domain implementation and claimed no certification.
- Initial pure Dart package structure, without a domain implementation yet.
- Adapted CI, version preparation, release promotion and guarded publication workflows.
- Issue-driven contribution instructions and documentary certification groundwork.
