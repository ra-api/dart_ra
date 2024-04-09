import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/request_context.dart';
import 'package:ra/src/core/response_context.dart';
import 'package:ra/src/implements/exceptions/exceptions.dart';

part 'error_handle_hook.dart';
part 'method_request_hook.dart';
part 'method_response_hook.dart';

@immutable
@internal
class PluginHook {
  const PluginHook();
}
