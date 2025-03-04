import 'package:coore/src/utils/validators/composit_validator.dart';
import 'package:coore/src/utils/validators/validator.dart';
import 'package:coore/src/utils/value_tester.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_form_cubit.freezed.dart';
part 'core_form_state.dart';

class CoreFormCubit extends Cubit<CoreFormState> {
  CoreFormCubit({
    Map<String, List<Validator>> validators = const {},
    ValidationType validationType = ValidationType.allFields,
  }) : super(CoreFormState.initial().copyWith(validationType: validationType)) {
    _validators = {};
    _touchedFields = {};
    Map<String, dynamic> values = {};
    validators.forEach((key, value) {
      values.putIfAbsent(key, () => null);
      _validators.putIfAbsent(key, () => CompositeValidator(value));
      // Initially, mark each field as untouched.
      _touchedFields[key] = false;
    });
    emit(state.copyWith(values: values));
  }

  late final Map<String, CompositeValidator> _validators;
  late final Map<String, bool> _touchedFields;

  void updateField(String fieldName, dynamic value) {
    final newValues = Map<String, dynamic>.from(state.values)
      ..[fieldName] = value;

    // Mark this field as touched.
    _touchedFields[fieldName] = true;

    Map<String, String> newErrors = Map<String, String>.from(state.errors);

    switch (state.validationType) {
      case ValidationType.onSubmit:
        // Do not validate on field update; validation will occur on submit.
        newErrors = state.errors;
        break;
      case ValidationType.allFields:
        // Validate all fields whenever any field is updated.
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
    // The form is valid only if every field has been touched and passes validation.
    bool overallValid = true;
    for (final field in state.values.keys) {
      // If the field hasn't been touched yet, consider it invalid.
      if (_touchedFields[field] != true) {
        overallValid = false;
        break;
      }
      // If the field was touched but fails validation, consider it invalid.
      if (_validators[field]?.validate(newValues[field]) != null) {
        overallValid = false;
        break;
      }
    }

    emit(
      state.copyWith(
        values: newValues,
        errors: newErrors,
        isValid: overallValid,
      ),
    );
  }

  dynamic getValueByName(String name) => state.values[name];

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

  void setValidationType(ValidationType validationType) =>
      emit(state.copyWith(validationType: validationType));

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

enum ValidationType {
  /// must call validateForm to trigger validation
  onSubmit,

  /// whenever the user starts typing the validation is triggered for all fields
  allFields,

  /// whenever the user starts typing the validation is triggered for the field being edited only
  fieldsBeingEdited,

  /// the validation is disabled
  disabled,
}
