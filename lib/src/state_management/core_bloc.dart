import 'package:coore/src/api_handler/api_handler.dart';
import 'package:coore/src/state_management/api_state_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Abstract class for a Bloc that utilizes `ApiStateMixin`.
///
/// This class serves as a base for creating Blocs that manage API state.
///
/// Type Parameters:
/// - `EventType`: The event type that the Bloc processes.
/// - `CompositeState`: The composite state type managed by the Bloc.
/// - `SuccessData`: The success data type returned by the API call.
abstract class CoreBloc<
  EventType,
  CompositeState,
  SuccessData,
  FunctionParam extends BaseParams
>
    extends Bloc<EventType, CompositeState>
    with ApiStateMixin<CompositeState, SuccessData, FunctionParam> {
  CoreBloc(super.initialState);

  @override
  Future<void> close() {
    cancelRequest();
    return super.close();
  }
}
