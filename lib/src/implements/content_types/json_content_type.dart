part of 'content_types.dart';

@immutable
base class JsonContentType<T extends Object> implements ResponseContentType<T> {
  const JsonContentType();

  @override
  Uint8List apply(T data, _) {
    return utf8.encode(jsonEncode(data));
  }

  @override
  String get mimeType => 'application/json';
}
