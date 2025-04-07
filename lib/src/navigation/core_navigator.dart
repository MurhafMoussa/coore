import 'package:coore/src/config/entities/navigation_config_entity.dart';
import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:coore/src/navigation/screen_params/base_screen_params.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoreNavigator {
  CoreNavigator({
    required CoreLogger logger,
    required NavigationConfigEntity navigationConfigEntity,
    required this.shouldLog,
  }) : _logger = logger,
       refreshListenable = navigationConfigEntity.refreshListenable,
       _configEntity = navigationConfigEntity {
    _goRouter = _createRouter();
  }

  final CoreLogger _logger;
  final NavigationConfigEntity _configEntity;
  final Listenable? refreshListenable; // For auth state changes
  late final GoRouter _goRouter;
  final bool shouldLog;
  static final GlobalKey<NavigatorState> _routeNavigationKey = GlobalKey(
    debugLabel: 'root',
  );

  GoRouter get router => _goRouter;

  GlobalKey<NavigatorState> get routeNavigationKey => _routeNavigationKey;

  static BuildContext get appContext {
    try {
      return _routeNavigationKey.currentState!.context;
    } catch (e) {
      rethrow;
    }
  }

  GoRouter refreshRouter() => _createRouter();

  static BuildContext _getContext(BuildContext? context) =>
      context ?? appContext;

  /// Helper to process a path by replacing path parameters and appending query parameters.
  static String _processPath(String path, BaseScreenParams? arguments) {
    String processedPath = path;

    // Replace path parameters
    if (arguments?.pathParams.isNotEmpty ?? false) {
      arguments!.pathParams.forEach((key, value) {
        processedPath = processedPath.replaceAll(':$key', value);
      });
    }

    // Append query parameters if any.
    if (arguments?.queryParams.isNotEmpty ?? false) {
      final uri = Uri.parse(
        processedPath,
      ).replace(queryParameters: arguments!.queryParams);
      processedPath = uri.toString();
    }

    return processedPath;
  }

  /// Navigate using a named route, replacing the current route.
  static void toNamed(
    String routeName, {
    BaseScreenParams? arguments,
    BuildContext? context,
  }) {
    try {
      final ctx = _getContext(context);
      final location = ctx.namedLocation(
        routeName,
        queryParameters: arguments?.queryParams ?? {},
        pathParameters: arguments?.pathParams ?? {},
      );
      ctx.go(location, extra: arguments?.extra);
    } catch (ex, stackTrace) {
      getIt<CoreLogger>().error('Error in named navigation', ex, stackTrace);
    }
  }

  /// Navigate using a path, replacing the current route.
  static void toPath(
    String path, {
    BaseScreenParams? arguments,
    BuildContext? context,
  }) {
    try {
      final ctx = _getContext(context);
      final processedPath = _processPath(path, arguments);
      ctx.go(processedPath, extra: arguments?.extra);
    } catch (ex, stackTrace) {
      getIt<CoreLogger>().error('Error in path navigation', ex, stackTrace);
    }
  }

  /// Push a named route onto the navigation stack.
  static void pushNamed(
    String routeName, {
    BaseScreenParams? arguments,
    BuildContext? context,
  }) {
    try {
      _getContext(context).pushNamed(
        routeName,
        pathParameters: arguments?.pathParams ?? {},
        queryParameters: arguments?.queryParams ?? {},
        extra: arguments?.extra,
      );
    } catch (ex, stackTrace) {
      getIt<CoreLogger>().error(
        'Error in named push navigation',
        ex,
        stackTrace,
      );
    }
  }

  /// Push a route onto the navigation stack using its path.
  static void pushPath(
    String path, {
    BaseScreenParams? arguments,
    BuildContext? context,
  }) {
    try {
      final ctx = _getContext(context);
      final processedPath = _processPath(path, arguments);
      ctx.push(processedPath, extra: arguments?.extra);
    } catch (ex, stackTrace) {
      getIt<CoreLogger>().error(
        'Error in path push navigation',
        ex,
        stackTrace,
      );
    }
  }

  static String getCurrentLocation({BuildContext? context}) {
    try {
      final ctx = _getContext(context);
      return GoRouter.of(
        ctx,
      ).routerDelegate.currentConfiguration.last.matchedLocation;
    } catch (ex, stackTrace) {
      getIt<CoreLogger>().error(
        'Error fetching current location',
        ex,
        stackTrace,
      );
      rethrow;
    }
  }

  static void pop<T extends Object?>(BuildContext? context, [T? result]) {
    final ctx = _getContext(context);
    if (ctx.canPop()) {
      ctx.pop(result);
    } else {
      getIt<CoreLogger>().warning('NavigationService.pop: Cannot pop screen');
      throw Exception('Cannot pop - no previous screen available');
    }
  }

  GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: _routeNavigationKey,
      routes: _configEntity.routes,
      errorBuilder: _configEntity.errorBuilder ?? _defaultErrorWidget,
      debugLogDiagnostics: shouldLog,
      redirect: _configEntity.redirect,
      refreshListenable: refreshListenable,
      observers: [
        if (shouldLog) CoreNavigationObserver(_logger),
        ..._configEntity.navigationObservers,
      ],
    );
  }

  Widget _defaultErrorWidget(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(state.error?.message ?? '')),
    );
  }
}

class CoreNavigationObserver extends NavigatorObserver {
  CoreNavigationObserver(this._logger);
  final CoreLogger _logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logAndTrack('PUSH', route, previousRoute);
    super.didPush(route, previousRoute);
  }

  // Override other methods similarly (didPop, didReplace, didRemove)...

  void _logAndTrack(
    String action,
    Route<dynamic>? route,
    Route<dynamic>? previousRoute,
  ) {
    final currentRouteName = route?.settings.name ?? 'Unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'Unknown';

    _logger.debug(
      'Navigation Action: $action | Current: $currentRouteName | Previous: $previousRouteName',
    );
  }
}
