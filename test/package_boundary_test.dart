import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('domain sources keep infrastructure outside the public core', () {
    final List<File> sources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('.dart'))
        .toList();
    expect(sources, isNotEmpty);
    final RegExp imports = RegExp(r'''(?:import|export)\s+['"]([^'"]+)['"]''');
    for (final File source in sources) {
      for (final RegExpMatch match in imports.allMatches(
        source.readAsStringSync(),
      )) {
        final String uri = match.group(1)!;
        expect(
          uri.startsWith('package:') &&
              !uri.startsWith('package:jocaagura_domain_core/'),
          isFalse,
          reason: '${source.path}: external dependency $uri',
        );
        expect(
          <String>{'dart:io', 'dart:ffi', 'dart:html', 'dart:ui'}.contains(uri),
          isFalse,
          reason: '${source.path}: infrastructure dependency $uri',
        );
      }
    }
  });
}
