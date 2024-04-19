import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/data_type/data_type.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/types.dart';

export 'body_parameter.dart';
export 'header_parameter.dart';
export 'query_parameter.dart';

/// Базовый класс параметра
@immutable
abstract class Parameter<I, O> {
  /// имя параметра, по этому имени значение параметра можно
  /// получить из [MethodContext]
  final String id;
  final bool optional;
  final DataSource source;

  final DataType<I, O> dataType;

  /// Описание параметра, думаю о том чтобы сделать это поле обязательным
  final String? summary;

  const Parameter({
    required this.id,
    required this.source,
    required this.dataType,
    this.summary,
    this.optional = false,
  });

  bool get isRequired => !optional;

  FutureOr<I?> extract(DataSourceContext ctx);
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
