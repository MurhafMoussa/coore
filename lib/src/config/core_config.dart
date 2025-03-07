import 'package:coore/src/config/entities/core_config_entity.dart';
import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:coore/src/dev_tools/core_bloc_observer.dart';
import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoreConfig {
  static Future<void> initializeCoreDependencies(
    CoreConfigEntity configEntity,
  ) async {
    await setupCoreDependencies(configEntity);

    Bloc.observer = CoreBlocObserver(getIt<CoreLogger>());
  }
}
