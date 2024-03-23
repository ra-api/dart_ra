part of 'data_types.dart';

@immutable
class IntDataType extends DataType<String, int> {
  const IntDataType({super.initial});

  @override
  FutureOr<int> convert(DataTypeContext<String> ctx) {
    try {
      return int.parse(ctx.data);
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Convert string to int value';
}
