import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Represents the context for a method, used to extract parameter values
/// by name and convert the extracted value to type [T].
@immutable
final class DataSourceContext {
  /// The map of query parameters.
  final Map<String, String> _queries;

  /// The map of headers.
  final Map<String, String> _headers;

  /// The body of the request.
  final Uint8List body;

  /// Constructs a [DataSourceContext] with the specified parameters.
  ///
  /// [headers] is a map containing the headers of the request.
  /// [body] is the body of the request.
  /// [queries] is a map containing the query parameters of the request.
  const DataSourceContext({
    required Map<String, String> headers,
    required this.body,
    required Map<String, String> queries,
  })  : _queries = queries,
        _headers = headers;

  /// Retrieves the value of the header with the specified [id].
  String? header(String id) => _headers[id];

  /// Retrieves the value of the query parameter with the specified [id].
  String? query(String id) => _queries[id];
}
