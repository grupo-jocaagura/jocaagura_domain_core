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

### Added

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

Unpublished documentary baseline retained by maintainer decision. Bootstrap
improvements above remain unreleased until the version-preparation workflow runs.

### Added

- Initial pure Dart package structure, without a domain implementation yet.
- Adapted CI, version preparation, release promotion and guarded publication workflows.
- Issue-driven contribution instructions and documentary certification groundwork.

This is an unpublished development scaffold, not a certified release.
