// Базовый класс для метода
import 'package:mab/mab.dart';
import 'package:meta/meta.dart';

/// Базовый класс, для задания нового метода
@immutable
abstract base class Method<O extends Object> {
  const Method();

  /// Имя метода в camelCase нотации, пока на это проверки нет
  String get name;

  /// Произвольная строка с описанием для чего нужен этот метод,
  /// при наличии поподает в core.spec
  String? get summary => null;

  /// Версия метода, метод в пакете может иметь одинаковое название но разные
  /// версии, если версия не указана,
  /// то будет использоваться currentApiVersion из [Server]
  double? get version => null;

  /// Content type - см [ResponseContentType]
  ResponseContentType<O> get contentType;

  /// Место для имплементаци бизнес логики и формирования
  /// ответа сервера на запрос
  Future<MethodResponse<O>> handle(MethodCtx ctx);

  /// Getter для отправки ответа
  MethodResponse<O> get response => MethodResponse<O>(contentType);

  /// Набор параметров метода
  List<MethodParameter> get params => [];
}
