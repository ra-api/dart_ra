import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Класс контекст для метода, служит, для извлечения значения параметра
/// по имени и приведения извлеченного значения до [T]
@immutable
final class DataSourceContext {
  final Map<String, String> _queries;
  final Map<String, String> _headers;
  final Uint8List body;

  const DataSourceContext({
    required Map<String, String> headers,
    required this.body,
    required Map<String, String> queries,
  })  : _queries = queries,
        _headers = headers;

  String? header(String id) => _headers[id];

  String? query(String id) => _queries[id];
}
