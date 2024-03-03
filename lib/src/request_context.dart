import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class RequestContext {
  final String httpMethod;
  final Uri uri;
  final Map<String, String> queries;
  final Map<String, String> headers;
  final Uint8List body;

  const RequestContext({
    required this.httpMethod,
    required this.uri,
    required this.queries,
    required this.headers,
    required this.body,
  });
}
