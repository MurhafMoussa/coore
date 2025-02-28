import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  List<Object?> get props => [message, stackTrace];
}

class UnknownFailure extends Failure {
  const UnknownFailure([StackTrace? stackTrace])
    : super('Unknown failure', stackTrace);
}
