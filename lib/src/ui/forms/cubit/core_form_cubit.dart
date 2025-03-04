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
    this.validationType = ValidationType.allFields,
  }) : super(CoreFormState.initial().copyWith(validationType: validationType)) {
    _validators = {};
    validators.forEach((key, value) {
      _validators.putIfAbsent(key, () => CompositeValidator(value));
    });
  }
  late final Map<String, CompositeValidator> _validators;
  final ValidationType validationType;
  void updateField(String fieldName, dynamic value) {
    final newValues = Map<String, dynamic>.from(state.values)
      ..[fieldName] = value;

    Map<String, String> newErrors;

    switch (validationType) {
      case ValidationType.onSubmit:
        // Do not validate on field update; validation will occur on submit.
        newErrors = state.errors;
        break;
      case ValidationType.allFields:
        // Validate all fields whenever any field is updated.
        newErrors = _validateFields(newValues);
        break;
      case ValidationType.fieldsBeingEdited:
        // Validate only the field currently being edited.
        newErrors = Map<String, String>.from(state.errors);
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

    emit(
      state.copyWith(
        values: newValues,
        errors: newErrors,
        isValid: newErrors.isEmpty,
      ),
    );
  }

  dynamic getValueByName(String name) => state.values[name];
  Map<String, String> _validateFields(Map<String, dynamic> values) {
    if (validationType == ValidationType.disabled) {
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
    if (validationType == ValidationType.onSubmit) {
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

  /// whenever the user start typing the validation is triggered for all fields that the cubit wraps
  allFields,

  /// whenever the user start typing the validation is triggered for the field being edited only
  fieldsBeingEdited,

  /// the validation is disabled
  disabled,
}
