import 'package:coore/src/api_handler/entities/base_entity.dart';
import 'package:coore/src/ui/value_selector/value_selector_cubit.dart';
import 'package:coore/src/ui/value_selector/value_selector_state.dart';

/// A Cubit that manages single-selection of values.
///
/// This class allows only one value to be selected at a time. It handles the logic
/// for selecting and unselecting a single value.
class SingleSelectorCubit<T extends BaseEntity> extends ValueSelectorCubit<T> {
  /// Creates a [SingleSelectorCubit] instance.
  ///
  /// [values]: The list of values that can be selected.
  /// [valueSetter]: A callback function invoked when the selection changes.
  /// [enableUnselect]: A flag to allow or disallow unselecting a selected value.
  /// [defaultSelectedValues]: The initial value that should be selected.
  SingleSelectorCubit({
    required super.values,
    required super.valueSetter,
    super.enableUnselect = true,
    super.defaultSelectedValues,
  });

  /// Toggles the selection state of a value.
  ///
  /// If the value is already selected, it will be removed if `enableUnselect` is true.
  /// Otherwise, the value is set as the only selected value.
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
      currentSelected
        ..clear()
        ..add(value);
    }
    emit(ValueSelectorState(currentSelected));
    valueSetter.call(currentSelected);
  }
}
