import 'package:mab/mab.dart';
import 'package:meta/meta.dart';

/// Класс контекст для метода, служит, для извлечения значения параметра
/// по имени и приведения извлеченного значения до [T]
@immutable
final class MethodContext {
  final Map<String, dynamic> _context;
  final List<MethodDecl> methods;
  final MethodDecl current;
  final bool verbose;

  const MethodContext(
    this._context, {
    required this.current,
    required this.methods,
    required this.verbose,
  });

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
}
