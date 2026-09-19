import 'package:get_it/get_it.dart';
import 'package:strata_core/strata_core.dart';
import 'disposable_api_state_handler_interface.dart';

/// A delegate class that manages the complete lifecycle of a single API call.
///
/// Encapsulates loading, success, failure, retry, and request tracking
/// for a specific [ApiState] field within a composite state.
class ApiStateHandler<CompositeState, SuccessData>
    implements DisposableApiStateHandlerInterface {
  /// Creates a new [ApiStateHandler].
  ApiStateHandler({
    required this._emit,
    required this._getState,
    required this._isClosed,
    required this._getApiState,
    required this._setApiState,
    this._logger,
    this._onCancelRequest,
  });

  final void Function(CompositeState) _emit;
  final CompositeState Function() _getState;
  final bool Function() _isClosed;
  final ApiState<SuccessData> Function(CompositeState) _getApiState;
  final CompositeState Function(CompositeState, ApiState<SuccessData>)
      _setApiState;
  final CoreLoggerInterface? _logger;
  final void Function(String requestId)? _onCancelRequest;

  String? _currentRequestId;

  /// Returns the active request ID if any request is currently tracked.
  String? get currentRequestId => _currentRequestId;

  /// Cancels the ongoing API request if tracked.
  void cancelRequest() {
    if (_currentRequestId != null) {
      _onCancelRequest?.call(_currentRequestId!);
      _currentRequestId = null;
    }
  }

  /// Executes the API call and manages its full state lifecycle.
  ///
  /// - When [force] is false (default) and current state is loading, logs a
  ///   diagnostic warning via [CoreLoggerInterface] and skips execution.
  /// - When [force] is true, executes the API call immediately even if loading.
  Future<void> handleApiCall<T>({
    required ResultFuture<SuccessData> Function(T params) apiCall,
    required T params,
    void Function(SuccessData data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? requestId,
    bool force = false,
  }) async {
    final currentState = _getState();
    final currentApiState = _getApiState(currentState);

    if (currentApiState.isLoading && !force) {
      _logWarning(
        'ApiStateHandler: handleApiCall skipped because state is already loading. '
        'Pass force: true to execute during loading state.',
      );
      return;
    }

    _emit(_setApiState(currentState, ApiState<SuccessData>.loading()));

    if (requestId != null) {
      _currentRequestId = requestId;
    }

    try {
      final result = await apiCall(params);

      if (!_isClosed()) {
        final latestState = _getState();

        result.fold(
          (failure) {
            _emit(
              _setApiState(
                latestState,
                ApiState<SuccessData>.failure(
                  failure,
                  retryFunction: () => handleApiCall(
                    apiCall: apiCall,
                    params: params,
                    onSuccess: onSuccess,
                    onFailure: onFailure,
                    requestId: requestId,
                    force: force,
                  ),
                ),
              ),
            );
            onFailure?.call(failure);
          },
          (success) {
            _emit(
              _setApiState(
                latestState,
                ApiState<SuccessData>.success(success),
              ),
            );
            onSuccess?.call(success);
          },
        );
      }
    } finally {
      if (_currentRequestId == requestId) {
        _currentRequestId = null;
      }
    }
  }

  void _logWarning(String message) {
    if (_logger != null) {
      _logger!.warning(message);
    } else if (GetIt.I.isRegistered<CoreLoggerInterface>()) {
      GetIt.I<CoreLoggerInterface>().warning(message);
    }
  }

  @override
  void dispose() {
    cancelRequest();
  }
}
