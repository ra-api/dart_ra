import 'package:meta/meta.dart';

typedef JsonType = Map<String, dynamic>;

enum DataSource {
  query('query'),
  header('header'),
  path('path'),
  body('body');

  final String source;
  const DataSource(this.source);
}

@internal
enum PluginScope {
  global,
  method,
}

@internal
enum ParameterScope {
  method(DataSource.values),
  package([
    DataSource.query,
    DataSource.header,
  ]);

  final List<DataSource> allowSources;
  const ParameterScope(this.allowSources);
}
