import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:strata_network/strata_network.dart';
import 'package:strata_state/strata_state.dart';

/// Configuration entity for initializing the Strata framework.
class StrataConfigEntity extends Equatable {
  const StrataConfigEntity({
    this.networkConfig,
    this.themeConfig,
    this.localizationConfig,
    this.secureStorage,
    required this.errorParser,
  });

  final NetworkConfigEntity? networkConfig;
  final ThemeConfigEntity? themeConfig;
  final LocalizationConfigEntity? localizationConfig;
  final FlutterSecureStorage? secureStorage;
  final ErrorModelParser errorParser;

  @override
  List<Object?> get props => [
        networkConfig,
        themeConfig,
        localizationConfig,
        secureStorage,
        errorParser,
      ];
}
