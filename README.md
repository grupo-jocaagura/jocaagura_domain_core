# jocaagura_domain_core

Pure Dart shared domain for interoperability between Jocaagura backend applications.

**State: local development scaffold, version 0.0.1.** No domain extraction,
public release, GitHub setup, or package certification has been completed yet.
There are no runtime dependencies and no invented placeholder API.

The core will contain shared contracts and immutable value models whose semantics
are demonstrated by actual consumers. HTTP handlers, persistence, authentication
providers, environment configuration, Flutter widgets, inference runtimes and
server startup belong to adapters or applications.

## Continue the project

Read [AGENTS.md](AGENTS.md) and [the project handoff](docs/PROJECT_CONTEXT.md).
The first implementation issue must inventory existing backend contracts,
identify at least two intended consumers, and propose an extraction boundary.
Do not copy entire application models merely because their names look generic.

## Local validation

```sh
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings .
dart test
python -m pip install -r .github/scripts/requirements.txt
python -m unittest discover -s .github/scripts/tests -v
python tool/verify_documentation.py
```

The boundary test protects the initial source tree; it does not certify domain
behavior. There are currently no executable library lines, so the inherited
full CI coverage gate deliberately fails until real contracts and tests exist.
Do not add dummy functions or lower the 95% threshold to make a scaffold green.

See [.github/CI_CD.md](.github/CI_CD.md) for GitHub setup, first manual publication,
minor/major promotion, tag immutability, and the new package's pending CP-0.
Documentary certification is internal and evidence-based; it is not an external
accreditation. See [the certification process](docs/certification/README.md).
