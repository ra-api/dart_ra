import 'package:meta/meta.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/types.dart';

/// Represents a header parameter for a method.
@immutable
base class HeaderParameter<O> extends Parameter<String, O> {
  /// Constructs a [HeaderParameter] with the specified parameters.
  ///
  /// [id] is the unique identifier of the parameter.
  /// [dataType] is the data type of the parameter.
  /// [optional] indicates whether the parameter is optional.
  /// [summary] is a summary of the parameter.
  const HeaderParameter({
    required super.id,
    required super.dataType,
    super.optional,
    super.summary,
  }) : super(source: DataSource.header);
}
