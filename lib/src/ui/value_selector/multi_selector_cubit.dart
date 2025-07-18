import 'package:coore/src/ui/value_selector/value_selector_cubit.dart';
import 'package:coore/src/ui/value_selector/value_selector_state.dart';

/// A Cubit that manages multi-selection of values.
///
/// This class allows multiple values to be selected at once. It handles the logic
/// for adding or removing values from the selection.
class MultiSelectorCubit<T> extends ValueSelectorCubit<T> {
  /// Creates a [MultiSelectorCubit] instance.
  ///
  /// [values]: The list of values that can be selected.
  /// [valueSetter]: A callback function invoked when the selection changes.
  /// [enableUnselect]: A flag to allow or disallow unselecting a selected value.
  /// [defaultSelectedValues]: The initial values that should be selected.
  MultiSelectorCubit({
    required super.values,
    required super.valueSetter,
    super.enableUnselect = true,
    super.defaultSelectedValues,
  });

  /// Toggles the selection state of a value.
  ///
  /// If the value is already selected, it will be removed if `enableUnselect` is true.
  /// Otherwise, the value is added to the selection.
  ///
  /// [value]: The value to toggle in the selection.
  @override
  void toggleSelection(T value) {
    final currentSelected = List<T>.from(state.selectedValues);
    if (currentSelected.contains(value)) {
      if (enableUnselect) {
        currentSelected.remove(value);
      }
    } else {
      currentSelected.add(value);
    }
    emit(ValueSelectorState(currentSelected));
    valueSetter.call(currentSelected);
  }
}
