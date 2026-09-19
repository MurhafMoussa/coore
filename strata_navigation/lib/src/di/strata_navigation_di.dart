import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_navigation/src/config/navigation_config_entity.dart';
import 'package:strata_navigation/src/router/core_router.dart';
import 'package:strata_navigation/src/services/go_router_navigation_service.dart';

/// Extension on [GetIt] to register `strata_navigation` dependencies.
extension StrataNavigationDiExtension on GetIt {
  /// Registers [CoreRouter], [GoRouter], and [NavigationServiceInterface] in GetIt.
  void registerStrataNavigation({
    required NavigationConfigEntity navigationConfigEntity,
    bool shouldLog = false,
  }) {
    final sl = this;

    if (!sl.isRegistered<CoreRouter>()) {
      sl.registerLazySingleton<CoreRouter>(
        () => CoreRouter(
          navigationConfigEntity: navigationConfigEntity,
          shouldLog: shouldLog,
        ),
      );
    }

    if (!sl.isRegistered<GoRouter>()) {
      sl.registerLazySingleton<GoRouter>(
        () => sl<CoreRouter>().router,
      );
    }

    if (!sl.isRegistered<NavigationServiceInterface>()) {
      sl.registerLazySingleton<NavigationServiceInterface>(
        () => GoRouterNavigationService(router: sl<GoRouter>()),
      );
    }
  }
}
