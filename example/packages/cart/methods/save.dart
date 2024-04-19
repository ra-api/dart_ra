import 'package:ra/ra.dart';
import 'package:token_bucket/token_bucket.dart';

import '../../../implements/implements.dart';
import '../../../implements/plugins/rate_limit_plugin.dart';

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
  List<Plugin> get plugins {
    return [
      RateLimitConsumer(
        capacity: 3,
        frequency: RefillFrequency.minute,
        bucketId: (ctx) => 'bucketId-${ctx.queries['preview']}',
      )
    ];
  }

  @override
  List<Parameter> get params {
    return [
      /// Задаем query параметр preview который если не передан
      /// будет равен false, то есть не обязателен
      QueryParameter(
        id: 'preview',
        dataType: BoolDataType(initial: false),
        summary: 'Предпросмотр промоакций для заказа',
      ),

      BodyParameter(dataType: JsonBodyDataType()),
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
