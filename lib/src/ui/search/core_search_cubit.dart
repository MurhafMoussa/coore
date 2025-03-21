import 'dart:async';

import 'package:coore/lib.dart';
import 'package:coore/src/api_handler/params/search_params.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_search_cubit.freezed.dart';
part 'core_search_state.dart';

class CoreSearchCubit<T> extends CoreCubit<CoreSearchState<T>, List<T>> {
  CoreSearchCubit(
    this.searchFunction,
    this.searchParams, {
    this.debounceDuration = const Duration(seconds: 1),
  }) : super(CoreSearchState.initial()) {
    // Add a listener to handle text changes in the search field.
    searchController.addListener(() {
      _onQueryChanged(searchParams.copyWith(query: searchController.text));
    });
  }
  final RepositoryFutureResponse<List<T>> Function(SearchParams) searchFunction;
  Timer? _debounceTimer;
  final searchController = SearchController();
  final Duration debounceDuration;
  final SearchParams searchParams;
  void _cancelTimer() {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }
  }

  Future<void> _onQueryChanged(SearchParams params) async {
    _cancelTimer();

    _debounceTimer = Timer(debounceDuration, () async {
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
    searchController.dispose();
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
