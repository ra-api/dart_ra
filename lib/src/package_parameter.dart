import 'package:mab/src/parameter.dart';
import 'package:meta/meta.dart';

import 'types.dart';

/// Параметр уровня пакет
@immutable
abstract base class PackageParameter<I, O> extends Parameter<I, O> {
  final PackageDataSource source;

  const PackageParameter({
    required super.id,
    required this.source,
    required super.dataType,
    super.summary,
    super.initial,
  });
}

// /// Cookie параметр, задаем изначально нужный [source]
// @immutable
// class PackageCookieParameter<T> extends PackageParameter<String, T> {
//   const PackageCookieParameter({
//     required super.id,
//     required super.dataType,
//     super.summary,
//     super.initial,
//   }) : super(source: PackageDataSource.cookie);
// }

/// Header параметр, задаем изначально нужный [source]
@immutable
base class PackageHeaderParameter<T> extends PackageParameter<String, T> {
  const PackageHeaderParameter({
    required super.id,
    required super.dataType,
    super.summary,
    super.initial,
  }) : super(source: PackageDataSource.cookie);

  @override
  String? extract(ctx) => ctx.header(id);
}
