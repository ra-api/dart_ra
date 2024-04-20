import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Represents the context of an HTTP response.
@immutable
class ResponseContext {
  /// The HTTP status code of the response.
  final int statusCode;

  /// The body of the response as a byte array.
  final Uint8List body;

  /// The headers of the response as a map of strings.
  final Map<String, String> headers;

  /// Constructs a [ResponseContext] instance with the specified parameters.
  ///
  /// [statusCode] is the HTTP status code of the response.
  /// [body] is the body of the response as a byte array.
  /// [headers] are the headers of the response as a map of strings.
  const ResponseContext({
    required this.statusCode,
    required this.body,
    required this.headers,
  });

  /// Creates a copy of this [ResponseContext] with the specified properties replaced.
  ///
  /// [statusCode] (optional) is the new HTTP status code.
  /// [body] (optional) is the new body of the response.
  /// [headers] (optional) are the new headers of the response.
  ResponseContext copyWith({
    int? statusCode,
    Uint8List? body,
    Map<String, String>? headers,
  }) {
    return ResponseContext(
      statusCode: statusCode ?? this.statusCode,
      body: body ?? this.body,
      headers: headers ?? this.headers,
    );
  }

  /// Merges the provided headers with the existing headers of the response.
  ///
  /// If the provided [headers] map is not empty, it merges its contents with
  /// the existing headers of this response, replacing any existing headers
  /// with the same keys.
  ///
  /// Returns a new [ResponseContext] with the merged headers.
  ResponseContext mergeHeaders(Map<String, String> headers) {
    if (headers.isNotEmpty) {
      final newHeaders = Map<String, String>.from(this.headers);
      newHeaders.addAll(headers);

      return copyWith(headers: newHeaders);
    }
    return this;
  }
}
