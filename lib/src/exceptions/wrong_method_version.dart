part of 'exceptions.dart';

final class WrongMethodVersionException extends ApiException {
  final double invalidVersion;
  final List<double> availableVersions;

  const WrongMethodVersionException({
    required this.invalidVersion,
    required this.availableVersions,
  }) : super(statusCode: 400);

  @override
  String get reason {
    return 'Wrong method version $invalidVersion';
  }

  @override
  JsonType? extraFields(bool verbose) {
    if (!verbose) return null;

    return {'availableVersions': availableVersions};
  }
}
