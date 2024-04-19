import 'dart:async';
import 'dart:typed_data';

import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/types.dart';

base class BodyParameter<O> extends Parameter<Uint8List, O> {
  BodyParameter({
    required super.dataType,
    super.optional,
    super.summary,
  }) : super(source: DataSource.body, id: 'body');

  @override
  FutureOr<Uint8List> extract(DataSourceContext ctx) {
    return ctx.body;
  }
}
