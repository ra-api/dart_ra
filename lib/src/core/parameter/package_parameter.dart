// import 'package:meta/meta.dart';
// import 'package:ra/src/core/method/method_constraint.dart';
// import 'package:ra/src/core/parameter/parameter.dart';
// import 'package:ra/src/types.dart';
//
// /// Параметр уровня пакет
// @immutable
// abstract base class PackageParameter<I, O> extends Parameter<I, O> {
//   final PackageDataSource source;
//   final List<MethodConstraint>? constraints;
//
//   PackageParameter({
//     required super.id,
//     required this.source,
//     required super.dataType,
//     this.constraints,
//     super.summary,
//   }) : super(dataSource: source.toDataSource());
// }
//
// /// Header параметр, задаем изначально нужный [source]
// @immutable
// base class PackageHeaderParameter<T> extends PackageParameter<String, T> {
//   PackageHeaderParameter({
//     required super.id,
//     required super.dataType,
//     super.constraints,
//     super.summary,
//   }) : super(source: PackageDataSource.header);
//
//   @override
//   String? extract(ctx) => ctx.header(id);
// }
