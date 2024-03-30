import 'dart:async';

import 'package:mab/src/core/request_context.dart';
import 'package:mab/src/core/response_context.dart';
import 'package:mab/src/implements/exceptions/exceptions.dart';
import 'package:meta/meta.dart';

part 'error_handle_hook.dart';
part 'method_request_hook.dart';
part 'method_response_hook.dart';

@immutable
@internal
class PluginHook {
  const PluginHook();
}
