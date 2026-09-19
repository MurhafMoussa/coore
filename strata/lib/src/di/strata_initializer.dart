import 'package:get_it/get_it.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_navigation/strata_navigation.dart';
import 'package:strata_network/strata_network.dart';
import 'package:strata_state/strata_state.dart';
import 'package:strata_storage/strata_storage.dart';
import 'package:strata_ui/strata_ui.dart';

import '../config/strata_config_entity.dart';

/// Orchestrates dependency injection initialization for all Strata sub-packages.
class StrataInitializer {
  const StrataInitializer._();

  /// Initializes all Strata framework sub-packages and awaits [GetIt.allReady].
  static Future<void> initialize(
    StrataConfigEntity config, {
    GetIt? getIt,
  }) async {
    final sl = getIt ?? GetIt.instance;

    sl.registerStrataCore();

    sl.registerStrataStorage(
      secureStorage: config.secureStorage,
    );

    if (config.networkConfig != null) {
      sl.registerStrataNetwork(
        config: config.networkConfig!,
        errorParser: config.errorParser,
        customDio: config.customDio,
        onUnauthenticated: config.onUnauthenticated,
      );
    }

    if (config.navigationConfig != null) {
      sl.registerStrataNavigation(
        navigationConfigEntity: config.navigationConfig!,
        shouldLog: config.shouldLogNavigation,
      );
    }

    sl.registerStrataState();
    sl.registerStrataUi();

    await sl.allReady();
  }

  /// Resets GetIt singletons cleanly for test teardowns.
  static Future<void> reset({
    GetIt? getIt,
    bool dispose = true,
  }) async {
    final sl = getIt ?? GetIt.instance;
    await sl.reset(dispose: dispose);
  }
}
