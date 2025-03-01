import 'package:coore/src/config/entities/core_config_entity.dart';
import 'package:coore/src/dependency_injection/dependency_injection.dart';
import 'package:coore/src/dev_tools/core_bloc_observer.dart';
import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:coore/src/environment/environment_config.dart';
import 'package:coore/src/ui/message_viewers/toaster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoreConfig {
  static Future<void> initializeCoreDependencies(
    CoreConfigEntity configEntity,
  ) async {
    await setupCoreDependencies(configEntity);
    await getIt<EnvironmentConfig>().loadEnv(configEntity.currentEnvironment);
    Bloc.observer = CoreBlocObserver(getIt<CoreLogger>());
  }

  static Future<void> initializeCoreDependenciesWithContext(
    BuildContext context,
  ) async {
    getIt<Toaster>().init(context);
  }
}
