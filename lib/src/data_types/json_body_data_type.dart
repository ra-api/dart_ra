part of 'data_types.dart';

class JsonBodyDataType extends DataType<Uint8List, JsonType> {
  @override
  FutureOr<JsonType> convert(Uint8List data) {
    return jsonDecode(utf8.decode(data));
  }

  @override
  String get summary => 'Convert body to json';
}
