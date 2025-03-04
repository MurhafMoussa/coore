part of 'core_form_cubit.dart';

@freezed
abstract class CoreFormState with _$CoreFormState {
  const factory CoreFormState({
    required Map<String, dynamic> values,
    required Map<String, String> errors,
    required bool isValid,
    @Default(ValidationType.fieldsBeingEdited) ValidationType validationType,
  }) = _CoreFormState;
  factory CoreFormState.initial() =>
      const CoreFormState(values: {}, errors: {}, isValid: false);
}
