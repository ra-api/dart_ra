import 'package:mab/src/parameter.dart';
import 'package:meta/meta.dart';

import 'data_type.dart';
import 'types.dart';

/// Параметр уровня метод
@immutable
class MethodParameter<I, O> extends Parameter<I, O> {
  final MethodDataSource source;
  final DataType<I, O> dataType;

  const MethodParameter({
    required super.id,
    required this.source,
    required this.dataType,
    super.summary,
    super.initial,
  });
}

/// Query параметр, задаем изначально нужный [source]
@immutable
class QueryParameter<T> extends MethodParameter<String, T> {
  const QueryParameter({
    required super.id,
    required super.dataType,
    super.summary,
    super.initial,
  }) : super(source: MethodDataSource.query);
}

/// Header параметр, задаем изначально нужный [source]
@immutable
class HeaderParameter<T> extends MethodParameter<String, T> {
  const HeaderParameter({
    required super.id,
    required super.dataType,
    super.summary,
    super.initial,
  }) : super(source: MethodDataSource.header);
}
