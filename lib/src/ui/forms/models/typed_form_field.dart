import 'package:coore/src/utils/validators/composite_validator.dart';
import 'package:coore/src/utils/validators/validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'typed_form_field.freezed.dart';

@freezed
abstract class TypedFormField<T> with _$TypedFormField<T> {
  const factory TypedFormField({
    required String name,
    required List<Validator<T>> validators,
    T? initialValue,
  }) = _TypedFormField<T>;

  const TypedFormField._();

  /// Get the runtime type of the field value
  Type get valueType => T;

  /// Create a validator for this field
  Validator<T> createValidator() => CompositeValidator<T>(validators);
}
