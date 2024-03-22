import 'dart:convert';
import 'dart:typed_data';

import 'package:mab/mab.dart';

final class PlantUmlMethod extends Method<String> {
  final String projectName;

  PlantUmlMethod({required this.projectName});
  @override
  ResponseContentType<String> get contentType => PlainTextContentType();

  Map<String, List<MethodDecl>> _packages(List<MethodDecl> methods) {
    return methods.fold(<String, List<MethodDecl>>{}, (registry, method) {
      if (registry.containsKey(method.package)) {
        registry[method.package]!.add(method);
      } else {
        registry.putIfAbsent(method.package, () => [method]);
      }
      return registry;
    });
  }

  List<String> _packagesUml(Map<String, List<MethodDecl>> packages) {
    final umlPackages = <String>[];

    for (final package in packages.keys) {
      final methods = <String>[];

      for (final decl in packages[package]!) {
        final method = '''
  map "${decl.name} v${decl.version}" as ${decl.name} {
    summary => ${decl.summary}
    method => ${decl.httpMethod}
    mimeType => ${decl.mimeType}
  } 
        ''';
        methods.add(method);
      }

      final uml = '''
package $package {
${methods.join('\n')}
}
      ''';

      umlPackages.add(uml);
    }

    return umlPackages;
  }

  @override
  Future<MethodResponse<String>> handle(MethodContext ctx) async {
    final packages = _packages(ctx.methods);
    final umlPackages = _packagesUml(packages);
    final uml = '''
@startuml
left to right direction
' Horizontal lines: -->, <--, <-->
' Vertical lines: ->, <-, <->
title PERT: $projectName

${umlPackages.join('\n')}
@enduml
    ''';
    return response..body(uml);
  }

  @override
  String get name => 'plantUml';
}

base class PlainTextContentType implements ResponseContentType<String> {
  const PlainTextContentType();

  @override
  Uint8List apply(String data, _) {
    return utf8.encode(data);
  }

  @override
  String get mimeType => 'plain/text';
}
