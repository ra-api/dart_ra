part of 'parameters.dart';

/// Пример создания настроенного параметра чтобы переиспользовать
final class LimitParameter extends QueryParameter {
  LimitParameter()
      : super(
          id: 'limit',
          dataType: const IntDataType(initial: 15),
          optional: true,
        );
}
