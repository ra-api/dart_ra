import 'dart:async';

import 'package:ra_core/src/core/data_type/data_type.dart';
import 'package:ra_core/src/core/method/data_source_context.dart';
import 'package:ra_core/src/types.dart';
import 'package:meta/meta.dart';

/// Базовый класс параметра
@immutable
abstract class Parameter<I, O> {
  /// имя параметра, по этому имени значение параметра можно
  /// получить из [MethodContext]
  final String id;
  final bool optional;
  final DataSource dataSource;

  final DataType<I, O> dataType;

  /// Изначальное значение, если значение не задано то параметр
  /// считается обязательным
  // final O? initial;

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
