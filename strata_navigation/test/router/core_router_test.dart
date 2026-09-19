import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:strata_navigation/strata_navigation.dart';

void main() {
  group('CoreRouter', () {
    testWidgets('creates GoRouter and renders initial location', (tester) async {
      final configEntity = NavigationConfigEntity(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Text('Home Screen'),
            ),
          ),
        ],
      );

      final coreRouter = CoreRouter(navigationConfigEntity: configEntity);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: coreRouter.router,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);
    });

    test('refreshRouter recreates GoRouter instance', () {
      final configEntity = NavigationConfigEntity(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox(),
          ),
        ],
      );

      final coreRouter = CoreRouter(navigationConfigEntity: configEntity);
      final initialRouter = coreRouter.router;

      coreRouter.refreshRouter();
      final refreshedRouter = coreRouter.router;

      expect(refreshedRouter, isNot(same(initialRouter)));
    });
  });
}
