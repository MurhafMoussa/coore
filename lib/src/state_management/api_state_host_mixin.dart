import 'package:coore/lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A mixin for [BlocBase] (Cubit or BLoC) that acts as a "factory" and
/// "manager" for [ApiStateHandler] instances.
///
/// Use this mixin on your Cubit to easily manage one or more independent
/// API lifecycles within a single composite state.
///
/// ### Features:
/// - **Boilerplate Reduction:** Provides [createApiHandler] to automatically
///   inject the Cubit's context (`emit`, `state`, `isClosed`) into the handler.
/// - **Lifecycle Management:** Automatically overrides [close] to dispose
///   of all created handlers, preventing memory leaks and dangling requests.
///
/// ### Type Parameters:
/// - [CompositeState]: The full state object of the BLoC/Cubit.
mixin ApiStateHostMixin<CompositeState> on BlocBase<CompositeState> {
  /// A private list to track all created handlers for automatic disposal.
  final List<IApiStateHandler> _apiHandlers = [];

  /// Creates, registers, and returns a new [ApiStateHandler].
  ///
  /// Call this in your Cubit's constructor for each [ApiState] you
  /// need to manage.
  ///
  /// ### Type Parameters:
  /// - [SuccessData]: The data type this handler will manage (e.g., `User`).
  ///
  /// ### Parameters:
  /// - [getApiState]: A "selector" function to read the [ApiState] from the [CompositeState].
  ///   **Example:** `(state) => state.userState`
  /// - [setApiState]: A "merger" function to write a new [ApiState] into the [CompositeState].
  ///   **Example:** `(state, apiState) => state.copyWith(userState: apiState)`
  ApiStateHandler<CompositeState, SuccessData> createApiHandler<SuccessData>({
    required ApiState<SuccessData> Function(CompositeState) getApiState,
    required CompositeState Function(CompositeState, ApiState<SuccessData>)
    setApiState,
  }) {
    // 2. Create the handler, injecting the Cubit's context
    final handler = ApiStateHandler<CompositeState, SuccessData>(
      emit: emit,
      getState: () => state,
      isClosed: () => isClosed,
      getApiState: getApiState,
      setApiState: setApiState,
    );

    // 3. Register it for automatic disposal
    _apiHandlers.add(handler);
    return handler;
  }

  /// Automatically disposes all registered [ApiStateHandler]s.
  ///
  /// This overrides the [BlocBase.close] method and is called when
  /// the Cubit itself is closed.
  @override
  Future<void> close() {
    for (final handler in _apiHandlers) {
      handler.dispose();
    }
    _apiHandlers.clear();
    return super.close();
  }
}
