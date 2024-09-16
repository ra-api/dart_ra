import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/ra.dart';
import 'package:ra/src/core/data_type/data_type_context.dart';
import 'package:ra/src/core/extensitions/extensions.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';

/// Represents the context for a method, used to extract parameter values
/// by name and convert the extracted value to type [T].
@immutable
final class MethodContext {
  /// The map containing the context data.
  final Map<String, dynamic> _context;

  /// The plugin registry associated with the method context.
  final PluginRegistry _pluginRegistry;
  final DataSourceContext _dataSourceContext;

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
    required DataSourceContext dataSourceContext,
    required PluginRegistry pluginRegistry,
    required this.current,
    required this.methods,
    required this.verbose,
  })  : _pluginRegistry = pluginRegistry,
        _dataSourceContext = dataSourceContext;

  /// Retrieves the value associated with the specified [id] from the context.
  ///
  /// Throws a [MethodContextInvalidIdException] if the id is not found in the context.
  /// Throws a [MethodContextCastException] if the retrieved value cannot be cast to type [T].
  T value<T>({required String paramId}) {
    if (!_context.containsKey(paramId)) {
      throw MethodContextInvalidIdException(id: paramId);
    }

    final val = _context[paramId];

    if (val != null && val is! T) {
      throw MethodContextCastException(
        actual: val.runtimeType,
        expected: T,
      );
    }

    return val;
  }

  FutureOr<T?> optional<T>({required String paramId}) {
    try {
      // find parameter
      final parameter = current.parameters.firstWhere((param) {
        return param.id == paramId;
      });

      if (parameter.optional && _context[paramId] == null) {
        return null;
      }

      return lazy(paramId: paramId);
    } on _OptionalArgumentError {
      return null;
    }
  }

  Future<T> lazy<T>({required String paramId}) async {
    // find parameter
    final parameter = current.parameters.firstWhere((param) {
      return param.id == paramId;
    });

    // lazy or instant value
    if (_context.keys.contains(paramId)) {
      final contextValue = _context[paramId];

      if (parameter.optional && contextValue == null) {
        throw _OptionalArgumentError();
      }

      return value(paramId: paramId);
    }

    final dataType = parameter.dataType;
    final dataTypeContext = DataTypeContext(pluginRegistry: _pluginRegistry);
    final rawData = parameter.extract(_dataSourceContext) ?? dataType.initial;
    final result = await dataType.convert(rawData, dataTypeContext);
    _context.putIfAbsent(paramId, () => result);
    if (parameter.optional && result == null) {
      throw _OptionalArgumentError();
    }
    return result;
  }

  /// Retrieves the options of type [T] from the plugin registry.
  T options<T extends PluginOptions>() {
    return _pluginRegistry.options<T>();
  }
}

final class _OptionalArgumentError extends ApiException {
  const _OptionalArgumentError() : super(statusCode: 400);

  @override
  String get reason => 'Parameter value is null';
}
