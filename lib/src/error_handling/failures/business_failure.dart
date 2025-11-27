import 'package:coore/coore.dart';

/// The request was technically successful (200 OK), but violated a business rule.
/// Example: "Insufficient funds", "Duplicate transaction".
class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.code = 'BIZ_RULE',
    super.stackTrace,
    super.originalException,
  });
}
