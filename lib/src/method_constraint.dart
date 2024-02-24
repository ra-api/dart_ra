import 'method.dart';

enum _ConstraintKind { all, allow, deny }

final class MethodConstraint<T extends Method> {
  final _ConstraintKind _kind;

  MethodConstraint._(_ConstraintKind kind) : _kind = kind;

  bool allow(Method method) {
    return switch (_kind) {
      _ConstraintKind.all => true,
      _ConstraintKind.deny => method is! T,
      _ConstraintKind.allow => method is T,
    };
  }

  factory MethodConstraint.all() {
    return MethodConstraint._(_ConstraintKind.all);
  }

  factory MethodConstraint.allow() {
    return MethodConstraint._(_ConstraintKind.allow);
  }

  factory MethodConstraint.deny() {
    return MethodConstraint._(_ConstraintKind.deny);
  }
}
