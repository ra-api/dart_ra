part of 'data_types.dart';

class IntDataType extends DataType<String, int> {
  const IntDataType();

  @override
  FutureOr<int> convert(String data) {
    return int.parse(data);
  }

  @override
  String get summary => 'jghfhfhf';
}
