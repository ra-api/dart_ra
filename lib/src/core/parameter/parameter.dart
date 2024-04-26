import 'package:meta/meta.dart';
import 'package:ra/src/core/data_type/data_type.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/types.dart';

export 'body_parameter.dart';
export 'header_parameter.dart';
export 'query_parameter.dart';

/// Base class for parameters.
@immutable
abstract class Parameter<I, O> {
  /// The identifier of the parameter, used to retrieve the parameter's value from [MethodContext].
  final String id;

  /// Indicates whether the parameter is optional.
  final bool optional;

  /// The data source of the parameter.
  final DataSource source;

  /// The data type of the parameter.
  final DataType<I, O> dataType;

  /// A description of the parameter.
  final String? summary;

  final bool lazy;

  const Parameter({
    required this.id,
    required this.source,
    required this.dataType,
    this.summary,
    this.optional = false,
    this.lazy = false,
  });

  /// Returns true if the parameter is required, false otherwise.
  bool get isRequired => !optional;

  /// Extracts the value of the parameter from the provided data source context.
  I? extract(DataSourceContext ctx) {
    switch (source) {
      case DataSource.query:
        return ctx.query(id) as I?;
      case DataSource.header:
        return ctx.header(id) as I?;
      case DataSource.body:
        return ctx.body as I?;
    }
  }
}

/// Represents data about a parameter, including the parameter itself and its scope.
@internal
@immutable
final class ParameterData {
  /// The parameter instance.
  final Parameter parameter;

  /// The scope of the parameter.
  final ParameterScope scope;

  const ParameterData({
    required this.parameter,
    required this.scope,
  });

  /// Constructs a [ParameterData] instance for a method parameter.
  factory ParameterData.method(Parameter parameter) {
    return ParameterData(
      parameter: parameter,
      scope: ParameterScope.method,
    );
  }

  /// Constructs a [ParameterData] instance for a package parameter.
  factory ParameterData.package(Parameter parameter) {
    return ParameterData(
      parameter: parameter,
      scope: ParameterScope.package,
    );
  }
}
