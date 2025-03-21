import 'dart:async';

import 'package:coore/lib.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_search_cubit.freezed.dart';
part 'core_search_state.dart';

class CoreSearchCubit<T> extends CoreCubit<CoreSearchState<T>, List<T>> {
  CoreSearchCubit(this.searchFunction) : super(CoreSearchState.initial());
  final RepositoryFutureResponse<List<T>> Function(SearchParams) searchFunction;
  Timer? _debounceTimer;

  void _cancelTimer() {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }
  }

  Future<void> onQueryChanged(SearchParams params) async {
    _cancelTimer();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      handleApiCall(apiCall: searchFunction.call, params: params);
    });
  }

  void clearSearch() {
    _cancelTimer();
    emit(CoreSearchState.initial());
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }

  @override
  ApiState<List<T>> getApiState(CoreSearchState<T> state) => state.apiState;

  @override
  CoreSearchState<T> setApiState(
    CoreSearchState<T> state,
    ApiState<List<T>> apiState,
  ) => state.copyWith(apiState: apiState);
}

class SearchParams extends BaseParams {
  const SearchParams({super.cancelTokenAdapter, required this.query});

  final String query;
  @override
  BaseParams attachCancelToken({CancelRequestAdapter? cancelTokenAdapter}) =>
      SearchParams(
        query: query,
        cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,
      );
  @override
  List<Object?> get props => [query];

  @override
  Map<String, dynamic> toJson() => {'query': query};
}
