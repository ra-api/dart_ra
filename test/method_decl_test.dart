import 'package:ra/ra.dart';
import 'package:ra/src/core/registry.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'fixtures/fixture_method.dart';
import 'fixtures/fixture_package.dart';

void main() {
  group('MethodDecl tests', () {
    final cases = [
      _registryItem(
        method: FixtureMethod(
          fakeName: 'getCart',
          fakeContentType: JsonContentType(),
          fakeParams: [
            MethodQueryParameter(
              id: 'limit',
              dataType: IntDataType(),
            )
          ],
        ),
        packageName: 'cart',
        version: 2,
        httpMethod: 'GET',
      ),
      _registryItem(
        method: FixtureMethod(
          fakeName: 'saveCart',
          fakeContentType: JsonContentType(),
          fakeParams: [
            MethodBodyParameter(dataType: JsonBodyDataType()),
          ],
        ),
        packageName: 'cart',
        version: 1.3,
        httpMethod: 'POST',
      ),
      _registryItem(
        method: FixtureMethod(
          fakeName: 'getAll',
          fakeParams: [],
          fakeContentType: JsonContentType(),
        ),
        packageName: 'cart',
        version: 2,
        httpMethod: 'GET',
      )
    ];

    test('Getters', () {
      for (final testCase in cases) {
        final decl = MethodDecl(testCase);
        expect(decl.name, equals(testCase.method.name));
        expect(decl.package, equals(testCase.package.name));
        expect(decl.httpMethod, equals(testCase.httpMethod));
        expect(decl.version, equals(testCase.version));
        expect(decl.mimeType, equals(testCase.method.contentType.mimeType));
        if (testCase.method.summary != null) {
          expect(decl.summary, equals(testCase.method.summary!));
        } else {
          expect(decl.summary, equals('Method ${decl.package}.${decl.name}'));
        }
      }
    });

    test('export', () {
      for (final testCase in cases) {
        final decl = MethodDecl(testCase);
        final export = decl.export();

        expect(export['method'], equals(decl.httpMethod));
        expect(export['package'], equals(decl.package));
        expect(export['name'], equals(decl.name));
        expect(export['version'], equals(decl.version));
        expect(export['mimeType'], equals(decl.mimeType));
        expect(export['summary'], equals(decl.summary));

        if (testCase.params.isNotEmpty) {
          final params = export['params'] as List;

          testCase.params.asMap().forEach((key, value) {
            expect(params[key]['name'], equals(value.id));
            expect(params[key]['required'], equals(value.isRequired));

            if (value is MethodParameter) {
              expect(params[key]['source'], equals(value.source.source));
            } else if (value is PackageParameter) {
              expect(params[key]['source'], equals(value.source.source));
            }

            if (value.summary != null) {
              expect(params[key]['summary'], equals(value.summary));
            } else {
              expect(params[key]['summary'], equals('Parameter "${value.id}"'));
            }
          });
        }
      }
    });
  });
}

RegistryItem _registryItem({
  required Method method,
  required String packageName,
  required double version,
  required String httpMethod,
}) {
  return RegistryItem(
    key: '$packageName.${method.name}',
    method: method,
    package: FixturePackage(fakeName: packageName, fakeParams: [
      PackageHeaderParameter(id: 'token', dataType: StringDataType()),
    ]),
    version: version,
    httpMethod: httpMethod,
    plugins: [],
  );
}
