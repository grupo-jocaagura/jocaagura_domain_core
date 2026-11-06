/// SDK-only values for the documented functional API projections.
///
/// These codecs do not execute HTTP, resolve credentials or provide persistence.
/// Canonical API values are distinct from tolerant legacy domain decoders.
library;

import 'dart:collection';

import 'jocaagura_domain_core.dart';

export 'jocaagura_domain_core.dart' show ErrorItem, ErrorLevelEnum;

part 'src/api/api_field.dart';
part 'src/api/api_json.dart';
part 'src/api/api_envelope.dart';
part 'src/api/api_value.dart';
part 'src/api/api_values.dart';
