import 'package:coore/src/config/entities/core_config_entity.dart';
import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

class CoreConfig {
  static Future<void> initializeCoreDependencies(
    CoreConfigEntity configEntity,
  ) async {
    await setupCoreDependencies(configEntity);

    Bloc.observer = TalkerBlocObserver(
      settings: const TalkerBlocLoggerSettings(
        printChanges: true,
        printClosings: true,
        printCreations: true,
      ),
    );
  }
}
