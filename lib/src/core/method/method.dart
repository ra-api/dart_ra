import 'package:meta/meta.dart';
import 'package:ra/ra.dart';

/// Base class for defining a new method.
@immutable
abstract base class Method<O extends Object> {
  const Method();

  /// The name of the method in camelCase notation.
  String get name;

  /// A description of the purpose of this method. If provided, it will be included in the core.spec.
  String? get summary => null;

  /// The version of the method. If not specified, the currentApiVersion from [Server] will be used.
  double? get version => null;

  /// The content type. See [ResponseContentType].
  ResponseContentType<O> get contentType;

  /// The method for implementing business logic and generating server responses to requests.
  Future<MethodResponse<O>> handle(MethodContext ctx);

  /// Getter for sending a response.
  MethodResponse<O> get response => MethodResponse<O>(contentType);

  /// The set of parameters for the method.
  List<Parameter> get params => [];

  /// The set of plugins for the method.
  List<Plugin> get plugins => [];
}
