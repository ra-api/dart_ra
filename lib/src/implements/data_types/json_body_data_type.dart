part of 'data_types.dart';

@immutable
class JsonBodyDataType extends DataType<Uint8List, JsonType> {
  const JsonBodyDataType({super.initial});

  @override
  FutureOr<JsonType> convert(DataTypeContext<Uint8List> ctx) {
    try {
      return jsonDecode(utf8.decode(ctx.data));
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Convert body to json';
}
