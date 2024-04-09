import 'package:meta/meta.dart';
import 'package:ra/src/core/parameter/method_parameter.dart';
import 'package:ra/src/core/parameter/package_parameter.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/core/registry.dart';
import 'package:ra/src/types.dart';

/// Информация о методе, используется в core.spec но планируется,
/// что в том или ином виде будет добавлено в [MethodCtx]
@immutable
final class MethodDecl {
  final RegistryItem _registryItem;

  const MethodDecl(this._registryItem);

  String get httpMethod => _registryItem.httpMethod;
  String get package => _registryItem.package.name;

  String get name => _registryItem.method.name;
  double get version => _registryItem.version;
  String get mimeType => _registryItem.method.contentType.mimeType;
  String get summary {
    return _registryItem.method.summary ?? 'Method $package.$name';
  }

  List<Parameter> get parameters {
    return _registryItem.params;
  }

  JsonType export() {
    final res = <String, dynamic>{
      'method': httpMethod,
      'package': package,
      'name': name,
      'summary': summary,
      'version': version,
      'mimeType': mimeType,
    };

    if (_registryItem.params.isNotEmpty) {
      final params = parameters.map(
        (e) {
          return {
            'name': e.id,
            'summary': e.summary ?? 'Parameter "${e.id}"',
            'source': _source(e),
            'required': e.isRequired,
          };
        },
      ).toList(growable: false);
      res['params'] = params;
    }

    return res;
  }

  String _source(Parameter param) {
    if (param is MethodParameter) {
      return param.source.source;
    }

    if (param is PackageParameter) {
      return param.source.source;
    }

    throw UnimplementedError();
  }
}
