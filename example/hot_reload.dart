import 'dart:io';

import 'package:hotreloader/hotreloader.dart';
import 'package:ra/ra.dart';

typedef OnLogCallback = void Function(String log);

final class HotReload {
  final Server server;
  final OnLogCallback? onLog;

  const HotReload({required this.server, this.onLog});

  Future<void> serve() async {
    bool isVmServiceEnabled = false;
    for (final arg in Platform.executableArguments) {
      if (arg.startsWith('--enable-vm-service')) {
        isVmServiceEnabled = true;
        break;
      }
    }

    if (isVmServiceEnabled) {
      await HotReloader.create(onAfterReload: _onAfterReload);
    }

    await server.serve();
  }

  void _onAfterReload(AfterReloadContext ctx) {
    ctx.events?.forEach((element) {
      onLog?.call(element.path);
    });
  }
}
