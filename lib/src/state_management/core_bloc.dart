import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_state_mixin.dart';

/// Abstract class for a Bloc that utilizes `ApiStateMixin`.
///
/// This class serves as a base for creating Blocs that manage API state.
///
/// Type Parameters:
/// - `E`: The event type that the Bloc processes.
/// - `S`: The composite state type managed by the Bloc.
/// - `T`: The success data type returned by the API call.
abstract class CoreBloc<E, S, T> extends Bloc<E, S> with ApiStateMixin<S, T> {
  CoreBloc(super.initialState);

  @override
  Future<void> close() {
    cancelRequest();
    return super.close();
  }
}
