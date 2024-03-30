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

  RequestCtx copyWith({
    Map<String, String>? queries,
    Map<String, String>? headers,
    Uint8List? body,
  }) {
    return RequestCtx(
      httpMethod: httpMethod,
      uri: uri,
      queries: queries ?? this.queries,
      headers: headers ?? this.queries,
      body: body ?? this.body,
    );
  }
}
