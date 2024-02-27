import 'dart:async';
import 'dart:typed_data';

import 'package:mab/src/data_source_context.dart';
import 'package:mab/src/parameter.dart';
import 'package:meta/meta.dart';

import 'types.dart';

/// Параметр уровня метод
@immutable
abstract base class MethodParameter<I, O> extends Parameter<I, O> {
  final MethodDataSource source;

  const MethodParameter({
    required super.id,
    required this.source,
    required super.dataType,
    super.summary,
    super.initial,
  });
}

/// Query параметр, задаем изначально нужный [source]
@immutable
base class MethodQueryParameter<T> extends MethodParameter<String, T> {
  const MethodQueryParameter({
    required super.id,
    required super.dataType,
    super.summary,
    super.initial,
  }) : super(source: MethodDataSource.query);

  @override
  String? extract(DataSourceContext ctx) => ctx.query(id);
}

/// Header параметр, задаем изначально нужный [source]
@immutable
base class MethodHeaderParameter<T> extends MethodParameter<String, T> {
  const MethodHeaderParameter({
    required super.id,
    required super.dataType,
    super.summary,
    super.initial,
  }) : super(source: MethodDataSource.header);

  @override
  String? extract(DataSourceContext ctx) => ctx.header(id);
}

/// Header параметр, задаем изначально нужный [source]
@immutable
base class MethodBodyParameter<T> extends MethodParameter<Uint8List, T> {
  const MethodBodyParameter({
    required super.dataType,
    super.summary,
    super.initial,
  }) : super(source: MethodDataSource.body, id: 'body');

  @override
  FutureOr<Uint8List> extract(DataSourceContext ctx) async {
    return ctx.body;
  }
}
