# strata_navigation

GoRouter wrapper package and navigation abstractions for the Strata framework.

## Overview

`strata_navigation` provides navigation services, route guard abstractions, type-safe route parameters (`ScreenParams`), and GoRouter configuration wrappers (`CoreRouter`) built on top of `strata_core`'s `NavigationServiceInterface`.

## Architectural Rules & Boundaries

- **Router Engine Abstraction**: Defines `GoRouterNavigationService` implementing pure Dart `NavigationServiceInterface` from `strata_core`.
- **Package Dependencies**: Depends ONLY on `strata_core`, `flutter`, `go_router`, and `get_it`.
- **Strict Boundary Enforcement**: Prohibits UI state (`flutter_bloc`), local database (`isotope`), or networking dependencies, enforced via package boundary audit tests.

## Key Components

### 1. `NavigationServiceInterface` & `GoRouterNavigationService`
Router-agnostic navigation contract allowing BLoCs and services to navigate, replace, push, or pop without coupling to GoRouter or Flutter UI context directly.

```dart
import 'package:strata_navigation/strata_navigation.dart';

final NavigationServiceInterface navigationService = GoRouterNavigationService(router);

// Navigate to location
navigationService.go('/details', extra: {'id': '123'});

// Push or pop
navigationService.push('/settings');
navigationService.pop();
```

### 2. `CoreRouter` & `NavigationConfigEntity`
Configures GoRouter with observers, route guards, error pages, and initial routes.

```dart
final router = CoreRouter(
  config: NavigationConfigEntity(
    initialLocation: '/home',
    routes: [ ... ],
    guards: [ AuthRouteGuard() ],
  ),
).router;
```

### 3. `RouteGuardInterface`
Declarative contract for route guards evaluated before navigation transitions.

```dart
class AuthRouteGuard implements RouteGuardInterface {
  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final isAuthenticated = await checkAuthStatus();
    if (!isAuthenticated) return '/login';
    return null; // Allow navigation
  }
}
```

### 4. `ScreenParams` & Parameter Handling
Encapsulates route parameters for type-safe screen argument passing.

```dart
class DetailsScreenParams extends BaseScreenParams {
  final String itemId;
  const DetailsScreenParams({required this.itemId});
}
```

### 5. Dependency Injection
Registers navigation dependencies with GetIt using `registerStrataNavigation()`:

```dart
final getIt = GetIt.instance;
getIt.registerStrataNavigation(
  config: NavigationConfigEntity(initialLocation: '/'),
);
```

## Running Tests & Audits

Run static analysis and tests inside the `strata_navigation` directory:

```bash
cd strata_navigation
flutter analyze
flutter test
```
