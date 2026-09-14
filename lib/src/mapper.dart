// Adapted from EV-B-0113; see docs/migration/CORE_SELECTION.md.
import 'model.dart';
import 'utils.dart';

/// Generic model decoder. Tolerant conversions delegate to Utils; errors propagate.
///
/// ```dart
/// import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
///
/// class Message extends Model {
///   const Message(this.text);
///   final String text;
///   @override
///   Map<String, dynamic> toJson() => <String, dynamic>{'text': text};
///   @override
///   Message copyWith({String? text}) => Message(text ?? this.text);
///   @override
///   bool operator ==(Object other) => other is Message && other.text == text;
///   @override
///   int get hashCode => text.hashCode;
/// }
/// class MessageMapper extends Mapper<Message> {
///   const MessageMapper();
///   @override
///   Message fromJson(Map<String, dynamic> json) =>
///       Message(Utils.getStringFromDynamic(json['text']));
/// }
/// void main() {
///   const MessageMapper mapper = MessageMapper();
///   assert(mapper.fromDynamic('{"text":"hello"}') == const Message('hello'));
///   assert(mapper.fromDynamicList('[{"text":"hello"}]').isEmpty);
///   assert(ModelUtils.modelFromDynamic<Message>(
///     value: <String, dynamic>{'text': 'hello'}, fromJson: mapper.fromJson,
///   ) == const Message('hello'));
/// }
/// ```
abstract class Mapper<T extends Model> {
  /// Initializes a decoder implemented by a consumer.
  const Mapper();

  /// Decodes [json] into [T] using the concrete model contract.
  ///
  /// Implementations specify required fields, defaults and errors. Callers of
  /// the convenience methods receive these errors unchanged.
  T fromJson(Map<String, dynamic> json);

  /// Returns [value] serialized through [Model.toJson].
  ///
  /// Ownership and encoding failures follow the concrete model implementation.
  Map<String, dynamic> toJson(T value) {
    return value.toJson();
  }

  /// Coerces [value] with [Utils.mapFromDynamic], then calls [fromJson].
  ///
  /// Maps and encoded JSON objects are accepted; malformed or non-map input
  /// becomes an empty map. Decoder errors propagate unchanged.
  T fromDynamic(dynamic value) {
    return fromJson(Utils.mapFromDynamic(value));
  }

  /// Decodes retained map records from [value] in order into a growable list.
  ///
  /// Only actual lists are accepted; encoded array strings become empty lists.
  /// Non-map entries are discarded. A decoder error stops iteration and propagates.
  List<T> fromDynamicList(dynamic value) {
    final List<Map<String, dynamic>> items = Utils.listFromDynamic(value);
    return items.map(fromJson).toList();
  }
}
