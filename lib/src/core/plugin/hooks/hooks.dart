import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/api_exception.dart';
import 'package:ra/src/core/server/server.dart';

part 'error_handle_hook.dart';
part 'method_request_hook.dart';
part 'method_response_hook.dart';

/// Base class for plugin hooks.
@immutable
@internal
class PluginHook {
  const PluginHook();
}
