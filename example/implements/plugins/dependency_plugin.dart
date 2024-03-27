import 'package:mab/mab.dart';

final class DependencyOptions extends PluginOptions {
  final String foo = 'bar';
}

final class DependencyPlugin extends PluginProvider<DependencyOptions>
    implements ErrorHandleHook {
  DependencyPlugin({required super.options});

  @override
  void onErrorHandle(event) {
    print(event.exception.statusCode);
  }
}

final class DependencyConsumerPlugin
    extends PluginConsumer<DependencyOptions> {}
