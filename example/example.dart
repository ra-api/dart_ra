import 'package:mab/mab.dart';

import 'hot_reload.dart';
import 'packages/packages.dart';

enum ApiVersion {
  v1(1.0),
  v2(2.0);

  final double version;
  const ApiVersion(this.version);
}

final class UtilPackage extends Package {
  const UtilPackage();
  @override
  List<Method<Object>> get methods {
    return [
      PostmanCollectionMethod(
        host: Uri.parse('localhost:3000'),
        collectionName: 'Example Test API',
        methodName: 'postman',
        variables: {'count': '15', 'limit': '20'},
      ),
    ];
  }

  @override
  String get name => 'util';
}

Future<void> main() async {
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
      ErrorHandlerPlugin(),
      DependencyPlugin(
        options: DependencyOptions(),
      ),
    ],
    verbose: true,
  );

  await HotReload(
    enable: true,
    server: server,
    onLog: (log) => print('[UPD] $log'),
  ).serve();
}

void _onServe(server) {
  server.idleTimeout;
  server.autoCompress = true;

  print('🚀Serving at http://${server.address.host}:${server.port}');
}

final class DependencyOptions extends PluginOptions {
  final String foo = 'bar';
}

final class DependencyPlugin extends PluginProvider<DependencyOptions>
    implements EventErrorHandle {
  DependencyPlugin({required super.options});

  @override
  void onErrorHandle(ApiException exception) {
    print(exception.reason);
  }
}

final class DependencyConsumerPlugin extends PluginConsumer<DependencyOptions>
    implements EventErrorHandle {
  @override
  void onErrorHandle(ApiException exception) {
    print(options.foo);
  }
}

final class ErrorHandlerPlugin extends Plugin implements EventErrorHandle {
  @override
  void onErrorHandle(ApiException exception) {
    print(exception.reason);
  }
}
