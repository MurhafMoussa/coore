import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationConfigEntity extends Equatable {
  const NavigationConfigEntity({
    required this.routes,
    required this.initialRoute,
    
    this.errorBuilder,
    this.redirect,
    this.navigationObservers = const [],
    this.refreshListenable,
  });
  final List<RouteBase> routes;
  final String initialRoute;
 
  final Widget Function(BuildContext, GoRouterState)? errorBuilder;
  final Future<String?> Function(BuildContext, GoRouterState)? redirect;
  final Listenable? refreshListenable;
  final List<NavigatorObserver> navigationObservers;

  @override
  List<Object?> get props => [
    routes,
    initialRoute,
 
    errorBuilder,
    redirect,
    navigationObservers,
  ];
}
