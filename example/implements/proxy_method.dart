import 'dart:typed_data';

import 'package:mab/mab.dart';

abstract base class ProxyMethod
    extends Method<MethodProxyContentType, Uint8List> {
  String get mimeType;

  @override
  Future<MethodProxyResponse> handle(MethodContext ctx);

  /// Создаем contentType и прокидываем через конструктор какой
  /// нам надо mimeType
  @override
  MethodProxyContentType get contentType => MethodProxyContentType(mimeType);

  /// Реализуем response
  @override
  MethodProxyResponse get response => MethodProxyResponse(contentType);
}

/// Прячем дженерики
final class MethodProxyContentType extends ResponseContentType<Uint8List> {
  final String _mimeType;

  const MethodProxyContentType(this._mimeType);

  /// Отдаем как есть ничего не делая, как были байты так и останутся,
  /// но интерфейс надо реализовать
  @override
  Uint8List apply(Uint8List data, _) => data;

  /// Делаем mimeType управляемым через конструктор
  @override
  String get mimeType => _mimeType;
}

/// Прячем дженерики
final class MethodProxyResponse
    extends MethodResponse<MethodProxyContentType, Uint8List> {
  MethodProxyResponse(super.contentType);
}
