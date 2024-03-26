import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
final class RequestCtx {
  final String httpMethod;
  final Uri uri;
  final Map<String, String> queries;
  final Map<String, String> headers;
  final Uint8List body;

  const RequestCtx({
    required this.httpMethod,
    required this.uri,
    required this.queries,
    required this.headers,
    required this.body,
  });
}
