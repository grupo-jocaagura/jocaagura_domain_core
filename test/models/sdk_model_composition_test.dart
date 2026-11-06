import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart' as core;
import 'package:jocaagura_domain_core/jocaagura_domain_models.dart';
import 'package:test/test.dart';

void main() {
  test('source models share the released core nominal identity', () {
    const PersonModel person = PersonModel(
      id: 'person-1',
      names: 'Example',
      lastNames: 'Person',
      photoUrl: '',
      attributes: <String, AttributeModel<dynamic>>{},
    );
    const core.Model value = person;
    const core.Either<core.ErrorItem, core.Model> result =
        core.Right<core.ErrorItem, core.Model>(value);
    expect(result.isRight, isTrue);
    expect(value.copyWith(), person);
    expect(jsonDecode(jsonEncode(value.toJson())), person.toJson());
    expect(identical(unit, core.unit), isTrue);
  });

  test('legacy address output and API request validation remain separate', () {
    const AddressModel legacy = AddressModel(
      country: '',
      administrativeArea: '',
      city: '',
      locality: '',
      address: '',
      postalCode: -1,
    );
    expect(AddressModel.fromJson(legacy.toJson()), legacy);
    expect(legacy.id, '');
    expect(legacy.copyWith(notes: 'note').postalCode, -1);
  });

  test(
    'icon identity preserves nullable fields and supports explicit clearing',
    () {
      const ModelIconData icon = ModelIconData(
        codePoint: 0xe001,
        fontFamily: 'ExampleFont',
        fontPackage: 'example',
        matchTextDirection: true,
      );
      expect(ModelIconData.fromJson(icon.toJson()), icon);
      expect(ModelIconData.fromJson(icon.toJson()).hashCode, icon.hashCode);
      expect(icon.copyWith(), icon);
      final ModelIconData cleared = icon.copyWith(
        fontFamily: null,
        fontPackage: null,
      );
      expect(cleared.fontFamily, isNull);
      expect(cleared.fontPackage, isNull);
      expect(cleared.codePoint, icon.codePoint);
      expect(cleared, isNot(icon));
      expect(
        icon
            .copyWith(codePoint: 1, matchTextDirection: false)
            .matchTextDirection,
        isFalse,
      );
      expect(
        () => ModelIconData.fromJson(<String, dynamic>{'codePoint': '1'}),
        throwsA(isA<TypeError>()),
      );
      expect(
        ModelIconData.fromJson(<String, dynamic>{'codePoint': 1})
            .matchTextDirection,
        isFalse,
      );
      expect(icon == Object(), isFalse);
    },
  );

  test(
    'menu data serializes without callbacks, fonts or a rendering runtime',
    () {
      const ModelIconData icon = ModelIconData(codePoint: 1);
      const ModelMainMenuModel menu = ModelMainMenuModel(
        iconData: icon,
        label: 'Home',
      );
      expect(ModelMainMenuModel.fromJson(menu.toJson()), menu);
      expect(
        ModelMainMenuModel.fromJson(menu.toJson()).hashCode,
        menu.hashCode,
      );
      expect(menu.copyWith(), menu);
      expect(menu.copyWith(label: 'Other'), isNot(menu));
      expect(menu.copyWith(description: 'Open home').description, 'Open home');
      expect(
        menu.copyWith(iconData: icon.copyWith(codePoint: 2)).iconData.codePoint,
        2,
      );
      expect(menu.toJson().containsKey('onPressed'), isFalse);
      expect(menu == Object(), isFalse);
      expect(
        ModelMainMenuModel.fromJson(<String, dynamic>{
          'iconData': icon.toJson(),
          'label': 'Home',
        }),
        menu,
      );
      expect(
        () => ModelMainMenuModel.fromJson(<String, dynamic>{}),
        throwsA(isA<TypeError>()),
      );
    },
  );

  test('parameter values retain data and callbacks without performing I/O', () {
    const UserModel user = defaultUserModel;
    expect(const ReadParams('id').docId, 'id');
    expect(const DeleteParams('id').docId, 'id');
    expect(const WatchParams('id').docId, 'id');
    expect(const WriteParams<UserModel>('id', user).entity, user);
    final MutateParams<UserModel> mutate = MutateParams<UserModel>(
      'id',
      (UserModel current) => current.copyWith(displayName: 'Updated'),
    );
    expect(mutate.docId, 'id');
    expect(mutate.transform(user).displayName, 'Updated');
    final EnsureParams<UserModel> ensure = EnsureParams<UserModel>(
      docId: 'id',
      create: () => user,
      updateIfExists: (UserModel current) =>
          current.copyWith(displayName: 'Existing'),
    );
    expect(ensure.docId, 'id');
    expect(ensure.create(), user);
    expect(ensure.updateIfExists!(user).displayName, 'Existing');
    expect(
      EnsureParams<UserModel>(docId: 'id', create: () => user).updateIfExists,
      isNull,
    );
    expect(
      const PatchParams('id', <String, dynamic>{'x': null}).patch,
      containsPair('x', null),
    );
    expect(const PatchParams('id', <String, dynamic>{}).docId, 'id');
    expect(const ReadManyParams(<String>['id']).ids, <String>['id']);
    expect(const DeleteManyParams(<String>['id']).ids, <String>['id']);
    expect(
      const WriteManyParams<UserModel>(<String, UserModel>{'id': user})
          .entries['id'],
      user,
    );
  });

  test('session and document states use canonical user/error/model types', () {
    const Authenticated authenticated = Authenticated(defaultUserModel);
    expect(authenticated.user, isA<core.Model>());
    expect(const Refreshing(authenticated).previous, authenticated);
    expect(const Unauthenticated(), isA<SessionState>());
    expect(const Authenticating(), isA<SessionState>());
    const core.ErrorItem error = core.ErrorItem(
      title: 'Example',
      code: 'E',
      description: 'Synthetic',
    );
    expect(const SessionError(error).error, same(error));
    expect(const SessionError(error).message, same(error));
    final WsDbState<UserModel> idle = WsDbState<UserModel>.idle();
    final WsDbState<UserModel> populated = idle.copyWith(
      doc: defaultUserModel,
      error: error,
      loading: true,
      docId: 'id',
      isWatching: true,
    );
    expect(populated.doc, defaultUserModel);
    expect(populated.copyWith(), populated);
    expect(populated.copyWith().hashCode, populated.hashCode);
    expect(populated.copyWith(doc: null, error: null).doc, isNull);
    expect(populated.copyWith(error: null).error, isNull);
    expect(populated.toString(), contains('hasDoc: true'));
    expect(populated, isNot(idle));
    expect(populated == Object(), isFalse);
    expect(() => populated.copyWith(doc: 'wrong'), throwsA(isA<TypeError>()));
  });

  test(
    'configuration is data only and round trips independently of an adapter',
    () {
      const WsDbConfig config = WsDbConfig(
        latency: Duration(milliseconds: 2),
        throwOnSave: true,
        throwOnDelete: true,
        emitInitial: false,
        deepCopies: false,
        dedupeByContent: false,
        orderCollectionsByKey: false,
        idKey: 'key',
      );
      expect(WsDbConfig.fromJson(config.toJson()), config);
      expect(WsDbConfig.fromJson(config.toJson()).hashCode, config.hashCode);
      expect(config.copyWith(), config);
      expect(config, isNot(defaultWsDbConfig));
      expect(config == Object(), isFalse);
      expect(config.toString(), isNotEmpty);
      const ScreenSizeConfig layout = screenSizeConfig;
      expect(layout.mobileColumnsNumber, 4);
    },
  );
}
