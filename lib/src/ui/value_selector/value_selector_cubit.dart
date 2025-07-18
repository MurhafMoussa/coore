import 'package:coore/src/ui/value_selector/value_selector_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Abstract base class for managing the selection of values.
///
/// This class provides common functionality for both single and multi-selection
/// scenarios. It manages the selection state and provides methods to query and
/// modify the selection.
abstract class ValueSelectorCubit<T> extends Cubit<ValueSelectorState<T>> {
  /// Creates a [ValueSelectorCubit] instance.
  ///
  /// [values]: The list of values that can be selected.
  /// [valueSetter]: A callback function invoked when the selection changes.
  /// [enableUnselect]: A flag to allow or disallow unselecting a selected value.
  /// [defaultSelectedValues]: The initial values that should be selected.
  ValueSelectorCubit({
    required this.values,
    required this.valueSetter,
    required this.enableUnselect,
    List<T>? defaultSelectedValues,
  }) : super(ValueSelectorState(defaultSelectedValues ?? []));

  /// List of all available values that can be selected.
  final List<T> values;

  /// Callback function that gets called whenever the selected values are updated.
  final ValueSetter<List<T>> valueSetter;

  /// Determines whether unselecting a selected value is allowed.
  final bool enableUnselect;

  /// Toggles the selection state of a value.
  ///
  /// Must be implemented by subclasses to define specific selection behavior.
  void toggleSelection(T value);

  /// Checks if a specific value is currently selected.
  ///
  /// [item]: The value to check.
  /// Returns `true` if the value is selected, `false` otherwise.
  bool isValueSelected(T item) => state.selectedValues.contains(item);

  /// Returns `true` if no values are selected, `false` otherwise.
  bool get selectedValuesIsEmpty => state.selectedValues.isEmpty;

  /// Updates the available values for selection.
  ///
  /// [newValues] is the new list of values that can be selected.
  /// This method replaces the current available values with [newValues] and
  /// the [defaultSelectedValues] provided will be used as the new selection.
  ///
  /// If [defaultSelectedValues] is not passed and the current selection is empty,
  /// then no values will be selected.
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
