import 'package:mab/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('StringDataType tests', () {
    group('Success convert', () {
      test('Without pattern, not trim', () async {
        final dataType = StringDataType();
        final res = await dataType.convert('foo', fixtureDataTypeCtx());
        expect(res, equals('foo'));
      });

      test('Without pattern, with trim', () async {
        final dataType = StringDataType(trim: true);
        final res = await dataType.convert('foo ', fixtureDataTypeCtx());
        expect(res, equals('foo'));
      });

      test('With pattern with trim', () async {
        final dataType = StringDataType(
          pattern: RegExp(r'^\d{3}-\d{2}$'),
          trim: true,
        );

        expect(
          dataType.convert('123-45 ', fixtureDataTypeCtx()),
          equals('123-45'),
          reason: 'Must be match pattern and trim value',
        );

        expect(
          () => dataType.convert('123-456', fixtureDataTypeCtx()),
          throwsA(isA<DataTypeValidateException>()),
          reason: 'Must be throw DataTypeValidateException',
        );
      });
    });
  });
}
