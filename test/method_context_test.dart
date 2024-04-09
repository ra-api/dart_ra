import 'package:ra/ra.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';
import 'package:ra/src/core/registry.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'fixtures/fixture_method.dart';
import 'fixtures/fixture_package.dart';

void main() {
  group('MethodContext tests', () {
    final decl = MethodDecl(
      RegistryItem(
        key: 'key',
        method: FixtureMethod(
          fakeName: 'bar',
        ),
        httpMethod: 'GET',
        package: FixturePackage(fakeName: 'foo'),
        version: 1,
        plugins: [],
      ),
    );
    final ctx = MethodCtx(
      {
        'baz': 1,
        'limit': null,
      },
      current: decl,
      methods: [decl],
      verbose: false,
      pluginRegistry: PluginRegistry(plugins: []),
    );

    test('value', () {
      expect(
        ctx.value('baz'),
        equals(1),
        reason: 'Must be return 1 as dynamic',
      );

      expect(
        ctx.value('limit'),
        isNull,
        reason: 'Must be return null',
      );

      expect(
        ctx.value<int>('baz'),
        equals(1),
        reason: 'Must be return 1 as int',
      );
      expect(
        () => ctx.value<bool>('baz'),
        throwsA(isA<MethodContextCastException>()),
        reason: 'Cast error must be throw MethodContextCastException',
      );

      expect(
        () => ctx.value<bool>('miss'),
        throwsA(isA<MethodContextInvalidIdException>()),
        reason:
            'Invalid id error must be throw MethodContextInvalidIdException',
      );
    });
  });
}
