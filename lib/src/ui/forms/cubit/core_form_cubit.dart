import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_form_cubit.freezed.dart';
part 'core_form_state.dart';

class CoreFormCubit extends Cubit<CoreFormState> {
  CoreFormCubit({this.validators = const {}}) : super(CoreFormState.initial());
  final Map<String, List<FormFieldValidator>> validators;

  void updateField(String fieldName, dynamic value) {
    final newValues = Map<String, dynamic>.from(state.values)
      ..[fieldName] = value;
    final newErrors = _validateFields(newValues);

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
    final errors = <String, String>{};

    validators.forEach((fieldName, validators) {
      for (final validator in validators) {
        final error = validator(values[fieldName]);
        if (error != null) {
          errors[fieldName] = error;
          break;
        }
      }
    });

    return errors;
  }
}
