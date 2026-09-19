import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:strata_navigation/strata_navigation.dart';
import 'package:strata_network/strata_network.dart';

/// Configuration entity for initializing the Strata framework.
class StrataConfigEntity extends Equatable {
  const StrataConfigEntity({
    this.networkConfig,
    this.navigationConfig,
    this.secureStorage,
    this.errorParser,
    this.customDio,
    this.onUnauthenticated,
    this.shouldLogNavigation = false,
  });

  /// Network configuration settings for `strata_network`.
  final NetworkConfigEntity? networkConfig;

  /// Navigation configuration settings for `strata_navigation`.
  final NavigationConfigEntity? navigationConfig;

  /// Custom secure storage instance for `strata_storage`.
  final FlutterSecureStorage? secureStorage;

  /// Custom error parser for network responses.
  final ErrorModelParser? errorParser;

  /// Custom Dio instance.
  final Dio? customDio;

  /// Callback executed when an unauthenticated response occurs.
  final void Function()? onUnauthenticated;

  /// Flag indicating whether navigation logging should be enabled.
  final bool shouldLogNavigation;

  @override
  List<Object?> get props => [
        networkConfig,
        navigationConfig,
        secureStorage,
        errorParser,
        customDio,
        onUnauthenticated,
        shouldLogNavigation,
      ];
}
