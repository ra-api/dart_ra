import 'package:mab/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('DateTimeDataType tests', () {
    final dataType = DateTimeDataType();

    test('Success convert', () async {
      final ctx = fixtureDataTypeCtx('2023-01-10');

      final res = await dataType.convert(ctx);
      expect(res, DateTime(2023, 1, 10));
    });

    test('Failed convert', () async {
      final ctx = fixtureDataTypeCtx('2023-01-1');

      expect(
        () => dataType.convert(ctx),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}
