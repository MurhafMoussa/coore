import 'package:coore/src/config/entities/localization_config_entity.dart';
import 'package:coore/src/config/entities/network_config_entity.dart';
import 'package:coore/src/environment/environment_config.dart';
import 'package:equatable/equatable.dart';

class CoreConfigEntity extends Equatable {
  final Environment currentEnvironment;
  final NetworkConfigEntity networkConfigEntity;
  final LocalizationConfigEntity localizationConfigEntity;

  const CoreConfigEntity(
    this.currentEnvironment,
    this.networkConfigEntity,
    this.localizationConfigEntity,
  );

  @override
  List<Object> get props => [
    currentEnvironment,
    networkConfigEntity,
    localizationConfigEntity,
  ];
}
