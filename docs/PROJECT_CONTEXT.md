# Project context: issue #10 released core

Canonical work: https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/10.
Current work is the finite selection in migration/CORE_SELECTION.md; CP-1 was
committed before implementation. The candidate implements 15 foundation APIs,
three supporting symbols and two localization values, preserving released Utils/Unit.
All 1,712 rows retain IDs and architectural decisions. Vertical contracts are outside
core and have no implementation obligation here. Sources remain frozen SRC-A and
SRC-B/EV-B-0001; EV-B-0002 remains historical.

The maintainer accepted the corrected candidate and explicitly authorized its
release. Implementation PR #11 and preparation/evidence PR #12 reached develop;
the existing Actions prepared 1.0.1 then promoted 1.1.0. Both supervised develop
windows restored original protections. Official release PR #13 merged at
942c4bb3bc68c22c5087e0e65f050456b71fc63c; immutable v1.1.0 points there.
Ordinary OIDC publisher run 34863152318 uploaded 1.1.0. The downloaded archive
matches the exact release and passes all 239 packaged tests. Internal certification
is approved; see certification/ISSUE_10_RELEASE.md and ISSUE_10_REVIEW.md.
Never move the tag or reupload 1.1.0. Future work needs its own issue and evidence.
Historical records below are not new coverage or review.

# Historical issue #3 and release context

Canonical work: [issue #3](https://github.com/grupo-jocaagura/jocaagura_domain_core/issues/3).
Bootstrap #1 is closed. Manual 0.0.2 publication is complete. At issue start,
remote develop/master pointed to 2184d8420fe8b6bb67bd66e6205d1ca1f69ddfc3.
Historical bootstrap reports are dated evidence, not current instructions.

The selected stable API remains Utils, Unit.value and unit. See the
[stable contract](migration/STABLE_API.md), [inventory](migration/INVENTORY.md),
[migration plan](migration/PLAN.md) and [DTO catalog](DTO/README.md).
Inventory-only classes are not shipped.

SRC-A is intentionally frozen at jocaagura_domain 1.43.0,
56f7eba8a6041160ecf1c1501745c1249e124670 after the maintainer update.
SRC-B is frozen under EV-B-0001; EV-B-0002 is historical extraction evidence.
Exact private provenance stays outside all public checkouts and archives.
Both sources are read-only. Additional consumers: none. Never expand the search
universe or refresh a revision merely to eliminate unknowns.

The maintainer selected SRC-B as the priority reference for Either, including its
async support. Preserve the abstract vs sealed/final compatibility difference in
future migration planning; this preference alone adds no runtime class to core.

Authorized release sequence: ordinary PRs to develop; Actions Prepare version
0.0.4; Prepare promotion from_version=0.0.4, bump=major; official develop -> master
PR; immutable v1.0.0 on its exact merged commit; controlled CP-0 tag dispatch.
Only actual upload, archive and audit attribution can pass CP-0; record evidence
in a follow-up PR. No 0.0.4 upload, Actions redesign or source migration is in scope.

Reinspect live rules before operations. Preserve signatures, CI and immutable
tags. The accepted maintenance-window policy permits only minimal supervised
exceptions with restoration on success/failure. A rejected action requires
concrete maintainer intervention, never an alternate bypass.

Release result: Actions prepared 0.0.4 and promoted 1.0.0. Official PR #7 merged
at eec39c68daef102e2d52009e6bd2f015063ed473; immutable v1.0.0 points there.
Controlled run 34788211069 published 1.0.0 using GitHub OIDC. The actual archive
and maintainer-provided pub.dev audit entry match; CP-0 passed. See
certification/ISSUE_3_RELEASE.md and .github/evidence/cp0-1.0.0.json for evidence.
All supervised windows restored the original protections. The sources remain
read-only. Preserve v1.0.0 and never repeat its upload. Future extraction or
promotion is separately scoped; the canonical issue records integration status.
