import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:strata_navigation/strata_navigation.dart';

void main() {
  group('NavigationConfigEntity', () {
    test('instantiates with default values and supports value equality', () {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => const SizedBox(),
        ),
      ];

      final config1 = NavigationConfigEntity(routes: routes);
      final config2 = NavigationConfigEntity(routes: routes);

      expect(config1.initialLocation, equals('/'));
      expect(config1.navigationObservers, isEmpty);
      expect(config1.navigatorKey, isNull);
      expect(config1, equals(config2));
    });
  });
}
