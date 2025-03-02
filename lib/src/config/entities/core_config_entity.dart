import 'package:coore/src/config/entities/localization_config_entity.dart';
import 'package:coore/src/config/entities/navigation_config_entity.dart';
import 'package:coore/src/config/entities/network_config_entity.dart';
import 'package:coore/src/environment/environment_config.dart';
import 'package:equatable/equatable.dart';

class CoreConfigEntity extends Equatable {
  final Environment currentEnvironment;
  final NetworkConfigEntity networkConfigEntity;
  final LocalizationConfigEntity localizationConfigEntity;
  final NavigationConfigEntity navigationConfigEntity;

  const CoreConfigEntity({
    required this.currentEnvironment,
    required this.networkConfigEntity,
    required this.localizationConfigEntity,
    required this.navigationConfigEntity,
  });

  @override
  List<Object> get props => [
    currentEnvironment,
    networkConfigEntity,
    localizationConfigEntity,
    navigationConfigEntity,
  ];
}
