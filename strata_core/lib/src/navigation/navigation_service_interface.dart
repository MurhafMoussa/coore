/// Pure Dart contract for navigation operations across the framework.
abstract class NavigationServiceInterface {
  /// Navigates to a specific route location.
  void go(String location, {Object? extra});

  /// Pushes a new route onto the navigation stack and optionally returns a result.
  Future<T?> push<T>(String location, {Object? extra});

  /// Pops the top-most route off the navigation stack with an optional result.
  void pop<T>([T? result]);

  /// Replaces the current route on top of the stack with a new location.
  void replace(String location, {Object? extra});

  /// Returns whether the navigation stack can pop.
  bool canPop();
}
