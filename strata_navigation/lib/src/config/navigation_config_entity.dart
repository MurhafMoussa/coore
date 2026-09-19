import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Navigation configuration entity for initializing CoreRouter and GoRouter.
class NavigationConfigEntity extends Equatable {
  const NavigationConfigEntity({
    required this.routes,
    this.initialLocation = '/',
    this.navigatorKey,
    this.refreshListenable,
    this.errorBuilder,
    this.redirect,
    this.navigationObservers = const [],
  });

  final List<RouteBase> routes;
  final String initialLocation;
  final GlobalKey<NavigatorState>? navigatorKey;
  final Listenable? refreshListenable;
  final Widget Function(BuildContext, GoRouterState)? errorBuilder;
  final FutureOr<String?> Function(BuildContext, GoRouterState)? redirect;
  final List<NavigatorObserver> navigationObservers;

  @override
  List<Object?> get props => [
        routes,
        initialLocation,
        navigatorKey,
        refreshListenable,
        errorBuilder,
        redirect,
        navigationObservers,
      ];
}
