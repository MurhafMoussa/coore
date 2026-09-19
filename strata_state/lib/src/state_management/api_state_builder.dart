import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:strata_core/strata_core.dart';

/// A widget builder that reacts to a specific [ApiState] within a BLoC/Cubit composite state.
class ApiStateBuilder<CompositeState, SuccessData> extends StatelessWidget {
  const ApiStateBuilder({
    super.key,
    required this.bloc,
    required this.getApiState,
    required this.successBuilder,
    this.initialBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyEntity,
  });

  /// The BLoC/Cubit to observe.
  final BlocBase<CompositeState> bloc;

  /// Selector function to extract [ApiState] from the composite state.
  final ApiState<SuccessData> Function(CompositeState) getApiState;

  /// Builder for the [ApiStateSuccess] state.
  final Widget Function(BuildContext context, SuccessData data) successBuilder;

  /// Optional builder for [ApiStateInitial] state. Defaults to [SizedBox.shrink].
  final Widget Function(BuildContext context)? initialBuilder;

  /// Optional builder for [ApiStateLoading] state.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Optional builder for [ApiStateFailure] state.
  final Widget Function(
    BuildContext context,
    Failure failure,
    void Function()? retry,
  )? errorBuilder;

  /// Dummy entity for rendering skeleton loading state when [loadingBuilder] is omitted.
  final SuccessData? emptyEntity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocBase<CompositeState>, CompositeState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          getApiState(previous) != getApiState(current),
      builder: (context, state) {
        final apiState = getApiState(state);

        return switch (apiState) {
          ApiStateInitial<SuccessData>() =>
            initialBuilder?.call(context) ?? const SizedBox.shrink(),
          ApiStateLoading<SuccessData>() =>
            loadingBuilder?.call(context) ??
                (emptyEntity != null
                    ? Skeletonizer(
                        child:
                            successBuilder(context, emptyEntity as SuccessData),
                      )
                    : const Center(child: CircularProgressIndicator())),
          ApiStateSuccess<SuccessData>(:final value) =>
            successBuilder(context, value),
          ApiStateFailure<SuccessData>(:final failure, :final retryFunction) =>
            errorBuilder?.call(context, failure, retryFunction) ??
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(failure.message),
                      if (retryFunction != null)
                        TextButton(
                          onPressed: retryFunction,
                          child: const Text('Retry'),
                        ),
                    ],
                  ),
                ),
        };
      },
    );
  }
}
