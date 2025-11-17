import 'package:coore/lib.dart';
import 'package:equatable/equatable.dart';

class ErrorConfigEntity extends Equatable {
  const ErrorConfigEntity({
    required this.errorModelParser,
    required this.failureMap,
  });
  final ErrorModelParser errorModelParser;
  final Map<int, FailureBuilder> failureMap;
  @override
  List<Object?> get props => [errorModelParser, failureMap];
}