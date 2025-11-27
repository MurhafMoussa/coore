import 'package:coore/coore.dart';

/// Something we didn't plan for (NullPointer, RangeError, etc).
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code = 'UNKNOWN',
    super.stackTrace,
    super.originalException,
  });
}
