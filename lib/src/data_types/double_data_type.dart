part of 'data_types.dart';

class DoubleDataType extends DataType<String, double> {
  const DoubleDataType();

  @override
  FutureOr<double> convert(String data) {
    try {
      return double.parse(data);
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Convert string to double value';
}
