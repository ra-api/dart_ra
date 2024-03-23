part of 'data_types.dart';

@immutable
class JsonBodyDataType extends DataType<Uint8List, JsonType> {
  const JsonBodyDataType({super.initial});

  @override
  FutureOr<JsonType> convert(Uint8List data, DataTypeCtx ctx) {
    try {
      return jsonDecode(utf8.decode(data));
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Convert body to json';
}
