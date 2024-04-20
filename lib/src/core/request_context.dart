import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Represents the context of an HTTP request.
@immutable
class RequestContext {
  /// The HTTP method of the request (e.g., GET, POST).
  final String httpMethod;

  /// The URI of the request.
  final Uri uri;

  /// The query parameters of the request.
  final Map<String, String> queries;

  /// The headers of the request as a map of strings.
  final Map<String, String> headers;

  /// The body of the request as a byte array.
  final Uint8List body;

  /// Constructs a [RequestContext] instance with the specified parameters.
  ///
  /// [httpMethod] is the HTTP method of the request.
  /// [uri] is the URI of the request.
  /// [queries] are the query parameters of the request as a map of strings.
  /// [headers] are the headers of the request as a map of strings.
  /// [body] is the body of the request as a byte array.
  const RequestContext({
    required this.httpMethod,
    required this.uri,
    required this.queries,
    required this.headers,
    required this.body,
  });

  /// Creates a copy of this [RequestContext] with the specified properties replaced.
  ///
  /// [queries] (optional) are the new query parameters of the request.
  /// [headers] (optional) are the new headers of the request.
  /// [body] (optional) is the new body of the request.
  RequestContext copyWith({
    Map<String, String>? queries,
    Map<String, String>? headers,
    Uint8List? body,
  }) {
    return RequestContext(
      httpMethod: httpMethod,
      uri: uri,
      queries: queries ?? this.queries,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }

  /// Merges the provided headers with the existing headers of the request.
  ///
  /// If the provided [headers] map is not empty, it merges its contents with
  /// the existing headers of this request, replacing any existing headers
  /// with the same keys.
  ///
  /// Returns a new [RequestContext] with the merged headers.
  RequestContext mergeHeaders(Map<String, String> headers) {
    if (headers.isNotEmpty) {
      final newHeaders = Map<String, String>.from(this.headers);
      newHeaders.addAll(headers);

      return copyWith(headers: newHeaders);
    }
    return this;
  }
}
