import 'package:equatable/equatable.dart';

class ValueSelectorState<T> extends Equatable {
  const ValueSelectorState(this.selectedValues);
  final List<T> selectedValues;

  @override
  List<Object?> get props => [selectedValues];
}
