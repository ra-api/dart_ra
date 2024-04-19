import 'dart:io';

import 'package:ra/ra.dart';
import 'package:token_bucket/token_bucket.dart';

import 'implements/plugins/dependency_plugin.dart';
import 'implements/plugins/rate_limit_plugin.dart';
import 'packages/packages.dart';
import 'packages/util/util.dart';

enum ApiVersion {
  v1(1.0),
  v2(2.0);

  final double version;
  const ApiVersion(this.version);
}

Future<void> main(args) async {
  /// Конфигурируем сервер и создаем его, на выходе получаем экземпляр shelf
  /// сервера с хендлером который отвечает за роутинг, выполнение и отдачу
  /// ответа клиенту, с сервером дальше можем делать что нам угодно.
  ///
  /// После запуска по этому адресу localhost:3000/api/core.spec будет
  /// доступен перечень всех методов
  ///
  /// Перед запуском надо установить зависимости, dart pub get в консоли

  final server = Server(
    currentApiVersion: ApiVersion.v2.version,
    provider: ShelfServerProvider(port: 3000, onServe: _onServe),
    packages: const [
      CartPackage(),
      UtilPackage(),
    ],
    plugins: [
      DependencyPlugin(
        options: DependencyOptions(),
      ),
      RateLimitProvider(
        options: RateLimitOptions(
          storage: MemoryBucketStorage(),
        ),
      )
    ],
    verbose: true,
  );

  await server.serve();
}

void _onServe(HttpServer server) {
  server.idleTimeout;
  server.autoCompress = true;

  print('🚀Serving at http://${server.address.host}:${server.port}');
}
