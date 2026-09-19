import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strata_navigation/src/config/navigation_config_entity.dart';

/// Core router that configures and holds the GoRouter instance.
class CoreRouter {
  CoreRouter({
    required NavigationConfigEntity navigationConfigEntity,
    bool shouldLog = false,
  })  : _configEntity = navigationConfigEntity,
        _shouldLog = shouldLog,
        refreshListenable = navigationConfigEntity.refreshListenable {
    _goRouter = _createRouter();
  }

  final NavigationConfigEntity _configEntity;
  final Listenable? refreshListenable;
  final bool _shouldLog;

  late GoRouter _goRouter;

  /// Provides the configured GoRouter instance.
  GoRouter get router => _goRouter;

  /// Re-creates or refreshes the GoRouter instance with current configuration.
  void refreshRouter() {
    _goRouter = _createRouter();
  }

  GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: _configEntity.navigatorKey,
      initialLocation: _configEntity.initialLocation,
      routes: _configEntity.routes,
      errorBuilder: _configEntity.errorBuilder ?? _defaultErrorWidget,
      debugLogDiagnostics: _shouldLog,
      restorationScopeId: 'coreRouter',
      redirect: _configEntity.redirect,
      refreshListenable: refreshListenable,
      observers: [..._configEntity.navigationObservers],
    );
  }

  Widget _defaultErrorWidget(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(state.error?.message ?? 'Route navigation error'),
      ),
    );
  }
}
