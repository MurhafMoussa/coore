import 'package:coore/src/utils/validators/composit_validator.dart';
import 'package:coore/src/utils/validators/validator.dart';
import 'package:coore/src/utils/value_tester.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_form_cubit.freezed.dart';
part 'core_form_state.dart';

/// A Cubit that manages the state of a form including field values, validation errors,
/// and overall validity. It supports various validation strategies defined in
/// [ValidationType] and tracks which fields have been "touched" (edited) by the user.
///
/// Validation Strategies:
/// - [ValidationType.onSubmit]: Validation occurs only when the form is submitted.
/// - [ValidationType.allFields]: All fields are validated whenever any field is updated.
/// - [ValidationType.fieldsBeingEdited]: Only the currently edited field is validated.
/// - [ValidationType.disabled]: No validation is performed.
///
/// The overall form is considered valid only when every field has been touched and passes its validation.
class CoreFormCubit extends Cubit<CoreFormState> {
  /// Creates a [CoreFormCubit] with the given [validators] and [validationType].
  ///
  /// [validators] is a map where each key represents a field name and the associated
  /// list of [Validator]s is used to create a [CompositeValidator] for that field.
  /// All fields are initialized with a `null` value and marked as untouched.
  CoreFormCubit({
    Map<String, List<Validator>> validators = const {},
    ValidationType validationType = ValidationType.allFields,
  }) : super(CoreFormState.initial().copyWith(validationType: validationType)) {
    _validators = {};
    _touchedFields = {};
    final values = <String, dynamic>{};
    // Initialize validators and mark fields as untouched.
    validators.forEach((key, value) {
      values.putIfAbsent(key, () => null);
      _validators[key] = CompositeValidator(value);
      _touchedFields[key] = false;
    });
    emit(state.copyWith(values: values));
  }

  late final Map<String, CompositeValidator> _validators;
  late final Map<String, bool> _touchedFields;

  /// Updates the value for a specific field identified by [fieldName] and revalidates
  /// based on the current [ValidationType]. Also marks the field as touched.
  void updateField(String fieldName, dynamic value) {
    final newValues = Map<String, dynamic>.from(state.values)
      ..[fieldName] = value;

    // Mark this field as touched.
    _touchedFields[fieldName] = true;

    Map<String, String> newErrors = Map<String, String>.from(state.errors);

    // Update errors based on the active validation strategy.
    switch (state.validationType) {
      case ValidationType.onSubmit:
        // In onSubmit mode, we don't update errors on field change.
        newErrors = state.errors;
        break;
      case ValidationType.allFields:
        // Validate all fields when any field is updated.
        newErrors = _validateFields(newValues);
        break;
      case ValidationType.fieldsBeingEdited:
        // Validate only the field being edited.
        final error = _validators[fieldName]?.validate(value);
        if (error != null) {
          newErrors[fieldName] = error;
        } else {
          newErrors.remove(fieldName);
        }
        break;
      case ValidationType.disabled:
        newErrors = {};
        break;
    }

    // Compute overall validity:
    // The form is valid only if every field has been touched and passes its validation.
    final overallValid = _computeOverallValidity(newValues);

    emit(
      state.copyWith(
        values: newValues,
        errors: newErrors,
        isValid: overallValid,
      ),
    );
  }

  /// Returns the value associated with the field [name].
  dynamic getValueByName(String name) => state.values[name];

  /// Validates all fields based on the provided [values] map and returns a map of errors.
  /// If validation is disabled, an empty map is returned.
  Map<String, String> _validateFields(Map<String, dynamic> values) {
    if (state.validationType == ValidationType.disabled) {
      return {};
    }
    final errors = <String, String>{};

    _validators.forEach((fieldName, validator) {
      final error = validator.validate(values[fieldName]);
      if (error != null) {
        errors[fieldName] = error;
      }
    });

    return errors;
  }

  /// Computes the overall form validity using [newValues] by ensuring:
  ///  - Every field has been touched.
  ///  - Every touched field passes its validation.
  bool _computeOverallValidity(Map<String, dynamic> newValues) {
    for (final field in state.values.keys) {
      // If the field hasn't been touched yet, the form is not valid.
      if (_touchedFields[field] != true) return false;
      // If the field fails its validation, the form is not valid.
      if (_validators[field]?.validate(newValues[field]) != null) return false;
    }
    return true;
  }

  /// Sets a new [validationType] for the form and updates the state.
  void setValidationType(ValidationType validationType) =>
      emit(state.copyWith(validationType: validationType));

  /// Validates the entire form. In [ValidationType.onSubmit] mode, all fields are validated.
  ///
  /// If the form is valid, [onValidationPass] is invoked.
  /// Otherwise, [onValidationFail] is invoked (if provided) and the validation strategy
  /// is switched to [ValidationType.fieldsBeingEdited] to provide immediate feedback.
  void validateForm({
    required VoidCallback onValidationPass,
    VoidCallback? onValidationFail,
  }) {
    if (state.validationType == ValidationType.onSubmit) {
      final newErrors = _validateFields(state.values);
      emit(state.copyWith(errors: newErrors, isValid: newErrors.isEmpty));
    }

    if (state.isValid) {
      onValidationPass();
    } else {
      onValidationFail?.call();
      setValidationType(ValidationType.fieldsBeingEdited);
    }
  }
}

/// Enum representing the available form validation strategies.
enum ValidationType {
  /// Validation occurs only upon form submission.
  onSubmit,

  /// All fields are validated whenever any field is updated.
  allFields,

  /// Only the field currently being edited is validated.
  fieldsBeingEdited,

  /// Validation is disabled.
  disabled,
}
