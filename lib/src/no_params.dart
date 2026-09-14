// Adapted from EV-A-0401; see docs/migration/CORE_SELECTION.md.

/// Absence of input parameters; distinct from the Unit success output.
class NoParams {
  /// Creates a parameter marker. Equality remains ordinary object identity.
  ///
  /// Const canonicalization may reuse an instance; no custom equality is defined.
  const NoParams();
}
