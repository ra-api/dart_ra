import 'dart:async';

import 'package:meta/meta.dart';

/// Интерфейс для реализации извлечения данных из запроса валидации, конвертации
/// и валидации.
@immutable
abstract class DataType<I, O> {
  const DataType();

  /// Описание для DataType в кратце для чего он нужен и какие
  /// функции выполняет
  String get summary;

  /// Конвертирование данных из I в O, например из строки в булево или
  /// целочисленное значение, так как заголовки и query параметры это всегда
  /// строки, то штука весьма полезная
  FutureOr<O> convert(I data);
}
