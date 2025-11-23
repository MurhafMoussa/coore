import 'package:coore/lib.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

class CoreConfig {
  static Future<void> initializeCoreDependencies(
    CoreConfigEntity configEntity,
  ) async {
    await setupCoreDependencies(configEntity);

    if (configEntity.currentEnvironment == CoreEnvironment.development) {
      EquatableConfig.stringify = true;
      Bloc.observer = TalkerBlocObserver(
        settings: const TalkerBlocLoggerSettings(
          printChanges: true,
          printClosings: true,
          printCreations: true,
        ),
      );
    }
  }

  static Future<void> initializeCoreDependenciesAfterProjectSetup(
    CoreConfigAfterProjectSetupEntity coreEntity,
  ) async {
    // Register CoreRouter
    getIt.registerLazySingleton(
      () => CoreRouter(
        shouldLog: coreEntity.shouldLog,
        navigationConfigEntity: coreEntity.navigationConfigEntity,
      ),
    );

    // CRITICAL: Also register the GoRouter instance itself
    // This enables context-less navigation from BLoCs/Services
    getIt.registerLazySingleton<GoRouter>(
      () => getIt<CoreRouter>().router,
    );
  }
}
