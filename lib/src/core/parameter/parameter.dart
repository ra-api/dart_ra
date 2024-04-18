import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:ra/src/core/data_type/data_type.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/types.dart';

/// Базовый класс параметра
@immutable
abstract class Parameter<I, O> {
  /// имя параметра, по этому имени значение параметра можно
  /// получить из [MethodContext]
  final String id;
  final bool optional;
  final DataSource dataSource;

  final DataType<I, O> dataType;

  /// Описание параметра, думаю о том чтобы сделать это поле обязательным
  final String? summary;

  const Parameter({
    required this.id,
    required this.dataSource,
    required this.dataType,
    this.summary,
    this.optional = false,
  });

  bool get isRequired => !optional;

  FutureOr<I?> extract(DataSourceContext ctx);
}

@immutable
base class QueryParameter<O> extends Parameter<String, O> {
  const QueryParameter({
    required super.id,
    required super.dataType,
    super.optional,
    super.summary,
  }) : super(dataSource: DataSource.query);

  @override
  FutureOr<String?> extract(DataSourceContext ctx) {
    return ctx.query(id);
  }
}

@immutable
base class HeaderParameter<O> extends Parameter<String, O> {
  const HeaderParameter({
    required super.id,
    required super.dataType,
    super.optional,
    super.summary,
  }) : super(dataSource: DataSource.query);

  @override
  FutureOr<String?> extract(DataSourceContext ctx) {
    return ctx.query(id);
  }
}

base class BodyParameter<O> extends Parameter<Uint8List, O> {
  BodyParameter({
    required super.dataType,
    super.optional,
    super.summary,
  }) : super(dataSource: DataSource.query, id: 'body');

  @override
  FutureOr<Uint8List> extract(DataSourceContext ctx) {
    return ctx.body;
  }
}

@internal
@immutable
final class ParameterData {
  final Parameter parameter;
  final ParameterScope scope;

  const ParameterData({
    required this.parameter,
    required this.scope,
  });

  factory ParameterData.method(Parameter parameter) {
    return ParameterData(
      parameter: parameter,
      scope: ParameterScope.method,
    );
  }

  factory ParameterData.package(Parameter parameter) {
    return ParameterData(
      parameter: parameter,
      scope: ParameterScope.package,
    );
  }
}
