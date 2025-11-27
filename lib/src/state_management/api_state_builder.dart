import 'package:coore/lib.dart'; // Assuming this imports Failure, ApiState, CoreDefaultErrorWidget, etc.
import 'package:coore/src/error_handling/failures/unknown_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A customizable widget builder that reacts to a specific [ApiState]
/// from any [BlocBase] (Cubit or BLoC).
///
/// This widget is the recommended way to render UI based on an [ApiState]
/// managed by an [ApiStateHandler]. It provides default loading (with a
/// [Skeletonizer] effect) and error states, but allows full customization.
///
/// ### Type Parameters:
/// - [CompositeState]: The full state object of the BLoC/Cubit (e.g., `MyScreenState`).
/// - [SuccessData]: The data type this builder should expect on success (e.g., `User`).
class ApiStateBuilder<CompositeState, SuccessData> extends StatelessWidget {
  /// Creates an [ApiStateBuilder].
  ///
  /// ### Required Parameters:
  /// - [bloc]: The BLoC/Cubit instance to observe.
  /// - [getApiState]: A "selector" function to extract the relevant [ApiState]
  ///   from the [CompositeState]. Example: `(state) => state.userState`.
  /// - [successBuilder]: A builder that is called only on success, receiving
  ///   the [SuccessData] directly.
  /// - [emptyEntity]: A "dummy" or "empty" instance of [SuccessData]. This is
  ///   crucial for the [DefaultLoadingWidget] to render a correctly-shaped
  ///   skeleton of your UI *before* data has loaded.
  const ApiStateBuilder({
    super.key,
    required this.bloc,
    required this.getApiState,
    this.initialBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    required this.successBuilder,
    required this.emptyEntity,
  });

  /// The BLoC/Cubit to observe.
  final BlocBase<CompositeState> bloc;

  /// A function to extract the relevant [ApiState] from the [CompositeState].
  ///
  /// **Example:** `(state) => state.userState`
  final ApiState<SuccessData> Function(CompositeState) getApiState;

  /// An optional builder for the [ApiState.initial] state.
  ///
  /// Defaults to [SizedBox.shrink].
  final Widget Function(BuildContext context)? initialBuilder;

  /// An optional builder for the [ApiState.loading] state.
  ///
  /// Defaults to [DefaultLoadingWidget], which provides a [Skeletonizer]
  /// shimmer effect.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// An optional builder for the [ApiState.failed] state.
  ///
  /// Defaults to [CoreDefaultErrorWidget].
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
  )?
  errorBuilder;

  /// The builder for the [ApiState.succeeded] state.
  ///
  /// This builder receives the [SuccessData] (e.g., a `User` object)
  /// directly, not the full [CompositeState].
  final Widget Function(BuildContext context, SuccessData data) successBuilder;

  /// A "dummy" version of [SuccessData] used by [DefaultLoadingWidget]
  /// to build the skeleton loader.
  ///
  /// **Example:** `User.empty()` or `[]` (for a list).
  final SuccessData emptyEntity;

  @override
  Widget build(BuildContext context) {
    // This BlocBuilder listens to the *entire* CompositeState...
    return BlocBuilder<BlocBase<CompositeState>, CompositeState>(
      bloc: bloc,
      // ...but `buildWhen` ensures it *only* rebuilds if the *specific*
      // ApiState we care about has changed. This is highly efficient.
      buildWhen: (previous, current) {
        return getApiState(previous) != getApiState(current);
      },
      builder: (context, state) {
        // 5. Uses the provided function to get the state
        final apiState = getApiState(state);

        // 6. Use Dart's pattern matching to render the correct UI
        return switch (apiState) {
          // On success, pass the data directly to successBuilder
          Succeeded(:final successValue) => successBuilder(
            context,
            successValue,
          ),
          // On failure, use errorBuilder or the default
          Failed(:final failureObject, :final retryFunction) =>
            errorBuilder?.call(
                  context,
                  failureObject.getOrElse(
                    () => const UnknownFailure(message: 'Unknown failure'),
                  ),
                  retryFunction,
                ) ??
                CoreDefaultErrorWidget(
                  message: failureObject
                      .getOrElse(
                        () => const UnknownFailure(message: 'Unknown failure'),
                      )
                      .message,
                  onRetry: retryFunction,
                ),
          // On initial, use initialBuilder or the default
          Initial() => initialBuilder?.call(context) ?? const SizedBox.shrink(),
          // On loading, use loadingBuilder or the default
          Loading() =>
            loadingBuilder?.call(context) ??
                DefaultLoadingWidget<SuccessData>(
                  emptyEntity: emptyEntity,
                  // Pass the successBuilder to the skeletonizer
                  successBuilder: successBuilder,
                ),
        };
      },
    );
  }
}

/// The default loading widget, which wraps the [successBuilder]
/// in a [Skeletonizer] to create an automatic shimmer effect.
class DefaultLoadingWidget<T> extends StatelessWidget {
  const DefaultLoadingWidget({
    super.key,
    required this.emptyEntity,
    required this.successBuilder,
  });

  /// The "dummy" data to pass to the [successBuilder].
  final T emptyEntity;

  /// The [successBuilder] from the parent [ApiStateBuilder].
  final Widget Function(BuildContext context, T data) successBuilder;

  @override
  Widget build(BuildContext context) {
    // The Skeletonizer effect is simple:
    // 1. Enable shimmering.
    // 2. Build the *success* widget but pass it the *empty* data.
    // This renders the shape of your UI, and Skeletonizer shimmers it.
    return Skeletonizer(child: successBuilder(context, emptyEntity));
  }
}
