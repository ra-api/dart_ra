import 'package:meta/meta.dart';
import 'package:ra/src/core/method/method_decl.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';
import 'package:ra/src/implements/exceptions/exceptions.dart';

/// Represents the context for a method, used to extract parameter values
/// by name and convert the extracted value to type [T].
@immutable
final class MethodContext {
  /// The map containing the context data.
  final Map<String, dynamic> _context;

  /// The plugin registry associated with the method context.
  final PluginRegistry _pluginRegistry;

  /// The list of available methods.
  final List<MethodDecl> methods;

  /// The current method declaration.
  final MethodDecl current;

  /// A flag indicating whether verbose logging is enabled.
  final bool verbose;

  /// Constructs a [MethodContext] with the specified parameters.
  ///
  /// [_context] is a map containing the context data.
  /// [pluginRegistry] is the plugin registry associated with the method context.
  /// [methods] is the list of available methods.
  /// [current] is the current method declaration.
  /// [verbose] indicates whether verbose logging is enabled.
  const MethodContext(
    this._context, {
    required PluginRegistry pluginRegistry,
    required this.current,
    required this.methods,
    required this.verbose,
  }) : _pluginRegistry = pluginRegistry;

  /// Retrieves the value associated with the specified [id] from the context.
  ///
  /// Throws a [MethodContextInvalidIdException] if the id is not found in the context.
  /// Throws a [MethodContextCastException] if the retrieved value cannot be cast to type [T].
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

  /// Retrieves the options of type [T] from the plugin registry.
  T options<T extends PluginOptions>() {
    return _pluginRegistry.options<T>();
  }
}
