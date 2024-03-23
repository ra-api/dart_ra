import 'package:mab/src/core/method/method.dart';
import 'package:mab/src/core/parameter/package_parameter.dart';
import 'package:meta/meta.dart';

/// Интерфейс для создания нового пакета, пакет это некий неймспейс для методов
@immutable
abstract base class Package {
  const Package();

  /// Имя пакета, рекомендуется чтобы это было одно слово, пакет ~= фича
  String get name;

  /// Методы, которые входят в пакет
  List<Method> get methods;

  List<PackageParameter> get params => [];
}
