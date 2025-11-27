import 'package:coore/coore.dart';

/// Data parsing issues (e.g., Malformed JSON, Type Mismatch).
class FormatFailure extends Failure {
  const FormatFailure({
    super.message = 'Data format error',
    super.code = 'FORMAT_ERR',
    super.stackTrace,
    super.originalException,
  });
}
