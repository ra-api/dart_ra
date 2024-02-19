import 'package:mab/mab.dart';

import '../../../implements/json_method.dart';

final class CartSaveMethod extends JsonMethod {
  CartSaveMethod();

  @override
  String get name => 'save';

  @override
  Future<MethodJsonResponse> handle(ctx) async {
    /// Получаем проверенный сконвертированный тип данных по параметру
    final preview = ctx.value<bool>('preview');
    final cart = Cart(preview: preview);

    /// response это getter который реализован в Json
    return response..body(cart);
  }

  @override
  List<MethodParameter> get params {
    return [
      /// Задаем query параметр preview который если не передан
      /// будет равен false, то есть не обязателен
      QueryParameter<bool>(
        id: 'preview',
        dataType: BoolDataType(),
        initial: false,
        summary: 'Предпросмотр промоакций для заказа',
      ),
    ];
  }
}

/// MethodJsonResponse должен возвращать body JsonResponse это значит,
/// что Cart должен содержать метод toJson()
/// Для примера модель максимально простая
final class Cart implements JsonResponse {
  final bool preview;

  Cart({required this.preview});

  /// Реализуем данный метод, для простоты руками без всяких json_serializable
  /// и freezed
  @override
  JsonType export() {
    return {'preview': preview};
  }
}
