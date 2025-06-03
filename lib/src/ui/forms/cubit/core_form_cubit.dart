import 'package:coore/src/ui/forms/models/typed_form_field.dart';
import 'package:coore/src/utils/validators/validator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_form_cubit.freezed.dart';
part 'core_form_state.dart';

/// Form cubit with type-safe state access
class CoreFormCubit extends Cubit<CoreFormState> {
  CoreFormCubit({
    List<TypedFormField> fields = const [],
    ValidationType validationType = ValidationType.allFields,
  }) : super(CoreFormState.initial()) {
    _validators = {};
    _touchedFields = {};
    final values = <String, Object?>{};
    final fieldTypes = <String, Type>{};

    // Initialize validators, field types, and mark fields as untouched
    for (final field in fields) {
      values[field.name] = field.initialValue;
      _validators[field.name] = field.createValidator();
      _touchedFields[field.name] = false;
      fieldTypes[field.name] = field.valueType;
    }

    // Single emit call with all initial values
    emit(
      CoreFormState(
        values: values,
        errors: {},
        isValid: false,
        validationType: validationType,
        fieldTypes: fieldTypes,
      ),
    );
  }

  late final Map<String, Validator> _validators;
  late final Map<String, bool> _touchedFields;

  /// Type-safe getter for field values
  T? getValue<T>(String fieldName) => state.getValue<T>(fieldName);

  /// Type-safe update method for a single field
  void updateField<T>(String fieldName, T? value, BuildContext context) {
    // Type check
    final expectedType = state.fieldTypes[fieldName];
    if (expectedType != null && expectedType != T) {
      throw TypeError();
    }

    final newValues = Map<String, Object?>.from(state.values)
      ..[fieldName] = value;

    // Mark this field as touched
    _touchedFields[fieldName] = true;

    Map<String, String> newErrors = Map<String, String>.from(state.errors);

    // Update errors based on the active validation strategy
    switch (state.validationType) {
      case ValidationType.onSubmit:
        // In onSubmit mode, we don't update errors on field change
        newErrors = state.errors;
        break;
      case ValidationType.allFields:
        // Validate all fields when any field is updated
        newErrors = _validateFields(newValues, context);
        break;
      case ValidationType.fieldsBeingEdited:
        // Validate only the field being edited
        final validator = _validators[fieldName];
        if (validator != null) {
          final error = _validateField(validator, value, context);
          if (error != null) {
            newErrors[fieldName] = error;
          } else {
            newErrors.remove(fieldName);
          }
        }
        break;
      case ValidationType.disabled:
        newErrors = {};
        break;
    }

    // Compute overall validity
    final overallValid = _computeOverallValidity(newValues, context);

    emit(
      state.copyWith(
        values: newValues,
        errors: newErrors,
        isValid: overallValid,
      ),
    );
  }

  /// Validates a single field with its validator
  String? _validateField<T>(
    Validator validator,
    T? value,
    BuildContext context,
  ) {
    return validator.validate(value, context);
  }

  /// Validates all fields based on the provided values map and returns a map of errors
  Map<String, String> _validateFields(
    Map<String, Object?> values,
    BuildContext context,
  ) {
    if (state.validationType == ValidationType.disabled) {
      return {};
    }

    final errors = <String, String>{};

    _validators.forEach((fieldName, validator) {
      final value = values[fieldName];
      final error = validator.validate(value, context);
      if (error != null) {
        errors[fieldName] = error;
      }
    });

    return errors;
  }

  /// Computes the overall form validity
  bool _computeOverallValidity(
    Map<String, Object?> values,
    BuildContext context,
  ) {
    for (final field in state.values.keys) {
      // If the field hasn't been touched yet, the form is not valid
      if (_touchedFields[field] != true) return false;

      // If the field fails its validation, the form is not valid
      final validator = _validators[field];
      if (validator != null) {
        final value = values[field];
        if (validator.validate(value, context) != null) {
          return false;
        }
      }
    }
    return true;
  }

  /// Sets a new validation type for the form
  void setValidationType(ValidationType validationType) =>
      emit(state.copyWith(validationType: validationType));

  /// Validates the entire form
  void validateForm(
    BuildContext context, {
    required VoidCallback onValidationPass,
    VoidCallback? onValidationFail,
  }) {
    if (state.validationType == ValidationType.onSubmit) {
      final newErrors = _validateFields(state.values, context);
      emit(state.copyWith(errors: newErrors, isValid: newErrors.isEmpty));
    }

    if (state.isValid) {
      onValidationPass();
    } else {
      onValidationFail?.call();
      setValidationType(ValidationType.fieldsBeingEdited);
    }
  }

