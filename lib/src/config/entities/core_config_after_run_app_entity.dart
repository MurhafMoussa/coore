// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:coore/src/src.dart';
import 'package:equatable/equatable.dart';

class CoreConfigAfterRunAppEntity extends Equatable {
  const CoreConfigAfterRunAppEntity({required this.navigationConfigEntity});

  final NavigationConfigEntity navigationConfigEntity;

  @override
  List<Object> get props => [navigationConfigEntity];
}
