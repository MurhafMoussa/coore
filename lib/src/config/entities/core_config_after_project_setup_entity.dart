import 'package:coore/src/src.dart';
import 'package:equatable/equatable.dart';

class CoreConfigAfterProjectSetupEntity extends Equatable {
  const CoreConfigAfterProjectSetupEntity({
    required this.navigationConfigEntity,
    required this.shouldLog,
  });

  final NavigationConfigEntity navigationConfigEntity;
  final bool shouldLog;

  @override
  List<Object> get props => [navigationConfigEntity];
}
