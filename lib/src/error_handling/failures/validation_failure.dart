import 'package:coore/coore.dart';

/// Data integrity/validation issues (Local or Server-side).
/// Holds a map of field-specific errors for form highlighting.
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed',
    this.errors = const {},
    super.code = 'VALIDATION_ERR',
    super.stackTrace,
    super.originalException,
  });

  /// Key = Field Name (e.g., 'email', 'password').
  /// Value = Specific error message (e.g., 'Too short').
  final Map<String, String> errors;

  /// Helper to get the first error message (useful for Snackbars).
  String get firstError => errors.entries.firstOrNull?.value ?? message;

  /// Helper to safely look up an error for a specific field.
  String? getErrorFor(String fieldName) => errors[fieldName];

  @override
  List<Object?> get props => [...super.props, errors];
}
