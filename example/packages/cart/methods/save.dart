import 'package:mab/mab.dart';

import '../../../implements/implements.dart';

final class CartSaveMethod extends JsonMethod {
  CartSaveMethod();

  @override
  String get name => 'save';

  @override
  Future<MethodJsonResponse> handle(ctx) async {
    /// Получаем проверенный сконвертированный тип данных по параметру
    final preview = ctx.value<bool>('preview');
    final body = ctx.value('body');
    print(body);
    final cart = Cart(preview: preview);

    /// response это getter который реализован в Json
    return response..body(cart);
  }

  @override
  List<MethodParameter> get params {
    return [
      /// Задаем query параметр preview который если не передан
      /// будет равен false, то есть не обязателен
      MethodQueryParameter(
        id: 'preview',
        dataType: BoolDataType(),
        initial: false,
        summary: 'Предпросмотр промоакций для заказа',
      ),

      MethodBodyParameter(dataType: JsonBodyDataType()),
    ];
  }
}

/// MethodJsonResponse должен возвращать body JsonResponse это значит,
/// что Cart должен содержать метод toJson()
/// Для примера модель максимально простая
final class Cart implements JsonResponse {
  final bool preview;

  const Cart({required this.preview});

  /// Реализуем данный метод, для простоты руками без всяких json_serializable
  /// и freezed
  @override
  JsonType export() {
    return {'preview': preview};
  }
}
