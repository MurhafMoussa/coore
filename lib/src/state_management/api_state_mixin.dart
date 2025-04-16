// api_state_mixin.dart

import 'package:coore/lib.dart';
import 'package:coore/src/api_handler/cancel_request_adapter.dart';
import 'package:coore/src/api_handler/params/base_params.dart';
import 'package:coore/src/error_handling/failures/failure.dart';
import 'package:coore/src/state_management/api_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

/// A generic mixin for BLoCs/Cubits that manage composite state objects containing an API state.
///
/// This mixin provides a reusable pattern for handling API calls, including request cancellation,
/// state updates for loading, success, and failure conditions, and optional retry functionality.
///
/// ### Type Parameters:
/// - `CompositeState`: The type of the composite state managed by the BLoC/Cubit. This state
///   includes both API call status and other related form or view data.
/// - `SuccessData`: The expected type of data returned upon a successful API call.
///
/// ### Usage:
/// When mixing this in to a BLoC/Cubit, you must provide implementations for:
/// - [getApiState] to extract the current API-related state from your composite state.
/// - [setApiState] to update your composite state with a new API state.
///
/// The [handleApiCall] method is used to encapsulate the API call lifecycle:
/// - It checks if an API call is already in progress.
/// - Emits a loading state.
/// - Performs the API call while supporting request cancellation via [cancelRequestAdapter].
/// - Emits either a failure or success state based on the response.
/// - Optionally provides a retry function for failed requests.
mixin ApiStateMixin<CompositeState, SuccessData> on BlocBase<CompositeState> {
  /// Adapter instance used to cancel an ongoing API request.
  CancelRequestAdapter? cancelRequestAdapter;

  /// Cancels an ongoing API request, if one exists.
  void cancelRequest() {
    cancelRequestAdapter?.cancelRequest();
  }

  /// Retrieves the current API state from the composite state.
  ///
  /// This method must be implemented by the consuming BLoC/Cubit to extract
  /// the API-specific state (such as loading, success, or failure) from a larger state object.
  ApiState<SuccessData> getApiState(CompositeState state);

  /// Updates the composite state with a new API state.
  ///
  /// This method must be implemented by the consuming BLoC/Cubit to merge the new
  /// API state into its current composite state.
  CompositeState setApiState(
    CompositeState state,
    ApiState<SuccessData> apiState,
  );

  /// Executes an API call and manages its state lifecycle including loading, success, and failure.
  ///
  /// This method encapsulates the following workflow:
  /// 1. Prevents duplicate API calls if one is already in progress.
  /// 2. Emits a loading state.
  /// 3. Sets up a request cancellation adapter.
  /// 4. Executes the provided API call with the given parameters.
  /// 5. Depending on the outcome, either emits a failure state (with a built-in retry function)
  ///    or emits a success state.
  ///
  /// ### Parameters:
  /// - `apiCall`: A function that takes parameters of type [T] and returns a `TaskEither` containing
  ///    either a [Failure] or the [SuccessData]. This function executes the actual API call.
  /// - `params`: The parameters to pass to [apiCall]. It must extend [BaseParams].
  /// - `onSuccess`: An optional callback invoked when the API call succeeds.
  /// - `onFailure`: An optional callback invoked when the API call fails.
  ///
  /// The method uses a cancellation adapter to ensure that the API call can be cancelled
  /// if needed. If the call fails, the state is updated with a failure and a retry function is provided.
  Future<void> handleApiCall<T extends BaseParams>({
    required RepositoryFutureResponse<SuccessData> Function(T params) apiCall,
    required T params,
    void Function(SuccessData data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    // Avoid duplicate API calls if one is already in progress.
    if (getApiState(state).isLoading) return;

    // Emit loading state.
    emit(setApiState(state, const ApiState.loading()));

    // Initialize the cancel request adapter.
    cancelRequestAdapter = DioCancelRequestAdapter();

    // Execute the API call, attaching the cancel token.
    final result = await apiCall(
      params.attachCancelToken(cancelTokenAdapter: cancelRequestAdapter) as T,
    );

    // Ensure that the Bloc/Cubit is still active before updating state.
    if (!isClosed) {
      result.fold(
        (failure) {
          // On failure: Emit failure state with a retry function.
          emit(
            setApiState(
              state,
              ApiState.failed(
                failure,
                retryFunction:
                    () => handleApiCall(
                      onFailure: onFailure,
                      onSuccess: onSuccess,
                      apiCall: apiCall,
                      params: params,
                    ),
              ),
            ),
          );
          // Call failure callback if provided.
          onFailure?.call(failure);
        },
        (success) {
          // On success: Emit the succeeded state.
          emit(setApiState(state, ApiState.succeeded(success)));
          // Call success callback if provided.
          onSuccess?.call(success);
        },
      );
    }
  }

 
}
