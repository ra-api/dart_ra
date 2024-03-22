import 'package:mab/mab.dart';
import 'package:mab/src/plugin/plugin_providers.dart';
import 'package:meta/meta.dart';

/// Класс контекст для метода, служит, для извлечения значения параметра
/// по имени и приведения извлеченного значения до [T]
@immutable
final class MethodContext {
  final Map<String, dynamic> _context;
  final PluginProviders _pluginProviders;
  final List<MethodDecl> methods;
  final MethodDecl current;
  final bool verbose;

  const MethodContext(
    this._context, {
    required PluginProviders pluginProviders,
    required this.current,
    required this.methods,
    required this.verbose,
  }) : _pluginProviders = pluginProviders;

  /// Позволяет достать значение из контекста по id параметра
  T value<T>(String id) {
    if (!_context.containsKey(id)) {
      throw MethodContextInvalidIdException(id: id);
    }

    final val = _context[id];

    if (val != null && val is! T) {
      throw MethodContextCastException(
        actual: val.runtimeType,
        expected: T,
      );
    }

    return val;
  }

  T plugin<T extends PluginProvider>() {
    return _pluginProviders.provider<T>();
  }
}
