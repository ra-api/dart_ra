import 'package:mab/mab.dart';

final class SpecMethod extends Method<JsonContentType, Object> {
  const SpecMethod();

  @override
  Future<MethodResponse<JsonContentType, Object>> handle(ctx) async {
    final res = ctx.methods.map((e) => e.export()).toList(growable: false);

    return response..body(res);
  }

  @override
  String get name => 'spec';

  @override
  ResponseContentType<Object> get contentType {
    return JsonContentType();
  }
}
