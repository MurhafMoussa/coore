import 'value_selector_cubit.dart';
import 'value_selector_state.dart';

/// A Cubit that manages multi-selection of values.
class MultiSelectorCubit<T>({
  required super.values,
  required super.valueSetter,
  super.enableUnselect = true,
  super.defaultSelectedValues,
}) extends ValueSelectorCubit<T> {

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
