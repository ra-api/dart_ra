import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/types.dart';

@immutable
base class HeaderParameter<O> extends Parameter<String, O> {
  const HeaderParameter({
    required super.id,
    required super.dataType,
    super.optional,
    super.summary,
  }) : super(source: DataSource.header);

  @override
  FutureOr<String?> extract(DataSourceContext ctx) {
    return ctx.query(id);
  }
}
