import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_state_mixin.dart';

/// Abstract class for a Cubit that utilizes `ApiStateMixin`.
///
/// This class serves as a base for creating Cubits that manage API state.
///
/// Type Parameters:
/// - `S`: The composite state type managed by the Cubit.
/// - `T`: The success data type returned by the API call.
abstract class CoreCubit<S, T> extends Cubit<S> with ApiStateMixin<S, T> {
  CoreCubit(super.initialState);

  @override
  Future<void> close() {
    cancelRequest();
    return super.close();
  }
}
