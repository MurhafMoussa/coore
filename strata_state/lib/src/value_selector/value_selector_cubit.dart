import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'value_selector_state.dart';

/// Abstract base class for managing the selection of values.
abstract class ValueSelectorCubit<T> extends Cubit<ValueSelectorState<T>> {
  ValueSelectorCubit({
    required this.values,
    required this.valueSetter,
    required this.enableUnselect,
    List<T>? defaultSelectedValues,
  }) : super(ValueSelectorState(defaultSelectedValues ?? []));

  final List<T> values;
  final ValueSetter<List<T>> valueSetter;
  final bool enableUnselect;

  void toggleSelection(T value);

  bool isValueSelected(T item) => state.selectedValues.contains(item);

  bool get selectedValuesIsEmpty => state.selectedValues.isEmpty;

  void updateAvailableValues(
    List<T> newValues, {
    List<T> defaultSelectedValues = const [],
  }) {
    values
      ..clear()
      ..addAll(newValues);

    emit(ValueSelectorState(defaultSelectedValues));
    valueSetter(defaultSelectedValues);
  }
}
