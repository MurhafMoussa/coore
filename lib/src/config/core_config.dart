import 'package:coore/src/dependency_injection/dependency_injection.dart';
import 'package:coore/src/dev_tools/core_bloc_observer.dart';
import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoreConfig {
  static Future<void> initializeCoreDependencies() async {
    await setupCoreDependencies();
    Bloc.observer = CoreBlocObserver(getIt<CoreLogger>());
  }
}
