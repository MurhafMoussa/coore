import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  const Failure(this.message, {this.stackTrace});
  final String message;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, stackTrace];
}

class UnknownFailure extends Failure {
  const UnknownFailure({StackTrace? stackTrace})
    : super('Unknown failure', stackTrace: stackTrace);
}
