import 'package:ra/ra.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('DateTimeDataType tests', () {
    final dataType = DateTimeDataType();

    test('Success convert', () async {
      final ctx = fixtureDataTypeCtx();
      final res = await dataType.convert('2023-01-10', ctx);
      expect(res, DateTime(2023, 1, 10));
    });

    test('Failed convert', () async {
      final ctx = fixtureDataTypeCtx();
      expect(
        () => dataType.convert('2023-01-1', ctx),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}
