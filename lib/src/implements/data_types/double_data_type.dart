part of 'data_types.dart';

@immutable
class DoubleDataType extends DataType<String, double> {
  const DoubleDataType({super.initial});

  @override
  FutureOr<double> convert(String data, DataTypeCtx ctx) {
    try {
      return double.parse(data);
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Convert string to double value';
}
