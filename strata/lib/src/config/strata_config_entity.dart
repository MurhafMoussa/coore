import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:strata_navigation/strata_navigation.dart';
import 'package:strata_network/strata_network.dart';
import 'package:strata_state/strata_state.dart';

/// Configuration entity for initializing the Strata framework.
class const StrataConfigEntity({
  final NetworkConfigEntity? networkConfig,
  final NavigationConfigEntity? navigationConfig,
  final ThemeConfigEntity? themeConfig,
  final LocalizationConfigEntity? localizationConfig,
  final FlutterSecureStorage? secureStorage,
  required final ErrorModelParser errorParser,
  
  final bool shouldLogNavigation = false,
}) extends Equatable {

  @override
  List<Object?> get props => [
        networkConfig,
        navigationConfig,
        themeConfig,
        localizationConfig,
        secureStorage,
        errorParser,
        shouldLogNavigation,
      ];
}
