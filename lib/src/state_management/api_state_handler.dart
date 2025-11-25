import 'package:coore/lib.dart';

/// A simple interface for disposable handlers.
///
/// This allows the [ApiStateHostMixin] to track and dispose of any
/// handler it creates, regardless of its generic types.
abstract class IApiStateHandler {
  /// Cleans up any resources held by the handler, such as
  /// canceling pending requests via [CancelRequestManager].
  void dispose();
}

/// A delegate class that manages the complete lifecycle of a single API call.
///
/// This class is designed to be **composed** within a BLoC/Cubit. It encapsulates
/// all the logic for handling loading, success, failure, retry, and cancellation
/// for a *specific* [ApiState] field within a larger [CompositeState].
///
/// You should almost never create this class directly. Instead, use the
/// [ApiStateHostMixin] on your Cubit to create and manage instances
/// of this handler.
///
/// ### Type Parameters:
/// - [CompositeState]: The full state object of the BLoC/Cubit (e.g., `MyScreenState`).
/// - [SuccessData]: The data type expected upon a successful API call (e.g., `User` or `List<Post>`).
class ApiStateHandler<CompositeState, SuccessData> implements IApiStateHandler {
  /// The [emit] function from the host BLoC/Cubit.
  final void Function(CompositeState) _emit;

  /// A getter function that returns the host BLoC/Cubit's **current** `state`.
  final CompositeState Function() _getState;

  /// A getter function that returns the host BLoC/Cubit's `isClosed` status.
  final bool Function() _isClosed;

  /// A "selector" function to extract the relevant [ApiState] from the [CompositeState].
  ///
  /// **Example:** `(state) => state.userState`
  final ApiState<SuccessData> Function(CompositeState) _getApiState;

  /// A "merger" function to update the [CompositeState] with a new [ApiState].
  ///
  /// **Example:** `(state, newApiState) => state.copyWith(userState: newApiState)`
  final CompositeState Function(CompositeState, ApiState<SuccessData>)
  _setApiState;

  /// The current request ID, if cancellation is enabled
  String? _currentRequestId;

  /// Creates a new [ApiStateHandler].
  ///
  /// This handler requires access to the BLoC/Cubit's core utilities
  /// to read and write state. This constructor is typically called by
  /// [ApiStateHostMixin.createApiHandler].
  ApiStateHandler({
    required void Function(CompositeState) emit,
    required CompositeState Function() getState,
    required bool Function() isClosed,
    required ApiState<SuccessData> Function(CompositeState) getApiState,
    required CompositeState Function(CompositeState, ApiState<SuccessData>)
    setApiState,
  }) : _emit = emit,
       _getState = getState,
       _isClosed = isClosed,
       _getApiState = getApiState,
       _setApiState = setApiState;

  /// Cancels the ongoing API request, if one exists.
  void cancelRequest() {
    if (_currentRequestId != null) {
      getIt<CancelRequestManager>().cancelRequest(_currentRequestId!);
      _currentRequestId = null;
    }
  }

  /// Executes the API call and manages its full state lifecycle.
  ///
  /// This is the primary method of the handler. It performs the following steps:
  /// 1. Checks if the state is already loading; if so, it returns.
  /// 2. Emits a new [CompositeState] with the [ApiState] set to `loading()`.
  /// 3. If [enableCancellation] is true, registers the request with [CancelRequestManager].
  /// 4. Executes the provided [apiCall] and passes the request ID if cancellation is enabled.
  /// 5. Awaits the result.
  /// 6. If the Cubit is closed, it does nothing.
  /// 7. On success, it emits a `succeeded(data)` state.
  /// 8. On failure, it emits a `failed(failure)` state with a built-in [retryFunction].
  ///
  /// ### Type Parameters:
  /// - [T]: The type of the parameters object to be passed to the [apiCall].
  ///
  /// ### Parameters:
  /// - [apiCall]: The async function (e.g., a UseCase) to execute. It must
  ///   return a [UseCaseFutureResponse] and optionally accept a [requestId] parameter.
  /// - [params]: The parameters to pass to the [apiCall].
  /// - [onSuccess]: An optional callback executed on success with the [SuccessData].
  /// - [onFailure]: An optional callback executed on failure with the [Failure].
  /// - [enableCancellation]: If `true`, registers the request with [CancelRequestManager]
  ///                         and enables cancellation via [cancelRequest]. Defaults to `true`.
  Future<void> handleApiCall<T>({
    required UseCaseFutureResponse<SuccessData> Function(
      T params, {
      String? requestId,
    })
    apiCall,
    required T params,
    void Function(SuccessData data)? onSuccess,
    void Function(Failure failure)? onFailure,
    bool enableCancellation = true,
  }) async {
    // 1. Get the *current* state
    final currentState = _getState();
    // Prevent duplicate calls if already loading
    if (_getApiState(currentState).isLoading) return;

    // 2. Emit loading state using the provided functions
    _emit(_setApiState(currentState, const ApiState.loading()));

    // 3. Register request if cancellation is enabled
    if (enableCancellation) {
      _currentRequestId = getIt<CancelRequestManager>().registerRequest();
    }

    try {
      // 4. Execute the call and pass requestId if cancellation is enabled
      final result = await apiCall(params, requestId: _currentRequestId);

      // 5. Check if the Cubit is closed
      if (!_isClosed()) {
        // 6. Get the *latest* state, as it might have changed during the await
        final latestState = _getState();

        // 7. Fold the result and emit the final state
        result.fold(
          (failure) {
            _emit(
              _setApiState(
                latestState,
                ApiState.failed(
                  failure,
                  // The retry function recursively calls this method with the same params
                  retryFunction: () => handleApiCall(
                    onFailure: onFailure,
                    onSuccess: onSuccess,
                    apiCall: apiCall,
                    params: params,
                    enableCancellation: enableCancellation,
                  ),
                ),
              ),
            );
            onFailure?.call(failure);
          },
          (success) {
            _emit(_setApiState(latestState, ApiState.succeeded(success)));
            onSuccess?.call(success);
          },
        );
      }
    } finally {
      // 8. Cleanup request registration
      if (_currentRequestId != null) {
        getIt<CancelRequestManager>().unregisterRequest(_currentRequestId!);
        _currentRequestId = null;
      }
    }
  }

  /// Cleans up resources by canceling any pending requests.
  ///
  /// This is called automatically by [ApiStateHostMixin] when
  /// the host BLoC/Cubit is closed.
  @override
  void dispose() {
    cancelRequest();
  }
}
