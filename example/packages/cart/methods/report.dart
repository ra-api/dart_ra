import 'package:mab/src/method_context.dart';
import 'package:request_builder/request_builder.dart';

import '../../../implements/proxy_method.dart';

final class ReportMethod extends ProxyMethod {
  @override
  Future<MethodProxyResponse> handle(MethodContext ctx) async {
    final rb = RequestBuilder();
    final req = rb
        .header(header: 'token', value: '123')
        .get('https://postman-echo.com/get');
    final res = await req;

    return response..body(res.bytes);
  }

  @override
  String get mimeType => 'application/json';

  @override
  String get name => 'report';
}
