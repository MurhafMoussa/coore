import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:equatable/equatable.dart';

abstract class BaseEntity extends Equatable {
  const BaseEntity({required this.id});

  final Id id;

  @override
  List<Object?> get props => [id];
}
