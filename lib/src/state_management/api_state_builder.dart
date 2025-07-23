import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A customizable widget builder that handles API states from a [CoreCubit].
///
/// This widget provides default loading and error states but allows full
/// customization through builder parameters.
///
/// Type Parameters:
/// - [CompositeState]: The composite state type of the cubit
/// - [SuccessData]: The type of data returned on successful API calls
class ApiStateBuilder<CompositeState, SuccessData> extends StatelessWidget {
  const ApiStateBuilder({
    super.key,
    required this.cubit,
    this.initialBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    required this.successBuilder,
    required this.emptyEntity,
  });
  final CoreCubit<CompositeState, SuccessData> cubit;
  final Widget Function(BuildContext context)? initialBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
  )?
  errorBuilder;
  final Widget Function(BuildContext context, CompositeState data)
  successBuilder;
  final SuccessData emptyEntity;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoreCubit<CompositeState, SuccessData>, CompositeState>(
      bloc: cubit,
      builder: (context, state) {
        final apiState = cubit.getApiState(state);
        return switch (apiState) {
          Succeeded() => successBuilder(context, state),
          Failed(:final failureObject, :final retryFunction) =>
            errorBuilder?.call(
                  context,
                  failureObject.getOrElse(() => const UnknownFailure()),
                  retryFunction,
                ) ??
                CoreDefaultErrorWidget(
                  message: failureObject
                      .getOrElse(() => const UnknownFailure())
                      .message,
                  onRetry: retryFunction,
                ),
          Initial() => initialBuilder?.call(context) ?? const SizedBox.shrink(),
          Loading() =>
            loadingBuilder?.call(context) ??
                DefaultLoadingWidget<SuccessData>(
                  emptyEntity: emptyEntity,
                  successBuilder: (context, data) =>
                      successBuilder(context, state),
                ),
        };
      },
    );
  }
}

/// Default loading widget with shimmer effect
class DefaultLoadingWidget<T> extends StatelessWidget {
  const DefaultLoadingWidget({
    super.key,
    required this.emptyEntity,
    required this.successBuilder,
  });
  final T emptyEntity;
  final Widget Function(BuildContext context, T data) successBuilder;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(child: successBuilder(context, emptyEntity));
  }
}
