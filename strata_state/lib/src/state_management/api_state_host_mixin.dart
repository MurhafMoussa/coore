import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strata_core/strata_core.dart';
import 'api_state_handler.dart';
import 'disposable_api_state_handler_interface.dart';

/// A mixin for [BlocBase] (Cubit or BLoC) that acts as a factory and manager
/// for [ApiStateHandler] instances.
mixin ApiStateHostMixin<CompositeState> on BlocBase<CompositeState> {
  final List<DisposableApiStateHandlerInterface> _apiHandlers = [];

  /// Creates, registers, and returns a new [ApiStateHandler].
  ApiStateHandler<CompositeState, SuccessData> createApiHandler<SuccessData>({
    required ApiState<SuccessData> Function(CompositeState) getApiState,
    required CompositeState Function(CompositeState, ApiState<SuccessData>)
        setApiState,
    CoreLoggerInterface? logger,
    void Function(String requestId)? onCancelRequest,
  }) {
    final handler = ApiStateHandler<CompositeState, SuccessData>(
      emit: emit,
      getState: () => state,
      isClosed: () => isClosed,
      getApiState: getApiState,
      setApiState: setApiState,
      logger: logger,
      onCancelRequest: onCancelRequest,
    );

    _apiHandlers.add(handler);
    return handler;
  }

  @override
  Future<void> close() {
    for (final handler in _apiHandlers) {
      handler.dispose();
    }
    _apiHandlers.clear();
    return super.close();
  }
}
