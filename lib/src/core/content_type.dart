import 'dart:typed_data';

import 'package:mab/src/core/method/method_decl.dart';
import 'package:meta/meta.dart';

/// Интерфейс для реализации преобразования T в бинарный вид
@immutable
abstract class ResponseContentType<T extends Object> {
  /// С байтами работать проще всего, поэтому наш T мы ковертируем в байты
  Uint8List apply(T data, MethodDecl? decl);

  /// Это строка, которая будет добавлять в ответ сервера заголовок content-type
  String get mimeType;

  const ResponseContentType();
}