import 'package:equatable/equatable.dart';

class const ValueSelectorState<T>(final List<T> selectedValues)
    extends Equatable {
  @override
  List<Object?> get props => [selectedValues];
}
