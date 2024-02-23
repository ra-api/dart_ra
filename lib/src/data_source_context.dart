import 'package:meta/meta.dart';

/// Класс контекст для метода, служит, для извлечения значения параметра
/// по имени и приведения извлеченного значения до [T]
@immutable
final class DataSourceContext {
  final Map<String, String> queries;
  final Map<String, String> headers;
  final Stream<List<int>> body;

  const DataSourceContext({
    required this.headers,
    required this.body,
    required this.queries,
  });

  String? header(String id) => headers[id];

  String? query(String id) => queries[id];
}
