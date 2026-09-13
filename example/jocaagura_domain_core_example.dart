import 'dart:io';

import 'package:jocaagura_domain_core/jocaagura_domain_core.dart';

Future<void> main() async {
  // Representative order fields from the inspected backend consumer.
  final Map<String, dynamic> order = Utils.mapFromDynamic(
    '{"id":"order-1","subtotalAmount":"1.234,56 COP","notes":null}',
  );
  final int subtotal = Utils.getIntegerFromDynamic(order['subtotalAmount']);
  final String notes = Utils.getStringFromDynamic(order['notes']);
  final Duration timeout = Utils.durationFromJson('00:01:30.250');

  stdout.writeln('${order['id']}: subtotal=$subtotal, notes="$notes"');
  stdout.writeln('Timeout milliseconds: ${Utils.durationToJson(timeout)}');

  // Consumer-owned commands can carry a typed success without a payload.
  final Unit completed = await Future<Unit>.value(unit);
  stdout.writeln('Completion: $completed');
}
