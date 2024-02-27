import 'package:mab/mab.dart';
import 'package:test/test.dart';

void main() {
  group('IntDataType tests', () {
    final dataType = IntDataType();

    test('Success convert', () async {
      final res = await dataType.convert('1');
      expect(res, equals(1));
    });

    test('Failed convert', () async {
      final payload = 'hello world';
      expect(() => dataType.convert(payload), throwsException);
    });
  });
}
