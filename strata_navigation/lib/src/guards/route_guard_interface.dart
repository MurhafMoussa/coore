import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Abstract contract for route access control and permission guards.
abstract class RouteGuardInterface {
  /// Evaluates navigation and returns a redirect location if access is denied, or null if allowed.
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
}
