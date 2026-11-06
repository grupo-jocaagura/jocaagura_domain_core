part of '../../jocaagura_domain_api.dart';

/// Base for canonical, deeply owned functional API values.
///
/// Unknown fields are discarded by concrete factories. Collections are copied
/// recursively; equality uses typed content through Utils. Ordinary maps ignore
/// insertion order; document blocks retain their published order semantics.
/// Hashes are runtime values, never persistent identifiers.
abstract class ApiValue extends Model {
  ApiValue(Map<String, Object?> fields)
    : _json = ApiJsonObject._ordered(fields);

  final ApiJsonObject _json;

  Object get _equalityFields => _json;

  @override
  Map<String, dynamic> toJson() => _json.toJson();

  @override
  // SDK-only immutable value; no annotation package is needed.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ApiValue &&
      runtimeType == other.runtimeType &&
      Utils.deepEqualsDynamic(_equalityFields, other._equalityFields);

  @override
  // SDK-only immutable value; no annotation package is needed.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(runtimeType, Utils.deepHash(_equalityFields));
}

bool _isHttpsTarget(String value) {
  // Keep the homologated URL policy, adding only this operation's HTTPS rule.
  return Utils.isValidUrl(value) && Uri.parse(value.trim()).scheme == 'https';
}

void _validateMarkdownDocument(
  ApiDocument document, {
  required bool requireContent,
}) {
  if ((requireContent && document.title.trim().isEmpty) ||
      !document.blocksByIndex.values.any(
        (ApiDocumentBlock block) =>
            block.kind == 'markdown' &&
            (!requireContent || block.content.trim().isNotEmpty),
      )) {
    throw const FormatException('The operation requires a markdown document.');
  }
}

void _validateConversationMessage(String message) {
  // Literal route policy, not a general prompt-injection detector or sanitizer.
  final String lower = message.toLowerCase();
  const List<String> denied = <String>[
    'ignore previous instructions',
    'ignora las instrucciones anteriores',
    'system prompt',
    'prompt del sistema',
    'developer message',
    'reveal your instructions',
    'muestra tus instrucciones',
    '<script',
    '```',
  ];
  if (denied.any(lower.contains)) {
    throw const FormatException(
      'Message contains text prohibited by this route.',
    );
  }
}

