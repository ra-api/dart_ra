import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/types.dart';

@immutable
base class QueryParameter<O> extends Parameter<String, O> {
  const QueryParameter({
    required super.id,
    required super.dataType,
    super.optional,
    super.summary,
  }) : super(source: DataSource.query);

  @override
  FutureOr<String?> extract(DataSourceContext ctx) {
    return ctx.query(id);
  }
}
