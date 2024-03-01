import 'dart:async';

import 'package:mab/mab.dart';
import 'package:mab/src/data_source_context.dart';
import 'package:meta/meta.dart';

/// Базовый класс параметра
@immutable
abstract class Parameter<I, O> {
  /// имя параметра, по этому имени значение параметра можно
  /// получить из [MethodContext]
  final String id;
  final bool optional;

  final DataType<I, O> dataType;

  /// Изначальное значение, если значение не задано то параметр
  /// считается обязательным
  // final O? initial;

  /// Описание параметра, думаю о том чтобы сделать это поле обязательным
  final String? summary;

  const Parameter({
    required this.id,
    required this.dataType,
    this.summary,
    this.optional = false,
  });

  bool get isRequired => !optional;

  FutureOr<I?> extract(DataSourceContext ctx);
}
