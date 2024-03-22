import 'package:hotreloader/hotreloader.dart';
import 'package:mab/mab.dart';

typedef OnLogCallback = void Function(String log);

final class HotReload {
  final bool enable;
  final Server server;
  final OnLogCallback? onLog;

  const HotReload({required this.server, this.enable = true, this.onLog});

  Future<void> serve() async {
    if (enable) {
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
