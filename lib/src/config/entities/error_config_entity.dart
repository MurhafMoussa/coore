import 'package:coore/lib.dart';
import 'package:equatable/equatable.dart';

class ErrorConfigEntity extends Equatable {
  const ErrorConfigEntity({
    required this.errorModelParser,
  });
  final ErrorModelParser errorModelParser;
  @override
  List<Object?> get props => [errorModelParser];
}