import 'package:mab/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('IntDataType tests', () {
    final dataType = IntDataType();

    test('Success convert', () async {
      final res = await dataType.convert(fixtureDataTypeCtx('1'));
      expect(res, equals(1));
    });

    test('Failed convert', () async {
      expect(
        () => dataType.convert(fixtureDataTypeCtx('hello world')),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}
