import 'dart:convert';

import 'package:mab/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('JsonBodyDataType tests', () {
    final dataType = JsonBodyDataType();

    test('Success convert', () async {
      final ctx = fixtureDataTypeCtx(utf8.encode('{"foo": "bar"}'));

      final res = await dataType.convert(ctx);
      expect(res['foo'], equals('bar'));
    });

    test('Failed convert', () async {
      final ctx = fixtureDataTypeCtx(utf8.encode('hello world'));

      expect(
        () => dataType.convert(ctx),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}
