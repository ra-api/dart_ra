import 'dart:typed_data';

import 'package:ra/ra.dart';
import 'package:ra/src/core/method/data_source_context.dart';
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
          fakeParams: [],
        ),
        httpMethod: 'GET',
        package: FixturePackage(fakeName: 'foo'),
        version: 1,
        plugins: [],
      ),
    );
    final ctx = MethodContext(
      {
        'baz': 1,
        'limit': null,
      },
      current: decl,
      methods: [decl],
      verbose: false,
      pluginRegistry: PluginRegistry(plugins: []),
      dataSourceContext: DataSourceContext(
        headers: {},
        body: Uint8List.fromList([]),
        queries: {},
      ),
    );

    test('value', () {
      expect(
        ctx.value(paramId: 'baz'),
        equals(1),
        reason: 'Must be return 1 as dynamic',
      );

      expect(
        ctx.value(paramId: 'limit'),
        isNull,
        reason: 'Must be return null',
      );

      expect(
        ctx.value<int>(paramId: 'baz'),
        equals(1),
        reason: 'Must be return 1 as int',
      );
      expect(
        () => ctx.value<bool>(paramId: 'baz'),
        throwsA(isA<MethodContextCastException>()),
        reason: 'Cast error must be throw MethodContextCastException',
      );

      expect(
        () => ctx.value<bool>(paramId: 'miss'),
        throwsA(isA<MethodContextInvalidIdException>()),
        reason:
            'Invalid id error must be throw MethodContextInvalidIdException',
      );
    });
  });
}
