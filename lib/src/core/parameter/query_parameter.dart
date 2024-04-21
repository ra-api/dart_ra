import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/types.dart';

@immutable
base class QueryParameter<O> extends Parameter<String, O> {
  /// Constructs a [QueryParameter] with the specified parameters.
  ///
  /// [id] is the unique identifier of the parameter.
  /// [dataType] is the data type of the parameter.
  /// [optional] indicates whether the parameter is optional.
  /// [summary] is a summary of the parameter.
  const QueryParameter({
    required super.id,
    required super.dataType,
    super.optional,
    super.summary,
    super.lazy,
  }) : super(source: DataSource.query);

  /// Extracts the value of the parameter from the provided data source context.
  @override
  FutureOr<String?> extract(DataSourceContext ctx) {
    return ctx.query(id);
  }
}
