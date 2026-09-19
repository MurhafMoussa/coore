import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_state/strata_state.dart';

class TestCubitState {
  const TestCubitState({
    required this.userState,
  });

  final ApiState<String> userState;

  TestCubitState copyWith({
    ApiState<String>? userState,
  }) {
    return TestCubitState(
      userState: userState ?? this.userState,
    );
  }
}

class TestCubit extends Cubit<TestCubitState> with ApiStateHostMixin<TestCubitState> {
  TestCubit({void Function(String)? onCancelRequest})
      : super(const TestCubitState(userState: ApiState.initial())) {
    userHandler = createApiHandler(
      getApiState: (state) => state.userState,
      setApiState: (state, apiState) => state.copyWith(userState: apiState),
      onCancelRequest: onCancelRequest,
    );
  }

  late final ApiStateHandler<TestCubitState, String> userHandler;

  Future<void> fetchUser(String id, {bool force = false, String? requestId}) async {
    await userHandler.handleApiCall(
      apiCall: (params) async => right('User: $params'),
      params: id,
      force: force,
      requestId: requestId,
    );
  }
}

void main() {
  group('ApiStateHostMixin Unit Tests', () {
    test('creates handler and executes handleApiCall updating cubit state', () async {
      final cubit = TestCubit();

      expect(cubit.state.userState, isA<ApiStateInitial<String>>());

      await cubit.fetchUser('123');

      expect(cubit.state.userState, isA<ApiStateSuccess<String>>());
      expect(cubit.state.userState.dataOrNull, equals('User: 123'));

      await cubit.close();
    });

    test('closing cubit automatically disposes registered handlers', () async {
      String? cancelledId;
      final cubit = TestCubit(onCancelRequest: (id) => cancelledId = id);

      // Start an un-completed async call with requestId
      cubit.userHandler.handleApiCall<String>(
        apiCall: (params) async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return right('User');
        },
        params: '456',
        requestId: 'req_456',
      );

      expect(cubit.userHandler.currentRequestId, equals('req_456'));

      await cubit.close();

      expect(cancelledId, equals('req_456'));
      expect(cubit.userHandler.currentRequestId, isNull);
    });
  });
}
