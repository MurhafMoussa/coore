import 'package:flutter_test/flutter_test.dart';
import 'package:strata_state/strata_state.dart';

void main() {
  group('SingleSelectorCubit', () {
    test('selects single item and toggles unselect if allowed', () {
      List<String> selectedResult = [];
      final cubit = SingleSelectorCubit<String>(
        values: ['A', 'B', 'C'],
        valueSetter: (vals) => selectedResult = vals,
        enableUnselect: true,
      );

      expect(cubit.selectedValuesIsEmpty, isTrue);

      cubit.toggleSelection('A');
      expect(cubit.isValueSelected('A'), isTrue);
      expect(selectedResult, equals(['A']));

      cubit.toggleSelection('B');
      expect(cubit.isValueSelected('B'), isTrue);
      expect(cubit.isValueSelected('A'), isFalse);
      expect(selectedResult, equals(['B']));

      cubit.toggleSelection('B');
      expect(cubit.selectedValuesIsEmpty, isTrue);
      expect(selectedResult, isEmpty);
    });
  });

  group('MultiSelectorCubit', () {
    test('selects multiple items and allows toggling', () {
      List<String> selectedResult = [];
      final cubit = MultiSelectorCubit<String>(
        values: ['A', 'B', 'C'],
        valueSetter: (vals) => selectedResult = vals,
        enableUnselect: true,
      );

      cubit.toggleSelection('A');
      cubit.toggleSelection('B');

      expect(cubit.isValueSelected('A'), isTrue);
      expect(cubit.isValueSelected('B'), isTrue);
      expect(selectedResult, equals(['A', 'B']));

      cubit.toggleSelection('A');
      expect(cubit.isValueSelected('A'), isFalse);
      expect(cubit.isValueSelected('B'), isTrue);
      expect(selectedResult, equals(['B']));
    });
  });
}
