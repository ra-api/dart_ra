import 'package:meta/meta.dart';

/// Alias for a JSON object.
typedef JsonType = Map<String, dynamic>;

/// Enumeration representing data sources for parameters.
enum DataSource {
  /// Source is query parameters
  query('query'),

  /// Source is header parameters
  header('header'),

  /// Source is body parameters
  body('body');

  final String source;

  /// Constructor for DataSource enum.
  const DataSource(this.source);
}

/// Enumeration representing the scope of a plugin.
@internal
enum PluginScope {
  /// Indicates a global plugin scope
  global,

  /// Indicates a method-specific plugin scope
  method,
}

/// Enumeration representing the scope of a parameter.
@internal
enum ParameterScope {
  /// Indicates method-specific parameters
  method(DataSource.values),

  /// Indicates package-specific parameters
  package([
    DataSource.query,
    DataSource.header,
  ]);

  final List<DataSource> allowSources;
  const ParameterScope(this.allowSources);
}