  /// Updates multiple fields at once with a single state emission
  void updateFields<T>(Map<String, T?> fieldValues, BuildContext context) {
    final newValues = Map<String, Object?>.from(state.values);
    final newErrors = Map<String, String>.from(state.errors);

    // Type check and mark fields as touched
    for (final entry in fieldValues.entries) {
      final fieldName = entry.key;
      final value = entry.value;

      // Type check
      final expectedType = state.fieldTypes[fieldName];
      if (expectedType != null && expectedType != T) {
        throw TypeError();
      }

      // Update value and mark as touched
      newValues[fieldName] = value;
      _touchedFields[fieldName] = true;
    }

    // Update errors based on validation strategy
    switch (state.validationType) {
      case ValidationType.onSubmit:
        // No validation on field change
        break;
      case ValidationType.allFields:
        // Validate all fields
        newErrors.clear();
        newErrors.addAll(_validateFields(newValues, context));
        break;
      case ValidationType.fieldsBeingEdited:
        // Validate only edited fields
        for (final fieldName in fieldValues.keys) {
          final validator = _validators[fieldName];
          if (validator != null) {
            final value = newValues[fieldName];
            final error = validator.validate(value, context);
            if (error != null) {
              newErrors[fieldName] = error;
            } else {
              newErrors.remove(fieldName);
            }
          }
        }
        break;
      case ValidationType.disabled:
        newErrors.clear();
        break;
    }

    emit(
      state.copyWith(
        values: newValues,
        errors: newErrors,
        isValid: _computeOverallValidity(newValues, context),
      ),
    );
  }

  /// Resets the form to its initial state
  void resetForm() {
    final initialValues = <String, Object?>{};

    // Reset all fields to their initial values
    for (final fieldName in _validators.keys) {
      initialValues[fieldName] = null;
      _touchedFields[fieldName] = false;
    }

    emit(state.copyWith(values: initialValues, errors: {}, isValid: false));
  }

  /// Marks all fields as touched and validates them
  void touchAllFields(BuildContext context) {
    // Mark all fields as touched
    for (final field in _touchedFields.keys) {
      _touchedFields[field] = true;
    }

    // Validate all fields
    final newErrors = _validateFields(state.values, context);

    // Update state
    emit(
      state.copyWith(
        errors: newErrors,
        isValid: _computeOverallValidity(state.values, context),
      ),
    );
  }

  /// Manually set an error for a specific field
  ///
  /// This allows setting custom validation errors from outside the normal validation flow.
  /// Useful for server-side validation errors or custom validation logic.
  ///
  /// Parameters:
  /// - [fieldName]: The name of the field to set the error for
  /// - [errorMessage]: The error message to display. If null, any existing error is cleared.
  void updateError(
    String fieldName,
    String? errorMessage,
    BuildContext context,
  ) {
    // Ensure the field exists
    if (!state.values.containsKey(fieldName)) {
      throw ArgumentError('Field "$fieldName" does not exist in the form');
    }

    final newErrors = Map<String, String>.from(state.errors);

    if (errorMessage != null) {
      newErrors[fieldName] = errorMessage;
    } else {
      newErrors.remove(fieldName);
    }

    // Mark field as touched since we're manually validating it
    _touchedFields[fieldName] = true;

    // Compute overall validity based on current values and new errors
    final overallValid = _computeOverallValidityWithErrors(
      state.values,
      newErrors,
      _touchedFields,
      context,
    );

    emit(state.copyWith(errors: newErrors, isValid: overallValid));
  }

  /// Manually set multiple errors at once
  ///
  /// This allows setting custom validation errors for multiple fields.
  /// Useful for handling server-side validation responses.
  ///
  /// Parameters:
  /// - [errors]: Map of field names to error messages. If a field's error is null, any existing error is cleared.
  void updateErrors(Map<String, String?> errors, BuildContext context) {
    final newErrors = Map<String, String>.from(state.errors);

    // Process each error
    for (final entry in errors.entries) {
      final fieldName = entry.key;
      final errorMessage = entry.value;

      // Ensure the field exists
      if (!state.values.containsKey(fieldName)) {
        throw ArgumentError('Field "$fieldName" does not exist in the form');
      }

      // Mark field as touched since we're manually validating it
      _touchedFields[fieldName] = true;

      if (errorMessage != null) {
        newErrors[fieldName] = errorMessage;
      } else {
        newErrors.remove(fieldName);
      }
    }

    // Compute overall validity based on current values and new errors
    final overallValid = _computeOverallValidityWithErrors(
      state.values,
      newErrors,
      _touchedFields,
      context,
    );
    emit(state.copyWith(errors: newErrors, isValid: overallValid));
  }

  /// Computes the overall form validity with custom errors
  ///
  /// This is a variation of _computeOverallValidity that takes explicit errors
  /// rather than computing them from validators.
  bool _computeOverallValidityWithErrors(
    Map<String, Object?> values,
    Map<String, String> errors,
    Map<String, bool> touchedFields,
    BuildContext context,
  ) {
    // If there are any errors, the form is not valid
    if (errors.isNotEmpty) return false;

    for (final field in values.keys) {
      // If the field hasn't been touched yet, the form is not valid
      if (touchedFields[field] != true) return false;

      // If the field fails its validation, the form is not valid
      final validator = _validators[field];
      if (validator != null) {
        final value = values[field];
        if (validator.validate(value, context) != null) {
          return false;
        }
      }
    }
    return true;
  }
}

/// Enum representing the available form validation strategies
enum ValidationType {
  /// Validation occurs only upon form submission
  onSubmit,

  /// All fields are validated whenever any field is updated
  allFields,

  /// Only the field currently being edited is validated
  fieldsBeingEdited,

  /// Validation is disabled
  disabled,
}
