import 'package:mab/mab.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeDataType tests', () {
    final dataType = DateTimeDataType();

    test('Success convert', () async {
      final res = await dataType.convert('2023-01-10');
      expect(res, DateTime(2023, 1, 10));
    });

    test('Failed convert', () async {
      final payload = '2023-01-1';
      expect(
        () => dataType.convert(payload),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}
