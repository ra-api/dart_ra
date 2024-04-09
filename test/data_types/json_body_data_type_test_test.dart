import 'dart:convert';

import 'package:ra_core/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('JsonBodyDataType tests', () {
    final dataType = JsonBodyDataType();

    test('Success convert', () async {
      final ctx = fixtureDataTypeCtx();

      final res = await dataType.convert(utf8.encode('{"foo": "bar"}'), ctx);
      expect(res['foo'], equals('bar'));
    });

    test('Failed convert', () async {
      final ctx = fixtureDataTypeCtx();

      expect(
        () => dataType.convert(utf8.encode('hello world'), ctx),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}
