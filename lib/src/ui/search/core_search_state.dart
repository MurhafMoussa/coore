part of 'core_search_cubit.dart';

@freezed
abstract class CoreSearchState<T> with _$CoreSearchState {
  const factory CoreSearchState({required ApiState<List<T>> apiState}) =
      _CoreSearchState;
  factory CoreSearchState.initial() =>
      CoreSearchState(apiState: const ApiState.initial());
}