void _validateRelativeTarget(String target) {
  final String value = target.trim();
  final Uri? uri = Uri.tryParse(value);
  if (uri == null ||
      !value.startsWith('/') ||
      value.startsWith('//') ||
      uri.hasScheme ||
      uri.hasAuthority ||
      value.contains(r'\') ||
      value.contains('/../') ||
      value.endsWith('/..')) {
    throw const FormatException(
      'Expected the documented relative target path.',
    );
  }
}

// Designer permits any URI scheme with a host; Utils.isValidUrl intentionally
// has a narrower http/https/ftp policy and must not be changed for this route.
bool _hasSchemeAndHost(String value) {
  final Uri? uri = Uri.tryParse(value);
  return uri != null && uri.hasScheme && uri.host.isNotEmpty;
}

void _validateDesignNumbers(Iterable<num> values, {num? maximum}) {
  if (values.any(
    (num value) => value < 0 || (maximum != null && value > maximum),
  )) {
    throw const FormatException(
      'Design numeric value is outside its declared range.',
    );
  }
}

void _validateDesignSections(
  ApiField<Map<String, String>?> branding,
  ApiField<Map<String, ApiDesignSemanticColors>?> semantic,
) {
  if (branding.isPresent &&
      branding.value != null &&
      branding.value!.isNotEmpty &&
      ((branding.value!['owner'] ?? '').trim().isEmpty ||
          (branding.value!['product'] ?? '').trim().isEmpty)) {
    throw const FormatException(
      'Nonempty branding requires owner and product.',
    );
  }
  if (semantic.isPresent &&
      semantic.value != null &&
      semantic.value!.isNotEmpty &&
      (!semantic.value!.containsKey('light') ||
          !semantic.value!.containsKey('dark'))) {
    throw const FormatException(
      'Semantic colors require light and dark entries.',
    );
  }
}

void _validateCanonicalId(
  String value, {
  int? maximumRunes,
  bool rejectControls = false,
}) {
  if (value.isEmpty ||
      value.trim() != value ||
      value.contains('/') ||
      value == '.' ||
      value == '..' ||
      (maximumRunes != null && value.runes.length > maximumRunes) ||
      (rejectControls && RegExp(r'[\x00-\x1f\x7f]').hasMatch(value))) {
    throw const FormatException('Expected a canonical functional identifier.');
  }
}

void _validateMovementInput(
  String direction,
  String category,
  String occurredAt,
  String scope,
) {
  final Set<String> allowed = scope == 'commerce.store'
      ? <String>{'$scope.direct.$direction', '$scope.adjustment.$direction'}
      : <String>{'$scope.$direction', '$scope.adjustment.$direction'};
  if (!allowed.contains(category.trim()) ||
      DateTime.tryParse(occurredAt.trim()) == null) {
    throw const FormatException(
      'Movement category/date is incompatible with its context.',
    );
  }
}

void _validateActivationInput(
  String action,
  ApiField<String> order,
  ApiField<String> onboarding,
  ApiField<int> revision,
  ApiField<ApiActivationDraftInput> draft,
) {
  if (action == 'start') {
    if (!order.isPresent ||
        onboarding.isPresent ||
        revision.isPresent ||
        draft.isPresent) {
      throw const FormatException('Start accepts only an order ID.');
    }
    _validateCanonicalId(order.value, maximumRunes: 256, rejectControls: true);
  } else {
    if (!onboarding.isPresent ||
        order.isPresent ||
        (action == 'save' && (!revision.isPresent || !draft.isPresent)) ||
        (action == 'advance' && draft.isPresent)) {
      throw const FormatException('Invalid activation action members.');
    }
    _validateCanonicalId(onboarding.value);
  }
  // Whether advance may omit revision depends on the server's sealed state.
}

void _validateActivationStage(String stage, String action) {
  final String expected = switch (stage) {
    'collecting_data' || 'validating_data' => 'provide_data',
    'awaiting_person_readiness' => 'complete_person_readiness',
    'completed' => 'none',
    _ => 'advance',
  };
  if (action != expected) {
    throw const FormatException('Activation stage and next action disagree.');
  }
}

void _validatePermissionSelection(
  String module,
  ApiField<List<String>?> selection,
) {
  if (selection.isPresent &&
      selection.value != null &&
      selection.value!.any(
        (String key) =>
            key.trim().isNotEmpty &&
            !_apiPermissionCatalog[module]!.contains(key.trim()),
      )) {
    throw const FormatException(
      'Unknown public permission key for this module.',
    );
  }
}

void _validateAssignmentReason(String reason, ApiField<String?> operation) {
  final String normalized = reason.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (normalized.length < 8 || normalized.length > 500) {
    throw const FormatException(
      'Assignment reason must have 8 to 500 normalized characters.',
    );
  }
  final String id = _optionalApiText(operation).trim();
  if (id.isNotEmpty && !RegExp(r'^[A-Za-z0-9._:-]{8,128}$').hasMatch(id)) {
    throw const FormatException('Invalid assignment operation ID.');
  }
}

void _validateAdminLimit(ApiField<String> field) {
  if (!field.isPresent || field.value.trim().isEmpty) {
    return;
  }
  // The query contract uses integer syntax (including hex), unlike Utils'
  // deliberately tolerant decimal coercion for legacy payload numbers.
  final int? limit = int.tryParse(field.value.trim());
  if (limit == null || limit < 1 || limit > 200) {
    throw const FormatException('Administrative query limit must be 1 to 200.');
  }
}

void _validateQueryChoice(ApiField<String> field, Set<String> choices) {
  if (field.isPresent &&
      field.value.trim().isNotEmpty &&
      !choices.contains(field.value.trim())) {
    throw const FormatException('Unknown administrative query choice.');
  }
}

void _validateOnboardingGraph(Map<String, (int, int, int)> steps) {
  if (steps.isEmpty) {
    throw const FormatException('A flow must have steps.');
  }
  final Map<int, int> incoming = <int, int>{};
  final Map<int, List<int>> outgoing = <int, List<int>>{};
  for (final MapEntry<String, (int, int, int)> entry in steps.entries) {
    final int index = entry.value.$1;
    if (index < 0 || entry.key != index.toString()) {
      throw const FormatException(
        'Flow index/key mismatch. Use canonical decimal keys.',
      );
    }
    incoming[index] = 0;
    outgoing[index] = <int>[
      entry.value.$2,
      entry.value.$3,
    ].where((int target) => target != -1).toList();
  }
  for (final List<int> targets in outgoing.values) {
    for (final int target in targets) {
      if (!incoming.containsKey(target)) {
        throw const FormatException('Flow target does not exist.');
      }
      incoming[target] = incoming[target]! + 1;
    }
  }
  final List<int> ready = <int>[
    for (final int key in incoming.keys)
      if (incoming[key] == 0) key,
  ];
  int visited = 0;
  while (ready.isNotEmpty) {
    final int index = ready.removeLast();
    visited++;
    for (final int target in outgoing[index]!) {
      incoming[target] = incoming[target]! - 1;
      if (incoming[target] == 0) {
        ready.add(target);
      }
    }
  }
  if (visited != steps.length) {
    throw const FormatException(
      'A published onboarding flow cannot contain cycles.',
    );
  }
}

// Exact lexical restrictions published for these text fields; not an HTML sanitizer.
bool _containsActiveMarkup(String value) => RegExp(
  r'<\s*/?\s*(script|iframe|object|embed|form|svg)\b|\bon[a-z0-9_-]+\s*=|javascript\s*:',
  caseSensitive: false,
).hasMatch(value);

void _validateUtcWindow(
  String start,
  String end, {
  bool strict = false,
  bool emptyEndAllowed = false,
  int? maximumDays,
}) {
  if (emptyEndAllowed && end.isEmpty) {
    return;
  }
  if (!DateTimeIsoUtils.isSameOrAfter(end, start) || (strict && start == end)) {
    throw const FormatException('The UTC interval has invalid ordering.');
  }
  if (maximumDays != null) {
    final DateTime begin = DateTimeIsoUtils.tryParseCanonicalUtc(start)!;
    final DateTime finish = DateTimeIsoUtils.tryParseCanonicalUtc(end)!;
    if (finish.difference(begin) > Duration(days: maximumDays)) {
      throw const FormatException(
        'The UTC interval exceeds its documented range.',
      );
    }
  }
}

void _validateAcademicRole(String memberType, String role) {
  final Set<String> allowed = memberType == 'customerSnapshot'
      ? <String>{'student', 'guardian', 'other'}
      : <String>{
          'leadTeacher',
          'assistantTeacher',
          'academicCoordinator',
          'observer',
          'other',
        };
  if (!allowed.contains(role)) {
    throw const FormatException(
      'Academic role is incompatible with member type.',
    );
  }
}

String _optionalApiText(ApiField<String?> field) =>
    field.isPresent ? (field.value ?? '') : '';

void _validateGradeEvaluationInput(
  String type,
  ApiField<String?> id,
  ApiField<String?> label,
  ApiField<String?> code,
) {
  final String idValue = _optionalApiText(id).trim();
  final String labelValue = _optionalApiText(label).trim();
  final String codeValue = _optionalApiText(code).trim();
  if (type == 'manualMilestone') {
    if (idValue.isNotEmpty ||
        codeValue.isNotEmpty ||
        labelValue.length < 3 ||
        labelValue.length > 120) {
      throw const FormatException(
        'A manual milestone needs a label and no selected reference ID/code.',
      );
    }
  } else if (idValue.isEmpty || labelValue.isNotEmpty || codeValue.isNotEmpty) {
    throw const FormatException(
      'Academic reference input needs an ID and no client-selected label/code.',
    );
  }
}

void _validateGradeInput(
  String kind,
  ApiGradeEvaluationInput reference,
  ApiGradeResultInput result,
) {
  if ((kind == 'milestone') != (reference.refType == 'manualMilestone')) {
    throw const FormatException(
      'Grade kind and evaluation reference disagree.',
    );
  }
  if (kind == 'numericScore') {
    final double score = Utils.getDouble(
      result.score.isPresent ? result.score.value : null,
      0,
    );
    final double maxScore = Utils.getDouble(
      result.maxScore.isPresent ? result.maxScore.value : null,
      0,
    );
    if (!score.isFinite ||
        !maxScore.isFinite ||
        maxScore <= 0 ||
        score < 0 ||
        score > maxScore) {
      throw const FormatException(
        'Numeric grade score/maxScore are outside the declared range.',
      );
    }
  } else if (kind == 'qualitativeLevel' &&
      !<String>{
        'pending',
        'developing',
        'achieved',
        'exceeded',
      }.contains(_optionalApiText(result.qualitativeLevel).trim())) {
    throw const FormatException(
      'A qualitative result requires a published level.',
    );
  }
}

void _validateGradeResult(
  String kind,
  ApiGradeEvaluationRef reference,
  ApiGradeResult result,
) {
  if ((kind == 'milestone') != (reference.refType == 'manualMilestone')) {
    throw const FormatException('Grade kind and hydrated reference disagree.');
  }
  if (kind == 'numericScore') {
    if (result.maxScore <= 0 ||
        result.score < 0 ||
        result.score > result.maxScore ||
        result.qualitativeLevel != 'notApplicable') {
      throw const FormatException('Invalid normalized numeric result.');
    }
  } else {
    final String? milestoneLevel = kind == 'milestone'
        ? (result.passed ? 'achieved' : 'pending')
        : null;
    if (result.score != 0 ||
        result.maxScore != 0 ||
        (milestoneLevel != null && result.qualitativeLevel != milestoneLevel) ||
        (kind == 'qualitativeLevel' &&
            result.qualitativeLevel == 'notApplicable')) {
      throw const FormatException(
        'Invalid normalized qualitative/milestone result.',
      );
    }
  }
}

void _validateScheduleReferences(
  String? kind,
  ApiField<List<String>?> groups,
  ApiField<List<String>?> staff,
  ApiField<String?> program,
  ApiField<String?> unit,
  ApiField<List<ApiAcademyReferenceInput>?> refs,
) {
  final List<String> groupIds = groups.isPresent
      ? (groups.value ?? <String>[])
      : <String>[];
  final List<String> staffIds = staff.isPresent
      ? (staff.value ?? <String>[])
      : <String>[];
  if (kind == 'class' &&
      (!groupIds.any((String id) => id.trim().isNotEmpty) ||
          !staffIds.any((String id) => id.trim().isNotEmpty))) {
    throw const FormatException('A class requires group and staff references.');
  }
  if (_optionalApiText(program).trim().isEmpty &&
      (_optionalApiText(unit).trim().isNotEmpty ||
          (refs.isPresent && (refs.value?.isNotEmpty ?? false)))) {
    throw const FormatException(
      'A unit/academy reference requires program context.',
    );
  }
}

void _validateInventoryInput(
  int quantity,
  ApiField<int?> minimum,
  ApiField<int?> maximum,
) {
  final int? minValue = minimum.isPresent ? minimum.value : null;
  final int? maxValue = maximum.isPresent ? maximum.value : null;
  if (maxValue != null &&
      (quantity > maxValue || (minValue != null && minValue > maxValue))) {
    throw const FormatException(
      'Inventory quantity/minimum exceeds its maximum.',
    );
  }
}

void _validatePaymentSummary(
  String status,
  String? cause,
  String verification,
  bool terminal,
  String action,
) {
  if (status == 'open' && (cause != null || terminal)) {
    throw const FormatException(
      'An open obligation has no closure cause and is not terminal.',
    );
  }
  if (status == 'closed' && (cause == null || !terminal || action != 'none')) {
    throw const FormatException(
      'A closed obligation is terminal, has a cause and needs no economic action.',
    );
  }
  if (cause == 'settled' && verification != 'approved') {
    throw const FormatException('Settlement requires approved verification.');
  }
}

void _validateMediaUploadRequest(
  String intent,
  ApiMediaSubject subject,
  String contentType,
  int sizeBytes,
  ApiField<String?> description,
) {
  const Map<String, (String, String, int)> limits =
      <String, (String, String, int)>{
        'people_me.profilePhoto': ('people_me', 'person', 1048576),
        'commerce.itemImage': ('commerce', 'inventoryItem', 512000),
        'commerce.storePhoto': ('commerce', 'store', 512000),
        'commerce.storeCover': ('commerce', 'store', 1048576),
      };
  final (String, String, int)? expected = limits[intent];
  if (expected == null ||
      subject.contextKey != expected.$1 ||
      subject.resourceType != expected.$2) {
    throw const FormatException(
      'Media subject does not match the documented intent.',
    );
  }
  final RegExp identity = RegExp(r'^[A-Za-z0-9_.:-]{1,160}$');
  if (!identity.hasMatch(subject.resourceId.trim())) {
    throw const FormatException(
      'Invalid functional media resource identifier.',
    );
  }
  final Set<String> mime = intent == 'people_me.profilePhoto'
      ? <String>{'image/jpeg', 'image/webp'}
      : <String>{'image/jpeg', 'image/webp', 'image/png'};
  if (!mime.contains(contentType.trim()) || sizeBytes > expected.$3) {
    throw const FormatException(
      'Media content type or size exceeds the intent contract.',
    );
  }
  if (description.isPresent && (description.value?.trim().length ?? 0) > 500) {
    throw const FormatException(
      'Media description exceeds 500 trimmed characters.',
    );
  }
}
