import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
final class ResponseContext {
  final int statusCode;
  final Uint8List body;
  final Map<String, String> headers;

  const ResponseContext({
    required this.statusCode,
    required this.body,
    required this.headers,
  });
}
