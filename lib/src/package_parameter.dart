import 'package:mab/src/parameter.dart';
import 'package:meta/meta.dart';

import 'method_constraint.dart';
import 'types.dart';

/// Параметр уровня пакет
@immutable
abstract base class PackageParameter<I, O> extends Parameter<I, O> {
  final PackageDataSource source;
  final List<MethodConstraint>? constraints;

  const PackageParameter({
    required super.id,
    required this.source,
    required super.dataType,
    this.constraints,
    super.summary,
    super.initial,
  });
}

/// Header параметр, задаем изначально нужный [source]
@immutable
base class PackageHeaderParameter<T> extends PackageParameter<String, T> {
  const PackageHeaderParameter({
    required super.id,
    required super.dataType,
    super.constraints,
    super.summary,
    super.initial,
  }) : super(source: PackageDataSource.cookie);

  @override
  String? extract(ctx) => ctx.header(id);
}
