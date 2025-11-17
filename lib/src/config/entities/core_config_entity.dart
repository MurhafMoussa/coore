import 'package:coore/lib.dart';
import 'package:coore/src/config/entities/error_config_entity.dart';
import 'package:coore/src/config/entities/localization_config_entity.dart';
import 'package:coore/src/config/entities/network_config_entity.dart';
import 'package:coore/src/config/entities/theme_config_entity.dart';
import 'package:coore/src/environment/environment_config.dart';
import 'package:equatable/equatable.dart';

class CoreConfigEntity extends Equatable {
  const CoreConfigEntity({
    required this.currentEnvironment,
    required this.networkConfigEntity,
    required this.localizationConfigEntity,
    this.shouldLog = true,
    required this.themeConfigEntity,
    this.enableSecureStorage = false,
    required this.errorConfigEntity,
  });
  final CoreEnvironment currentEnvironment;
  final NetworkConfigEntity networkConfigEntity;
  final LocalizationConfigEntity localizationConfigEntity;
  final ErrorConfigEntity errorConfigEntity;
  final ThemeConfigEntity themeConfigEntity;
  final bool shouldLog;
  final bool enableSecureStorage;
  @override
  List<Object> get props => [
    currentEnvironment,
    networkConfigEntity,
    localizationConfigEntity,
  ];
}
