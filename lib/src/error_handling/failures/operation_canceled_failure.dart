import 'package:coore/coore.dart';

/// User explicitly cancelled an operation (e.g. biometric prompt, file picker).
class OperationCancelledFailure extends Failure {
  const OperationCancelledFailure({super.message = 'Operation cancelled'})
    : super(code: 'CANCELLED');
}
