import 'package:meta/meta.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/core/registry.dart';
import 'package:ra/src/types.dart';

/// Represents a method declaration, providing information about the method.
@immutable
final class MethodDecl {
  /// The registry item associated with the method declaration.
  final RegistryItem _registryItem;

  /// Constructs a [MethodDecl] with the specified registry item.
  const MethodDecl(this._registryItem);

  /// Gets the HTTP method of the method.
  String get httpMethod => _registryItem.httpMethod;

  /// Gets the package name of the method.
  String get package => _registryItem.package.name;

  /// Gets the name of the method.
  String get name => _registryItem.method.name;

  /// Gets the version of the method.
  double get version => _registryItem.version;

  /// Gets the MIME type of the method.
  String get mimeType => _registryItem.method.contentType.mimeType;

  /// Gets the summary description of the method.
  String get summary {
    return _registryItem.method.summary ?? 'Method $package.$name';
  }

  /// Gets the list of parameters of the method.
  List<Parameter> get parameters {
    return _registryItem.paramsData.map((e) {
      return e.parameter;
    }).toList(growable: false);
  }

  /// Exports the method information to JSON format.
  JsonType export() {
    final res = <String, dynamic>{
      'method': httpMethod,
      'package': package,
      'name': name,
      'summary': summary,
      'version': version,
      'mimeType': mimeType,
    };

    if (_registryItem.paramsData.isNotEmpty) {
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

  /// Gets the source of the parameter.
  String _source(Parameter param) {
    return param.source.source;
  }
}
