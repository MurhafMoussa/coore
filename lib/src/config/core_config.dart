import 'package:coore/lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

class CoreConfig {
  static Future<void> initializeCoreDependencies(
    CoreConfigEntity configEntity,
  ) async {
    await setupCoreDependencies(configEntity);

    if (configEntity.currentEnvironment == CoreEnvironment.development) {
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
    getIt.registerLazySingleton(
      () => CoreNavigator(
        logger: getIt(),
        shouldLog: coreEntity.shouldLog,
        navigationConfigEntity: coreEntity.navigationConfigEntity,
      ),
    );
  }
}
