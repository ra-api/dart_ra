import 'package:meta/meta.dart';
import 'package:ra/ra.dart';

/// Abstract base class representing a package.
@immutable
abstract base class Package {
  const Package();

  /// Getter for the name of the package.
  String get name;

  /// Getter for the methods provided by the package.
  List<Method> get methods;

  /// Getter for the parameters provided by the package.
  /// Defaults to an empty list.
  List<Parameter> get params => [];
}
