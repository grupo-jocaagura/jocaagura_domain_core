import 'dart:convert';
import 'dart:io';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

void main() {
  final Map<String, dynamic> fixtures = jsonDecode(
    File('test/fixtures/additional-api-messages.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  Map<String, Object?> wire(String name) =>
      Map<String, Object?>.from(fixtures['Api$name'] as Map<String, dynamic>);

  test(
    'document block order is meaningful, including within a parent record',
    () {
      final Map<String, Object?> source = wire('Document');
      final ApiDocument first = ApiDocument.fromJson(source);
      final Map<String, ApiDocumentBlock> reversed = <String, ApiDocumentBlock>{
        for (final String key in first.blocksByIndex.keys.toList().reversed)
          key: first.blocksByIndex[key]!,
      };
      final ApiDocument second = first.copyWith(blocksByIndex: reversed);
      expect(first.blocksByIndex.keys.toList(), <String>['10', '2']);
      expect(
        (first.toJson()['blocksByIndex'] as Map<String, dynamic>).keys.toList(),
        <String>['10', '2'],
      );
      expect(first, isNot(second));
      expect(
        ApiDocument.fromJson(
          jsonDecode(jsonEncode(first.toJson())) as Map<String, Object?>,
        ),
        first,
      );
      final ApiDocumentRecord parent = ApiDocumentRecord.fromJson(
        wire('DocumentRecord'),
      );
      expect(parent, isNot(parent.copyWith(document: second)));
      expect(parent.document.blocksByIndex.keys.toList(), <String>['10', '2']);
      expect(parent.copyWith().hashCode, parent.hashCode);
      final Map<String, dynamic> envelope = ApiSuccess<ApiDocumentRecord>(
        parent,
      ).toJson((ApiDocumentRecord value) => value.toJson());
      final ApiEnvelope<ApiDocumentRecord> decodedEnvelope =
          ApiEnvelope<ApiDocumentRecord>.fromJson(
            jsonDecode(jsonEncode(envelope)) as Map<String, Object?>,
            ApiDocumentRecord.fromJson,
          );
      expect((decodedEnvelope as ApiSuccess<ApiDocumentRecord>).data, parent);
      expect(
        decodedEnvelope.data.document.blocksByIndex.keys.toList(),
        <String>['10', '2'],
      );
    },
  );
  test(
    'markdown requirements differ between quotation and simulator product',
    () {
      final ApiDocument emptyMarkdown = ApiDocument(
        id: 'example',
        title: '',
        blocksByIndex: <String, ApiDocumentBlock>{
          'first': ApiDocumentBlock(kind: 'markdown', content: ''),
        },
      );
      expect(
        ApiQuotationInput(document: emptyMarkdown).document,
        emptyMarkdown,
      );
      expect(
        () => ApiProductDocumentInput(document: emptyMarkdown),
        throwsFormatException,
      );
      final ApiDocument noId = emptyMarkdown.copyWith(
        id: '',
        title: 'Example',
        blocksByIndex: <String, ApiDocumentBlock>{
          'first': ApiDocumentBlock(kind: 'markdown', content: 'Example'),
        },
      );
      expect(
        () => ApiProductDocumentInput(document: noId),
        throwsFormatException,
      );
      expect(
        ApiTemplateDocumentInput(document: noId).documentId.isPresent,
        isFalse,
      );
      expect(
        () => ApiConversationAccessCodeInput(
          productDocumentId: 'example',
          expiresAtIso: 'not-a-date',
        ),
        throwsFormatException,
      );
      expect(
        ApiConversationAccessCodeInput(
          productDocumentId: 'example',
          expiresAtIso: '2000-01-01',
        ).expiresAtIso,
        '2000-01-01',
      );
    },
  );
  test('conversation checks only the route literal text policy', () {
    for (final String message in <String>[
      'IGNORE previous instructions',
      'Example <script>',
      '```example',
    ]) {
      expect(
        () => ApiConversationMessageInput(
          conversationId: 'example',
          message: message,
        ),
        throwsFormatException,
      );
    }
    expect(
      ApiConversationMessageInput(
        conversationId: 'example',
        message: 'Ordinary example message',
      ).message,
      'Ordinary example message',
    );
  });
  test('relative links do not become external URLs or traversal targets', () {
    for (final String target in <String>[
      'https://example.invalid',
      '//example.invalid',
      '/a/../b',
      '/a/..',
      r'/a\b',
      'relative',
    ]) {
      expect(
        () =>
            ApiCustomShortLinkInput(targetPath: target, customSlug: 'example'),
        throwsFormatException,
      );
    }
    expect(
      ApiCustomShortLinkInput(
        targetPath: '/example?x=1#part',
        customSlug: 'example',
      ).targetPath,
      '/example?x=1#part',
    );
    expect(
      () => ApiGeneratedShortLinkInput(
        targetPath: '/example',
        lifecyclePolicy: 'instant',
        tokenLength: const ApiField<int?>.present(6),
      ),
      throwsFormatException,
    );
    expect(
      () => ApiGeneratedShortLinkInput(
        targetPath: '/example',
        lifecyclePolicy: 'permanent',
        prefix: const ApiField<String?>.present('bad/prefix'),
      ),
      throwsFormatException,
    );
    expect(
      ApiGeneratedShortLinkInput(
        targetPath: '/example',
        lifecyclePolicy: 'instant',
        tokenLength: const ApiField<int?>.present(8),
      ).tokenLength.value,
      8,
    );
  });
  test(
    'design values retain extension data and check declared numeric roles',
    () {
      final ApiDesignSystem design = ApiDesignSystem.fromJson(
        wire('DesignSystem'),
      );
      expect(
        design.theme.lightScheme.additionalFields['extension'],
        <String, Object?>{'example': true},
      );
      expect(
        design
            .theme
            .lightTextTheme
            .bodyMedium
            .additionalFields['letterSpacing'],
        0.5,
      );
      expect(
        () => design.theme.copyWith(lightScheme: design.theme.darkScheme),
        throwsFormatException,
      );
      expect(
        () => ApiDesignTokens(
          alpha: const ApiField<Map<String, num>>.present(<String, num>{
            'bad': 1.1,
          }),
        ),
        throwsFormatException,
      );
      expect(
        () => ApiDesignTokens(
          spacing: const ApiField<Map<String, num>>.present(<String, num>{
            'bad': -1,
          }),
        ),
        throwsFormatException,
      );
      expect(
        () => ApiDesignDataViz(
          categorical: <int>[4294967296],
          sequential: <int>[0, 1],
        ),
        throwsFormatException,
      );
      expect(
        () => ApiDesignComponentLink(label: 'Example', url: 'about:blank'),
        throwsFormatException,
      );
      expect(
        ApiDesignComponentLink(
          label: 'Example',
          url: 'custom://example.invalid/path',
        ).url,
        startsWith('custom:'),
      );
      expect(
        () => design.copyWith(
          branding: const ApiField<Map<String, String>?>.present(
            <String, String>{'owner': 'Example'},
          ),
        ),
        throwsFormatException,
      );
      expect(
        () => design.copyWith(
          semantic: ApiField<Map<String, ApiDesignSemanticColors>?>.present(
            <String, ApiDesignSemanticColors>{
              'light': design.semantic.value!['light']!,
            },
          ),
        ),
        throwsFormatException,
      );
      expect(
        () => design.componentCatalog.value!.first.copyWith(
          platforms: const ApiField<List<String>>.present(<String>['server']),
        ),
        throwsFormatException,
      );
      expect(
        () => design.componentCatalog.value!.first.copyWith(
          previews: const ApiField<List<String>>.present(<String>['relative']),
        ),
        throwsFormatException,
      );
      expect(
        () => design.theme.lightScheme.copyWith(
          additionalFields: <String, Object?>{'primary': -1},
        ),
        throwsFormatException,
      );
    },
  );
  test('activation saves partial strict patches and keeps revision rules contextual', () {
    expect(ApiActivationDraftInput().toJson(), isEmpty);
    expect(
      () => ApiActivationAddressDraft.fromJson(<String, Object?>{'city': null}),
      throwsFormatException,
    );
    expect(() => ApiActivationInput(action: 'start'), throwsFormatException);
    expect(
      ApiActivationInput(
        action: 'start',
        orderId: const ApiField<String>.present('order-1'),
      ).orderId.value,
      'order-1',
    );
    expect(
      () => ApiActivationInput(
        action: 'start',
        orderId: const ApiField<String>.present(' order-1'),
      ),
      throwsFormatException,
    );
    expect(
      () => ApiActivationInput(
        action: 'save',
        onboardingId: const ApiField<String>.present('activation-1'),
      ),
      throwsFormatException,
    );
    expect(
      ApiActivationInput(
        action: 'advance',
        onboardingId: const ApiField<String>.present('activation-1'),
      ).expectedRevision.isPresent,
      isFalse,
    );
    expect(() => ApiActivationQuery(onboardingId: '..'), throwsFormatException);
    expect(
      () => ApiActivation.fromJson(<String, Object?>{
        ...wire('Activation'),
        'nextAction': 'none',
      }),
      throwsFormatException,
    );
    expect(
      () => ApiPurchaseSubscription(
        periodicity: 'annual',
        durationUnit: 'calendarMonth',
        durationCount: 1,
      ),
      throwsFormatException,
    );
    expect(
      () => ApiPurchaseOrder.fromJson(<String, Object?>{
        ...wire('PurchaseOrder'),
        'totalAmount': 1001,
      }),
      throwsFormatException,
    );
    expect(
      () => ApiPurchaseOrderInput(itemId: 'x' * 257),
      throwsFormatException,
    );
    expect(
      () => ApiPurchaseOrderInput(itemId: 'example\u0000'),
      throwsFormatException,
    );
  });
  test('ledger context, category, date representation and selector rules stay distinct', () {
    final ApiPersonalMovementInput personal = ApiPersonalMovementInput.fromJson(
      wire('PersonalMovementInput'),
    );
    expect(personal.occurredAtIso, '2026-11-06T08:00:00-05:00');
    expect(
      () => personal.copyWith(category: 'commerce.store.direct.income'),
      throwsFormatException,
    );
    expect(
      () => personal.copyWith(direction: 'expense'),
      throwsFormatException,
    );
    expect(
      () => personal.copyWith(occurredAtIso: 'not-a-date'),
      throwsFormatException,
    );
    expect(() => ApiPersonalLedgerCacheInput(), throwsFormatException);
    expect(
      () => ApiPersonalLedgerCacheInput(
        ledgerId: const ApiField<String?>.present('ledger-1'),
        packageKey: const ApiField<String?>.present('package-1'),
      ),
      throwsFormatException,
    );
    expect(
      ApiStoreLedgerCacheInput(
        storeId: 'store-1',
        ledgerId: const ApiField<String?>.present('ledger-1'),
        packageKey: const ApiField<String?>.present('package-1'),
      ).packageKey.value,
      'package-1',
    );
    expect(
      () => ApiStoreLedgerCacheInput(storeId: 'store-1'),
      throwsFormatException,
    );
    expect(
      () => ApiStoreLedgerInput(storeId: 'store/1'),
      throwsFormatException,
    );
    expect(() => ApiPersonalOpenLedger(state: 'open'), throwsFormatException);
    expect(
      () => ApiPersonalOpenLedger(
        state: 'none',
        ledgerId: const ApiField<String>.present('ledger-1'),
      ),
      throwsFormatException,
    );
    final ApiPersonalLedgerCacheData manifest =
        ApiPersonalLedgerCacheData.fromJson(wire('PersonalLedgerCacheData'));
    expect(
      () => manifest.copyWith(downloadRequired: false),
      throwsFormatException,
    );
    expect(
      manifest
          .copyWith(
            downloadRequired: false,
            downloadTarget: const ApiField<ApiLedgerDownloadTarget?>.present(
              null,
            ),
          )
          .downloadTarget,
      isNull,
    );
  });
  test(
    'administrative requests use homologated email and contextual policies',
    () {
      final ApiAdminAssignmentInput input = ApiAdminAssignmentInput.fromJson(
        wire('AdminAssignmentInput'),
      );
      expect(() => input.copyWith(email: 'invalid'), throwsFormatException);
      expect(() => input.copyWith(reason: 'short'), throwsFormatException);
      expect(
        () => input.copyWith(
          operationId: const ApiField<String?>.present('short'),
        ),
        throwsFormatException,
      );
      expect(
        () => ApiAdminAssignmentLookupInput(
          email: const ApiField<String?>.present('invalid'),
        ),
        throwsFormatException,
      );
      expect(
        ApiAdminContextsQuery(limit: const ApiField<String>.present('0x10'))
            .limit
            .value,
        '0x10',
      );
      for (final String limit in <String>['201', '0', '2.5']) {
        expect(
          () => ApiAdminContextsQuery(limit: ApiField<String>.present(limit)),
          throwsFormatException,
        );
      }
      expect(
        () => ApiAdminPlansQuery(
          status: const ApiField<String>.present('revoked'),
        ),
        throwsFormatException,
      );
      expect(
        () => ApiAdminPlansQuery(
          origin: const ApiField<String>.present('clientOwned'),
        ),
        throwsFormatException,
      );
      expect(
        () => ApiPermissionsInput(
          moduleKey: 'commerce',
          permissionKeys: const ApiField<List<String>?>.present(<String>[
            'invented',
          ]),
        ),
        throwsFormatException,
      );
      expect(
        ApiPermissionsInput(moduleKey: 'commerce').permissionKeys.isPresent,
        isFalse,
      );
      expect(
        ApiAdminGrantInput.fromJson(wire('AdminGrantInput')).expiresAtIso.value,
        'opaque-audit-text',
      );
    },
  );
  test('onboarding graphs reject cycles and dangling targets but allow sparse disconnected steps', () {
    final ApiOnboardingFlowInput flow = ApiOnboardingFlowInput.fromJson(
      wire('OnboardingFlowInput'),
    );
    final ApiOnboardingFlowStepInput step = flow.stepsByIndex['0']!;
    expect(
      () => flow.copyWith(stepsByIndex: <String, ApiOnboardingFlowStepInput>{}),
      throwsFormatException,
    );
    expect(
      () => flow.copyWith(
        stepsByIndex: <String, ApiOnboardingFlowStepInput>{'01': step},
      ),
      throwsFormatException,
    );
    expect(
      () => flow.copyWith(
        stepsByIndex: <String, ApiOnboardingFlowStepInput>{
          '0': step.copyWith(nextOnSuccessIndex: 0),
        },
      ),
      throwsFormatException,
    );
    expect(
      () => flow.copyWith(
        stepsByIndex: <String, ApiOnboardingFlowStepInput>{
          '0': step.copyWith(nextOnFailureIndex: 4),
        },
      ),
      throwsFormatException,
    );
    expect(
      flow
          .copyWith(
            stepsByIndex: <String, ApiOnboardingFlowStepInput>{
              '0': step,
              '4': step.copyWith(indexNumber: 4),
            },
          )
          .stepsByIndex,
      hasLength(2),
    );
    expect(
      () => step.copyWith(
        cost: const ApiField<Map<String, num>?>.present(<String, num>{
          'example': -1,
        }),
      ),
      throwsFormatException,
    );
    expect(
      () => ApiOnboardingAcceptanceInput(
        accepted: const ApiField<bool?>.present(false),
      ),
      throwsFormatException,
    );
    expect(ApiOnboardingAcceptanceInput().accepted.isPresent, isFalse);
    expect(() => ApiOnboardingPhotoInput(), throwsFormatException);
    expect(
      ApiOnboardingPhotoInput(
        photoUrl: const ApiField<String?>.present('about:blank'),
      ).photoUrl.value,
      'about:blank',
    );
    expect(
      () => ApiOnboardingTemplatesQuery(
        enabled: const ApiField<String>.present('yes'),
      ),
      throwsFormatException,
    );
    expect(
      () => ApiOnboardingTemplateInput.fromJson(<String, Object?>{
        ...wire('OnboardingTemplateInput'),
        'createdAt': 'not-a-date',
      }),
      throwsFormatException,
    );
    expect(
      () => ApiPersonalOnboardingState.fromJson(<String, Object?>{
        ...wire('PersonalOnboardingState'),
        'completed': true,
      }),
      throwsFormatException,
    );
  });
  test(
    'QA views preserve unknown evidence without becoming an execution runtime',
    () {
      final ApiQaRun run = ApiQaRun.fromJson(wire('QaRun'));
      expect(run.execution.value.sourceDeployment, 'UNKNOWN');
      expect(run.execution.value.metrics.first.elapsedMs, isNull);
      expect(run.toJson().containsKey('actorSessions'), isFalse);
      expect(
        () => ApiQaIntentInput.fromJson(<String, Object?>{
          'operationId': 'example',
          'mode': 'automatic',
        }),
        throwsFormatException,
      );
      expect(
        ApiQaCleanupResult.fromJson(wire('QaCleanupResult')).certificateStatus,
        'UNKNOWN',
      );
    },
  );
}
