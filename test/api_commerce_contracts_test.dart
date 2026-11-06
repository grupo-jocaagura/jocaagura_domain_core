import 'dart:convert';

import 'package:jocaagura_domain_core/jocaagura_domain_api.dart';
import 'package:test/test.dart';

import 'support/api_contract_checks.dart';

void main() {
  const Map<String, Object?> address = <String, Object?>{
    'id': 'address-1',
    'postalCode': 0,
    'country': 'CO',
    'administrativeArea': 'Example',
    'city': 'Example',
    'locality': 'Example',
    'address': 'Example address',
    'notes': '',
  };
  const Map<String, Object?> store = <String, Object?>{
    'id': 'store-1',
    'nit': 0,
    'name': 'Example',
    'alias': 'example',
    'email': 'store@example.invalid',
    'photoUrl': 'about:blank',
    'coverPhotoUrl': 'about:blank',
    'photoImageId': '',
    'coverImageId': '',
    'storeType': 'common',
    'phoneNumber1': 0,
    'phoneNumber2': 0,
    'address': address,
    'capabilities': <Object?>['catalog', 'inventory'],
  };
  final Map<String, Object?> profile = <String, Object?>{...store}
    ..remove('nit');
  const Map<String, Object?> relationship = <String, Object?>{
    'personId': 'person-1',
    'storeId': 'store-1',
    'membershipId': 'membership-1',
    'roles': <Object?>['owner', 'admin'],
    'status': 'active',
    'relationshipHealth': 'healthy',
  };
  final Map<String, Object?> createdRelationship =
      <String, Object?>{...relationship, 'relationStatus': 'active'}
        ..remove('status')
        ..remove('relationshipHealth');
  const Map<String, Object?> diagnostics = <String, Object?>{
    'inconsistentRelationshipsCount': 0,
    'omittedRelationshipsCount': 1,
  };
  const Map<String, Object?> action = <String, Object?>{
    'key': 'commerce.inventory.open',
    'capability': 'inventory',
    'enabled': true,
    'status': 'ready',
  };
  const Map<String, Object?> dashboard = <String, Object?>{
    'state': 'ready',
    'availableActions': <Object?>[action],
  };
  const Map<String, Object?> inventoryItem = <String, Object?>{
    'itemId': 'item-1',
    'quantity': 5,
    'reservedQuantity': 2,
    'availableQuantity': 3,
    'primaryImageId': '',
    'minimumQuantity': null,
    'maximumQuantity': 10,
    'state': 'active',
    'tags': <Object?>['example'],
    'attributes': <String, Object?>{'client.label': 'Example'},
  };
  final Map<String, Object?> upsertedItem = <String, Object?>{
    ...inventoryItem,
    'inventoryAttributes': inventoryItem['attributes'],
  }..remove('attributes');
  const Map<String, Object?> inventorySummary = <String, Object?>{
    'totalItems': 1,
    'totalQuantity': 5,
    'availableQuantity': 3,
  };
  const Map<String, Object?> inventory = <String, Object?>{
    'id': 'inventory-1',
    'state': 'active',
    'items': <Object?>[inventoryItem],
    'summary': inventorySummary,
  };
  const Map<String, Object?> overview = <String, Object?>{
    'id': 'inventory-1',
    'state': 'active',
    'summary': inventorySummary,
  };
  const Map<String, Object?> category = <String, Object?>{
    'category': 'example',
    'description': 'Example category',
  };
  const Map<String, Object?> price = <String, Object?>{
    'amount': 1250,
    'mathPrecision': 2,
    'currency': 'COP',
  };
  const Map<String, Object?> item = <String, Object?>{
    'id': 'item-1',
    'name': 'Example',
    'description': 'Example item',
    'type': category,
    'price': price,
    'attributes': <Object?>[],
  };
  const Map<String, Object?> catalogItem = <String, Object?>{
    'itemId': 'item-1',
    'name': 'Example',
    'description': 'Example item',
    'inventoryState': 'active',
    'availabilityStatus': 'available',
    'primaryImageId': '',
    'type': category,
    'price': price,
    'quantity': 5,
    'reservedQuantity': 2,
    'availableQuantity': 3,
    'minimumQuantity': null,
    'maximumQuantity': 10,
    'isSellable': true,
    'isVisible': true,
    'tags': <Object?>['example'],
    'primaryImageUrl': null,
  };
  const Map<String, Object?> catalogSummary = <String, Object?>{
    'totalItems': 2,
    'sellableItems': 1,
    'availableItems': 1,
    'outOfStockItems': 0,
    'omittedItemsCount': 1,
  };
  const Map<String, Object?> catalogDiagnostics = <String, Object?>{
    'omittedItemsCount': 1,
  };
  const Map<String, Object?> catalog = <String, Object?>{
    'items': <Object?>[catalogItem],
    'summary': catalogSummary,
    'diagnostics': catalogDiagnostics,
  };
  const Map<String, Object?> customer = <String, Object?>{
    'id': 'customer-1',
    'storeId': 'store-1',
    'displayName': 'Example Person',
    'email': '',
    'phoneNumber': '',
    'documentLabel': '',
    'notes': '',
    'status': 'active',
    'createdAtIso': '2026-01-01T00:00:00.000Z',
    'updatedAtIso': '2026-01-01T00:00:00.000Z',
  };
  const Map<String, Object?> lineInput = <String, Object?>{
    'itemId': 'item-1',
    'label': 'Example',
    'quantity': 2,
  };
  const Map<String, Object?> line = <String, Object?>{
    'id': 'line-1',
    'itemRefId': 'item-1',
    'label': 'Example',
    'quantity': 2,
    'unitAmount': 1000,
    'totalAmount': 2000,
  };
  const Map<String, Object?> order = <String, Object?>{
    'id': 'order-1',
    'kind': 'sale',
    'status': 'confirmed',
    'source': 'commerce',
    'customerRefId': 'customer-1',
    'currencyCode': 'COP',
    'notes': '',
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'subtotalAmount': 2000,
    'totalAmount': 2000,
    'lines': <Object?>[line],
  };
  const Map<String, Object?> editedLine = <String, Object?>{
    'itemId': 'item-1',
    'label': 'Example',
    'quantity': 2,
    'unitAmount': 1000,
    'totalAmount': 2000,
  };
  const Map<String, Object?> reservationSnapshot = <String, Object?>{
    'status': 'none',
    'fingerprint': '',
    'requiresReleaseBeforeLineChanges': false,
  };
  const Map<String, Object?> editedOrder = <String, Object?>{
    'orderId': 'order-1',
    'customerSnapshotId': 'customer-1',
    'currencyCode': 'COP',
    'status': 'confirmed',
    'financialStatus': 'unpaid',
    'notes': '',
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'subtotalAmount': 2000,
    'totalAmount': 2000,
    'lines': <Object?>[editedLine],
    'stockReservation': reservationSnapshot,
  };
  const Map<String, Object?> reservedLine = <String, Object?>{
    'itemId': 'item-1',
    'requestedQuantity': 2,
    'reservedQuantity': 2,
    'availableQuantity': 3,
  };
  const Map<String, Object?> reservation = <String, Object?>{
    'reservationId': 'reservation-1',
    'status': 'reserved',
    'saveStatus': 'updated',
    'lines': <Object?>[reservedLine],
  };
  const Map<String, Object?> obligation = <String, Object?>{
    'orderId': 'order-1',
    'obligationId': 'obligation-1',
    'status': 'open',
    'currencyCode': 'COP',
    'amountMinor': 2000,
    'closureCause': null,
  };
  const Map<String, Object?> lifecycle = <String, Object?>{
    'orderId': 'order-1',
    'obligationId': 'obligation-1',
    'currencyCode': 'COP',
    'amountMinor': 2000,
    'status': 'open',
    'closureCause': null,
    'verificationStatus': 'notStarted',
    'isTerminal': false,
    'nextAction': 'startCheckout',
  };
  const Map<String, Object?> checkout = <String, Object?>{
    'targetType': 'externalUrl',
    'url': 'https://checkout.example.invalid/opaque',
    'expiresAt': '2026-01-01T00:15:00.000Z',
  };
  const Map<String, Object?> downloadTarget = <String, Object?>{
    'targetType': 'inMemory',
    'method': 'GET',
    'url': 'inmemory://opaque',
    'expiresAtIso': '2026-01-01T00:15:00.000Z',
    'format': 'csv',
    'encoding': 'utf-8',
    'delimiter': ',',
  };
  const Map<String, Object?> cache = <String, Object?>{
    'cacheId': 'cache-1',
    'schemaVersion': 1,
    'version': 1,
    'format': 'csv',
    'encoding': 'utf-8',
    'delimiter': ',',
    'itemCount': 1,
    'checksum':
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    'generatedAtIso': '2026-01-01T00:00:00.000Z',
    'expiresAtIso': '2026-01-01T00:30:00.000Z',
    'status': 'ready',
    'downloadRequired': false,
    'downloadTarget': null,
  };
  const Map<String, Object?> saveStatus = <String, Object?>{
    'item': 'created',
    'inventoryItem': 'created',
  };

  void check(
    String name,
    ApiValue Function(Map<String, Object?>) decode,
    Map<String, Object?> wire, {
    Set<String> optional = const <String>{},
    bool rejectUnknown = false,
  }) {
    test(
      '$name: independent functional fixture, required members, copying and homologated equality',
      () {
        final ApiValue value = decode(wire);
        verifyApiFieldContracts(value, decode, wire);
        expect(value.toJson(), wire);
        expect(value.copyWith(), value);
        final ApiValue restored = decode(
          jsonDecode(jsonEncode(value.toJson())) as Map<String, Object?>,
        );
        expect(restored, value);
        expect(restored.hashCode, value.hashCode);
        for (final String key in wire.keys.where(
          (String key) => !optional.contains(key),
        )) {
          expect(
            () => decode(<String, Object?>{...wire}..remove(key)),
            throwsFormatException,
          );
          expect(
            () => decode(<String, Object?>{...wire, key: Object()}),
            throwsFormatException,
          );
        }
        if (rejectUnknown) {
          expect(
            () => decode(<String, Object?>{...wire, 'unknown': true}),
            throwsFormatException,
          );
        } else {
          expect(
            decode(<String, Object?>{...wire, 'unknown': Object()}),
            value,
          );
        }
      },
    );
  }

  check('store profile', ApiStoreProfile.fromJson, profile);
  check('store', ApiStore.fromJson, store);
  check(
    'created relationship',
    ApiCreatedStoreRelationship.fromJson,
    createdRelationship,
  );
  check('relationship', ApiStoreRelationship.fromJson, relationship);
  check(
    'relationship diagnostics',
    ApiRelationshipDiagnostics.fromJson,
    diagnostics,
  );
  check('store entry', ApiStoreListEntry.fromJson, <String, Object?>{
    'store': store,
    'relationship': relationship,
  });
  check('stores result', ApiStoresData.fromJson, <String, Object?>{
    'stores': <Object?>[
      <String, Object?>{'store': store, 'relationship': relationship},
    ],
    'diagnostics': diagnostics,
  });
  check('dashboard action', ApiCommerceDashboardAction.fromJson, action);
  check('dashboard', ApiCommerceDashboard.fromJson, dashboard);
  check('dashboard result', ApiStoreDashboardData.fromJson, <String, Object?>{
    'store': store,
    'relationship': relationship,
    'dashboard': dashboard,
  });
  check('created store', ApiCreatedStoreData.fromJson, <String, Object?>{
    'store': store,
    'relationship': createdRelationship,
  });
  check('store input', ApiStoreInput.fromJson, <String, Object?>{
    'name': 'Example',
    'alias': 'example',
    'email': 'store@example.invalid',
    'photoUrl': 'about:blank',
    'coverPhotoUrl': 'about:blank',
    'address': <String, Object?>{...address}
      ..remove('postalCode')
      ..remove('notes'),
    'capabilities': <Object?>['catalog', 'inventory'],
  });
  check('inventory item', ApiInventoryItem.fromJson, inventoryItem);
  check(
    'upsert inventory item',
    ApiUpsertedInventoryItem.fromJson,
    upsertedItem,
  );
  check('inventory summary', ApiInventorySummary.fromJson, inventorySummary);
  check('inventory', ApiInventory.fromJson, inventory);
  check('inventory overview', ApiInventoryOverview.fromJson, overview);
  check('inventory response', ApiInventoryData.fromJson, <String, Object?>{
    'store': store,
    'relationship': relationship,
    'inventory': inventory,
  });
  check('catalog item', ApiCatalogItem.fromJson, catalogItem);
  check('catalog summary', ApiCatalogSummary.fromJson, catalogSummary);
  check(
    'catalog diagnostics',
    ApiCatalogDiagnostics.fromJson,
    catalogDiagnostics,
  );
  check('catalog', ApiCatalog.fromJson, catalog);
  check('catalog result', ApiCatalogData.fromJson, <String, Object?>{
    'store': store,
    'relationship': relationship,
    'catalog': catalog,
  });
  check('customer', ApiCustomer.fromJson, customer);
  check('customer input', ApiCustomerInput.fromJson, <String, Object?>{
    'displayName': 'Example',
  });
  check('customer response', ApiCustomerData.fromJson, <String, Object?>{
    'store': store,
    'relationship': relationship,
    'customer': customer,
  });
  check('customer count', ApiCustomerSummary.fromJson, <String, Object?>{
    'totalCustomers': 1,
  });
  check('customer list', ApiCustomersData.fromJson, <String, Object?>{
    'store': store,
    'relationship': relationship,
    'customers': <Object?>[customer],
    'summary': <String, Object?>{'totalCustomers': 1},
  });
  check('order input line', ApiSalesOrderLineInput.fromJson, lineInput);
  check('order input', ApiSalesOrderInput.fromJson, <String, Object?>{
    'customerSnapshotId': 'customer-1',
    'currencyCode': 'COP',
    'lines': <Object?>[lineInput],
  });
  check('created order line', ApiCreatedSalesOrderLine.fromJson, line);
  check('created order', ApiCreatedSalesOrder.fromJson, order);
  check(
    'created order response',
    ApiCreatedSalesOrderData.fromJson,
    <String, Object?>{
      'store': store,
      'relationship': relationship,
      'order': order,
    },
  );
  check(
    'order patch',
    ApiSalesOrderPatch.fromJson,
    <String, Object?>{'notes': null},
    optional: <String>{'notes'},
    rejectUnknown: true,
  );
  check('edited order line', ApiEditedSalesOrderLine.fromJson, editedLine);
  check(
    'stock reservation hint',
    ApiStockReservationSnapshot.fromJson,
    reservationSnapshot,
  );
  check('edited order', ApiEditedSalesOrder.fromJson, editedOrder);
  check(
    'edited order result',
    ApiEditedSalesOrderData.fromJson,
    <String, Object?>{'order': editedOrder},
  );
  check(
    'stock reason',
    ApiStockReasonInput.fromJson,
    <String, Object?>{},
    rejectUnknown: true,
  );
  check('reserved line', ApiStockReservationLine.fromJson, reservedLine);
  check('reservation', ApiStockReservation.fromJson, reservation);
  check(
    'reservation result',
    ApiStockReservationData.fromJson,
    <String, Object?>{
      'storeId': 'store-1',
      'orderId': 'order-1',
      'reservation': reservation,
    },
  );
  check('economic obligation', ApiOrderObligation.fromJson, obligation);
  check(
    'purchase economic lifecycle',
    ApiPurchasePaymentLifecycle.fromJson,
    lifecycle,
  );
  check('checkout destination', ApiCheckoutTarget.fromJson, checkout);
  check(
    'purchase payment result',
    ApiPurchasePaymentData.fromJson,
    <String, Object?>{'paymentLifecycle': lifecycle},
  );
  check(
    'catalog download target',
    ApiCatalogDownloadTarget.fromJson,
    downloadTarget,
  );
  check('catalog cache manifest', ApiCatalogCacheData.fromJson, cache);
  check(
    'replacement order input line',
    ApiSalesOrderLinePatchInput.fromJson,
    lineInput,
    rejectUnknown: true,
  );
  check(
    'updated store profile',
    ApiStoreProfileData.fromJson,
    <String, Object?>{'store': profile},
  );
  check('article save statuses', ApiArticleSaveStatus.fromJson, saveStatus);
  check(
    'article upsert response',
    ApiArticleUpsertData.fromJson,
    <String, Object?>{
      'store': store,
      'relationship': relationship,
      'item': item,
      'inventoryItem': upsertedItem,
      'inventory': overview,
      'saveStatus': saveStatus,
    },
  );
  check(
    'inventory link input',
    ApiInventoryAttachInput.fromJson,
    <String, Object?>{'itemId': 'item-1', 'quantity': 0},
  );
  check('absolute quantity input', ApiQuantityPatch.fromJson, <String, Object?>{
    'quantity': 0,
  });
  check('category input', ApiCategoryInput.fromJson, category);
  check('price input', ApiPriceInput.fromJson, <String, Object?>{
    'currency': 'COP',
  });
  check('article input', ApiItemInput.fromJson, <String, Object?>{
    'name': 'Example',
    'description': 'Example',
    'type': category,
    'price': <String, Object?>{'currency': 'COP'},
  });
  check(
    'article upsert input',
    ApiArticleUpsertRequest.fromJson,
    <String, Object?>{
      'item': <String, Object?>{
        'name': 'Example',
        'description': 'Example',
        'type': category,
        'price': <String, Object?>{'currency': 'COP'},
      },
      'quantity': 0,
    },
  );
  check(
    'article patch',
    ApiItemPatch.fromJson,
    <String, Object?>{'name': 'Example'},
    optional: <String>{'name'},
    rejectUnknown: true,
  );
  check(
    'inventory metadata patch',
    ApiInventoryMetadataPatch.fromJson,
    <String, Object?>{'minimumQuantity': null},
    optional: <String>{'minimumQuantity'},
    rejectUnknown: true,
  );
  check(
    'article patch request',
    ApiArticlePatchRequest.fromJson,
    <String, Object?>{
      'item': <String, Object?>{'name': 'Example'},
    },
    optional: <String>{'item'},
    rejectUnknown: true,
  );
  check('obligation result', ApiOrderObligationData.fromJson, <String, Object?>{
    'orderObligation': obligation,
  });
  check('item image input', ApiItemImageInput.fromJson, <String, Object?>{
    'imageId': 'image-1',
  });
  const Map<String, Object?> readTarget = <String, Object?>{
    'targetType': 'signedUrl',
    'method': 'GET',
    'url': 'fake://opaque',
    'expiresAt': null,
  };
  check('item image result', ApiItemImageReadData.fromJson, <String, Object?>{
    'storeId': 'store-1',
    'itemId': 'item-1',
    'imageId': 'image-1',
    'variantKey': 'original',
    'readTarget': readTarget,
  });
  check('store image result', ApiStoreImageReadData.fromJson, <String, Object?>{
    'storeId': 'store-1',
    'imageId': 'image-1',
    'slot': 'photo',
    'variantKey': 'original',
    'readTarget': readTarget,
  });
  check(
    'conditional catalog query',
    ApiCatalogCacheQuery.fromJson,
    <String, Object?>{},
  );
  check(
    'explicit empty object body',
    ApiEmptyObjectBody.fromJson,
    <String, Object?>{},
    rejectUnknown: true,
  );
  check(
    'store profile patch',
    ApiStoreProfilePatch.fromJson,
    <String, Object?>{'name': 'Example'},
    optional: <String>{'name'},
    rejectUnknown: true,
  );
  check(
    'associated item image read input',
    ApiItemImageReadInput.fromJson,
    <String, Object?>{'imageId': 'image-1'},
  );
}
