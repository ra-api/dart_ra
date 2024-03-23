import 'dart:async';
import 'dart:typed_data';

import 'package:mab/src/core/method/data_source_context.dart';
import 'package:mab/src/core/parameter/parameter.dart';
import 'package:mab/src/types.dart';
import 'package:meta/meta.dart';

/// Параметр уровня метод
@immutable
abstract base class MethodParameter<I, O> extends Parameter<I, O> {
  final MethodDataSource source;

  MethodParameter({
    required super.id,
    required this.source,
    required super.dataType,
    super.summary,
    super.optional,
    // super.initial,
  }) : super(dataSource: source.toDataSource());
}

/// Query параметр, задаем изначально нужный [source]
@immutable
base class MethodQueryParameter<T> extends MethodParameter<String, T> {
  MethodQueryParameter({
    required super.id,
    required super.dataType,
    super.summary,
    super.optional,
  }) : super(source: MethodDataSource.query);

  @override
  String? extract(DataSourceContext ctx) => ctx.query(id);
}

/// Header параметр, задаем изначально нужный [source]
@immutable
base class MethodHeaderParameter<T> extends MethodParameter<String, T> {
  MethodHeaderParameter({
    required super.id,
    required super.dataType,
    super.summary,
    super.optional,
  }) : super(source: MethodDataSource.header);

  @override
  String? extract(DataSourceContext ctx) => ctx.header(id);
}

/// Header параметр, задаем изначально нужный [source]
@immutable
base class MethodBodyParameter<T> extends MethodParameter<Uint8List, T> {
  MethodBodyParameter({
    required super.dataType,
    super.summary,
  }) : super(
          source: MethodDataSource.body,
          id: 'body',
          optional: false,
        );

  @override
  FutureOr<Uint8List> extract(DataSourceContext ctx) async {
    return ctx.body;
  }
}
