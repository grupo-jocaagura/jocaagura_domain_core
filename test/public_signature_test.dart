import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';
import 'package:test/test.dart';

enum _State { ready, done }

// These assignments compile the published optional/named/generic shapes.
// Behavioral edge cases live in the characterization tests, not in this probe.
void main() {
  test('published constructors and all 30 helper tear-offs still compile', () {
    final Utils constructible = Utils();
    const String Function(int) phone = Utils.getFormattedPhoneNumber;
    const String Function(int) phoneAlt = Utils.getFormattedPhoneNumberAlt;
    const String Function(int) legacyPhone = Utils.getFormatedPhoneNumber;
    const String Function(int) legacyPhoneAlt = Utils.getFormatedPhoneNumberAlt;
    const String Function(Map<String, dynamic>) mapString = Utils.mapToString;
    const String Function(Map<String, dynamic>) encode = Utils.getJsonEncode;
    const Map<String, dynamic> Function(dynamic) map = Utils.mapFromDynamic;
    const List<Map<String, dynamic>> Function(dynamic) list =
        Utils.listFromDynamic;
    const String Function(dynamic) email = Utils.getEmailFromDynamic;
    const String Function(dynamic) url = Utils.getUrlFromDynamic;
    const bool Function(String) isEmail = Utils.isEmail;
    const bool Function(String) isUrl = Utils.isValidUrl;
    const List<String> Function(String?) jsonList = Utils.convertJsonToList;
    const String Function(dynamic, {String defaultValue}) text =
        Utils.getStringFromDynamic;
    const bool Function(dynamic, {bool? defaultValueIfNull}) boolean =
        Utils.getBoolFromDynamic;
    const int Function(dynamic, {int defaultValue}) integer =
        Utils.getIntegerFromDynamic;
    const double Function(dynamic, [double]) decimal = Utils.getDouble;
    const String? Function(dynamic) normalize = Utils.normalizeNumberString;
    const bool Function<T>(List<T>, List<T>) listEquals = Utils.listEquals;
    const int Function<T>(List<T>) listHash = Utils.listHash;
    const bool Function(dynamic, dynamic) deepEquals = Utils.deepEqualsDynamic;
    const bool Function(Map<String, dynamic>, Map<String, dynamic>) mapEquals =
        Utils.deepEqualsMap;
    const int Function(dynamic) deepHash = Utils.deepHash;
    const int Function(Duration) durationEncode = Utils.durationToJson;
    const Duration Function(dynamic, {Duration defaultDuration})
    durationDecode = Utils.durationFromJson;
    const T Function<T extends Enum>(List<T>, String?, T) enumDecode =
        Utils.enumFromJson;
    const List<String> Function(dynamic) strings = Utils.stringListFromDynamic;
    const String Function(String, [int]) prefixed = Utils.generatePrefixedId;
    const String Function({String prefix, int byteLength}) token =
        Utils.generateSecureToken;
    const String Function(String) safeId = Utils.safeId;
    expect(constructible, isA<Utils>());
    expect(<Function>[
      phone,
      phoneAlt,
      legacyPhone,
      legacyPhoneAlt,
      mapString,
      encode,
      map,
      list,
      email,
      url,
      isEmail,
      isUrl,
      jsonList,
      text,
      boolean,
      integer,
      decimal,
      normalize,
      listEquals,
      listHash,
      deepEquals,
      mapEquals,
      deepHash,
      durationEncode,
      durationDecode,
      enumDecode,
      strings,
      prefixed,
      token,
      safeId,
    ], hasLength(30));
    expect(enumDecode<_State>(_State.values, null, _State.ready), _State.ready);
  });

  test(
    'completion preserves errors and legitimate nullable payloads',
    () async {
      Future<Unit> complete(Future<void> Function() operation) async {
        await operation();
        return Unit.value;
      }

      const Unit success = Unit.value;
      const Unit legacy = unit;
      final Future<String?> absentPayload = Future<String?>.value();
      expect(identical(success, legacy), isTrue);
      expect(identical(await complete(() async {}), success), isTrue);
      expect(await absentPayload, isNull);
      final StateError failure = StateError('synthetic failure');
      await expectLater(
        complete(() async => throw failure),
        throwsA(same(failure)),
      );
    },
  );
}
