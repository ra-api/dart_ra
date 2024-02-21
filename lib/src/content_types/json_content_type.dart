import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../content_type.dart';

// typedef JsonType = Map<String, dynamic>;

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
