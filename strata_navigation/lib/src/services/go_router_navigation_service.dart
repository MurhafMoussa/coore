import 'package:go_router/go_router.dart';
import 'package:strata_core/strata_core.dart';

/// Default GoRouter implementation of [NavigationServiceInterface].
class GoRouterNavigationService({required GoRouter router})
    implements NavigationServiceInterface {
  // ignore: prefer_initializing_formals
  this : _router = router;

  final GoRouter _router;

  /// Underlying GoRouter instance.
  GoRouter get router => _router;

  @override
  void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  @override
  Future<T?> push<T>(String location, {Object? extra}) {
    return _router.push<T>(location, extra: extra);
  }

  @override
  void pop<T>([T? result]) {
    _router.pop<T>(result);
  }

  @override
  void replace(String location, {Object? extra}) {
    _router.replace(location, extra: extra);
  }

  @override
  bool canPop() {
    return _router.canPop();
  }
}
