import 'package:coore/src/config/entities/network_config_entity.dart';
import 'package:coore/src/environment/environment_config.dart';
import 'package:equatable/equatable.dart';

class CoreConfigEntity extends Equatable {
  final Environment currentEnvironment;
  final NetworkConfigEntity networkConfigEntity;

  const CoreConfigEntity({
    required this.currentEnvironment,
    required this.networkConfigEntity,
  });

  @override
  List<Object> get props => [currentEnvironment];
}
