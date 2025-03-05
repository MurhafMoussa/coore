// api_state_mixin.dart

import 'package:coore/src/api_handler/cancel_request_adapter.dart';
import 'package:coore/src/api_handler/params/base_params.dart';
import 'package:coore/src/error_handling/failures/failure.dart';
import 'package:coore/src/state_management/api_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

/// A generic mixin for BLoCs/Cubits that manage composite states containing API state.
///
/// This mixin provides a structure to handle API calls and manage their state within
/// a BLoC/Cubit, ensuring consistent loading, success, and failure state handling.
///
/// Type Parameters:
/// - `CompositeState`: The composite state type managed by the BLoC.
/// - `SuccessData`: The success data type returned by the API call.
mixin ApiStateMixin<CompositeState, SuccessData> on BlocBase<CompositeState> {
  /// Adapter to manage cancellation of API requests.
  CancelRequestAdapter? cancelRequestAdapter;

  /// Cancels an ongoing API request if applicable.
  void cancelRequest() {
    cancelRequestAdapter?.cancelRequest();
  }

  /// Retrieves the current API state from the composite state.
  ///
  /// Must be implemented by the consuming BLoC/Cubit.
  ApiState<SuccessData> getApiState(CompositeState state);

  /// Updates the composite state with a new API state.
  ///
  /// Must be implemented by the consuming BLoC/Cubit.
  CompositeState setApiState(
    CompositeState state,
    ApiState<SuccessData> apiState,
  );

  /// Handles an API call lifecycle and updates the state accordingly.
  ///
  /// This function ensures that the state is updated for loading, success,
  /// and failure scenarios while also managing request cancellation.
  ///
  /// Parameters:
  /// - `apiCall`: A function that performs the API call, returning a `TaskEither` of `Failure` or `T`.
  /// - `params`: The parameters required for the API call.
  /// - `onSuccess`: (Optional) A callback executed when the API call is successful.
  /// - `onFailure`: (Optional) A callback executed when the API call fails.
  Future<void> handleApiCall<T extends BaseParams>({
    required Future<Either<Failure, SuccessData>> Function(T params) apiCall,
    required T params,
    void Function(SuccessData data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    // Prevents duplicate API calls while a request is already in progress
    if (getApiState(state).isLoading) return;

    // Emit loading state
    emit(setApiState(state, const ApiState.loading()));

    // Initialize request cancellation adapter
    cancelRequestAdapter = DioCancelRequestAdapter();

    // Execute the API call
    final result = await apiCall(
      params.attachCancelToken(cancelTokenAdapter: cancelRequestAdapter) as T,
    );

    // Handle API response
    if (!isClosed) {
      result.fold(
        (failure) {
          // Emit failure state with a retry function
          emit(
            setApiState(
              state,
              ApiState.failure(
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
          // Invoke failure callback if provided
          onFailure?.call(failure);
        },
        (success) {
          // Emit success state
          emit(setApiState(state, ApiState.success(success)));
          // Invoke success callback if provided
          onSuccess?.call(success);
        },
      );
    }
  }
}
