import 'package:coore/lib.dart';
import 'package:coore/src/state_management/api_state_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Abstract class for a Cubit that utilizes `ApiStateMixin`.
///
/// This class serves as a base for creating Cubits that manage API state.
///
/// Type Parameters:
/// - `CompositeState`: The composite state type managed by the Cubit.
/// - `SuccessData`: The success data type returned by the API call.
abstract class CoreCubit<CompositeState, SuccessData>
    extends Cubit<CompositeState>
    with ApiStateMixin<CompositeState, SuccessData> {
  CoreCubit(super.initialState);

  @override
  Future<void> close() {
    cancelRequest();
    return super.close();
  }
}
