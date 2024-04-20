part of 'data_types.dart';

@immutable
class IntDataType extends DataType<String, int> {
  const IntDataType({super.initial});

  @override
  FutureOr<int> convert(String data, DataTypeContext ctx) {
    try {
      return int.parse(data);
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Convert string to int value';
}
