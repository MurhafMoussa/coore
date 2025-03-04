import 'package:coore/src/extensions/object_extensions.dart';
import 'package:coore/src/utils/validators/composit_validator.dart';
import 'package:coore/src/utils/validators/validator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_form_cubit.freezed.dart';
part 'core_form_state.dart';

class CoreFormCubit extends Cubit<CoreFormState> {
  CoreFormCubit({Map<String, List<Validator>> validators = const {}})
    : super(CoreFormState.initial()) {
    _validators = {};
    validators.forEach((key, value) {
      _validators.putIfAbsent(key, () => CompositeValidator(value));
    });
  }
  late final Map<String, CompositeValidator> _validators;

  void updateField(String fieldName, dynamic value) {
    if (value.isNull) return;
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

    _validators.forEach((fieldName, validator) {
      final error = validator.validate(values[fieldName]);
      if (error != null) {
        errors[fieldName] = error;
      }
    });

    return errors;
  }
}
