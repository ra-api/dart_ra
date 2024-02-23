import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Класс контекст для метода, служит, для извлечения значения параметра
/// по имени и приведения извлеченного значения до [T]
@immutable
final class DataSourceContext {
  final Map<String, String> _queries;
  final Map<String, String> _headers;
  final Stream<List<int>> _body;

  const DataSourceContext({
    required Map<String, String> headers,
    required Stream<List<int>> body,
    required Map<String, String> queries,
  })  : _queries = queries,
        _headers = headers,
        _body = body;

  String? header(String id) => _headers[id];

  String? query(String id) => _queries[id];

  Future<Uint8List> body() async {
    final bytes = await _body.fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    );

    return Uint8List.fromList(bytes);
  }
}
