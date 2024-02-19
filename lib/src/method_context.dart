import 'package:meta/meta.dart';

/// Класс контекст для метода, служит, для извлечения значения параметра
/// по имени и приведения извлеченного значения до [T]
@immutable
final class MethodContext {
  final Map<String, Object> _context;

  const MethodContext(this._context);

  value<T>(String id) {
    final val = _context[id];

    return val as T;
  }
}
