import 'package:mab/mab.dart';

import 'packages/packages.dart';

Future<void> main() async {
  /// Конфигурируем сервер и создаем его, на выходе получаем экземпляр shelf
  /// сервера с хендлером который отвечает за роутинг, выполнение и отдачу
  /// ответа клиенту, с сервером дальше можем делать что нам угодно.
  ///
  /// После запуска по этому адресу localhost:3000/api/core.spec будет
  /// доступен перечень всех методов
  ///
  /// Перед запуском надо установить зависимости, dart pub get в консоли
  final server = await Server(
    currentApiVersion: 2,
    port: 3000,
    packages: const [
      CartPackage(),
    ],
    verbose: true,
    poweredBy: 'MAB',
  ).create();

  server.idleTimeout;
  server.autoCompress = true;
}
