import 'package:async/async.dart';
import 'package:coore/lib.dart';
import 'package:fpdart/fpdart.dart';

/// A simple interface for disposable handlers.
///
/// This allows the [ApiStateHostMixin] to track and dispose of any
/// handler it creates, regardless of its generic types.
abstract class IApiStateHandler {
  /// Cleans up any resources held by the handler, such as
  /// canceling pending [CancelableOperation]s.
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

  /// The currently active, cancelable API operation.
  CancelableOperation<Either<Failure, SuccessData>>? _cancelableOperation;

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
    _cancelableOperation?.cancel();
  }

  /// Executes the API call and manages its full state lifecycle.
  ///
  /// This is the primary method of the handler. It performs the following steps:
  /// 1. Checks if the state is already loading; if so, it returns.
  /// 2. Emits a new [CompositeState] with the [ApiState] set to `loading()`.
  /// 3. Executes the provided [apiCall] and stores the [CancelableOperation].
  /// 4. Awaits the result.
  /// 5. If the operation was cancelled, it does nothing.
  /// 6. If the Cubit is closed, it does nothing.
  /// 7. On success, it emits a `succeeded(data)` state.
  /// 8. On failure, it emits a `failed(failure)` state with a built-in [retryFunction].
  ///
  /// ### Type Parameters:
  /// - [T]: The type of the parameters object to be passed to the [apiCall].
  ///
  /// ### Parameters:
  /// - [apiCall]: The async function (e.g., a UseCase) to execute. It must
  ///   return a [UseCaseCancelableResponse].
  /// - [params]: The parameters to pass to the [apiCall].
  /// - [onSuccess]: An optional callback executed on success with the [SuccessData].
  /// - [onFailure]: An optional callback executed on failure with the [Failure].
  Future<void> handleApiCall<T>({
    required UseCaseCancelableResponse<SuccessData> Function(T params) apiCall,
    required T params,
    void Function(SuccessData data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    // 1. Get the *current* state
    final currentState = _getState();
    // Prevent duplicate calls if already loading
    if (_getApiState(currentState).isLoading) return;

    // 2. Emit loading state using the provided functions
    _emit(_setApiState(currentState, const ApiState.loading()));

    // 3. Execute the call and store the operation
    _cancelableOperation = apiCall(params);
    final result = await _cancelableOperation!.valueOrCancellation();
    _cancelableOperation = null;

    // 4. Check if the Cubit is closed or if the request was cancelled (result == null)
    if (!_isClosed() && result != null) {
      // 5. Get the *latest* state, as it might have changed during the await
      final latestState = _getState();

      // 6. Fold the result and emit the final state
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
