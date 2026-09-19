import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_navigation/strata_navigation.dart';

void main() {
  group('StrataNavigationDiExtension', () {
    late GetIt getIt;

    setUp(() async {
      getIt = GetIt.asNewInstance();
    });

    test('registerStrataNavigation registers CoreRouter, GoRouter, and NavigationServiceInterface', () {
      final configEntity = NavigationConfigEntity(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox(),
          ),
        ],
      );

      getIt.registerStrataNavigation(navigationConfigEntity: configEntity);

      expect(getIt.isRegistered<CoreRouter>(), isTrue);
      expect(getIt.isRegistered<GoRouter>(), isTrue);
      expect(getIt.isRegistered<NavigationServiceInterface>(), isTrue);

      final navService = getIt<NavigationServiceInterface>();
      expect(navService, isA<GoRouterNavigationService>());
    });
  });
}
