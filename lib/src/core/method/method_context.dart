import 'package:mab/src/core/method/method_decl.dart';
import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_registry.dart';
import 'package:mab/src/implements/exceptions/exceptions.dart';
import 'package:meta/meta.dart';

/// Класс контекст для метода, служит, для извлечения значения параметра
/// по имени и приведения извлеченного значения до [T]
@immutable
final class MethodCtx {
  final Map<String, dynamic> _context;
  final PluginRegistry _pluginRegistry;
  final List<MethodDecl> methods;
  final MethodDecl current;
  final bool verbose;

  const MethodCtx(
    this._context, {
    required PluginRegistry pluginRegistry,
    required this.current,
    required this.methods,
    required this.verbose,
  }) : _pluginRegistry = pluginRegistry;

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

  T options<T extends PluginOptions>() {
    return _pluginRegistry.options<T>();
  }
}
