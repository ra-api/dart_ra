import 'dart:convert';
import 'dart:typed_data';

import 'package:mab/mab.dart';

/// Алиас чтобы не писать постоянно Map<String, dynamic>
typedef JsonType = Map<String, dynamic>;

/// Интерфейс который должен быть реализован
abstract class JsonResponse {
  JsonType export();
}

/// Делаем новый базовый класс для наследования и прячем таким образом дженерики
abstract base class JsonMethod
    extends Method<MethodJsonContentType, JsonResponse> {
  @override
  ResponseContentType<JsonResponse> get contentType => MethodJsonContentType();

  @override
  Future<MethodJsonResponse> handle(MethodContext ctx);

  /// Этот метод должен возвращать [MethodResponse] но так как мы выше
  /// спрятали дженерики то переопределяем этот метод чтобы он возвращал
  /// [MethodJsonResponse] который наследует [MethodResponse]
  /// поэтому это валидно и проблем не будет с типизацией и кастингом
  @override
  MethodJsonResponse get response => MethodJsonResponse(contentType);
}

/// Также создаем content type тоже без дженериков
final class MethodJsonContentType extends ResponseContentType<JsonResponse> {
  const MethodJsonContentType();

  /// Переводим все это в байты
  @override
  Uint8List apply(JsonResponse data) {
    final json = data.export();
    return utf8.encode(jsonEncode(json));
  }

  /// Реализуем mimeType
  @override
  String get mimeType => 'application/json';
}

/// Убираем дженерики
final class MethodJsonResponse
    extends MethodResponse<MethodJsonContentType, JsonResponse> {
  MethodJsonResponse(super.contentType);
}
