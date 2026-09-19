import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_state/strata_state.dart';

class MockCoreLogger extends Mock implements CoreLoggerInterface {}

class TestCompositeState {
  const TestCompositeState({
    required this.dataState,
  });

  final ApiState<String> dataState;

  TestCompositeState copyWith({
    ApiState<String>? dataState,
  }) {
    return TestCompositeState(
      dataState: dataState ?? this.dataState,
    );
  }
}

void main() {
  late MockCoreLogger mockLogger;
  late TestCompositeState currentState;
  late List<TestCompositeState> emittedStates;
  late bool isClosed;
  late String? cancelledRequestId;

  late ApiStateHandler<TestCompositeState, String> handler;

  setUp(() async {
    await GetIt.I.reset();
    mockLogger = MockCoreLogger();
    currentState = const TestCompositeState(dataState: ApiState.initial());
    emittedStates = [];
    isClosed = false;
    cancelledRequestId = null;

    handler = ApiStateHandler<TestCompositeState, String>(
      emit: (state) {
        currentState = state;
        emittedStates.add(state);
      },
      getState: () => currentState,
      isClosed: () => isClosed,
      getApiState: (state) => state.dataState,
      setApiState: (state, apiState) => state.copyWith(dataState: apiState),
      logger: mockLogger,
      onCancelRequest: (reqId) {
        cancelledRequestId = reqId;
      },
    );
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('ApiStateHandler Unit Tests', () {
    test('handleApiCall executes successfully and emits loading then success', () async {
      String? successData;

      await handler.handleApiCall<String>(
        apiCall: (params) async => right('Fetched Data: $params'),
        params: 'test_param',
        onSuccess: (data) => successData = data,
      );

      expect(emittedStates.length, equals(2));
      expect(emittedStates[0].dataState, isA<ApiStateLoading<String>>());
      expect(emittedStates[1].dataState, isA<ApiStateSuccess<String>>());
      expect(currentState.dataState.dataOrNull, equals('Fetched Data: test_param'));
      expect(successData, equals('Fetched Data: test_param'));
    });

    test('handleApiCall handles failure, emits failure, and provides working retryFunction', () async {
      Failure? capturedFailure;
      const failure = ServerFailure(message: 'Server Error', statusCode: 500);

      await handler.handleApiCall<String>(
        apiCall: (params) async => left(failure),
        params: 'test_param',
        onFailure: (f) => capturedFailure = f,
      );

      expect(emittedStates.length, equals(2));
      expect(emittedStates[0].dataState, isA<ApiStateLoading<String>>());
      expect(emittedStates[1].dataState, isA<ApiStateFailure<String>>());
      expect(capturedFailure, equals(failure));

      final failureState = currentState.dataState as ApiStateFailure<String>;
      expect(failureState.retryFunction, isNotNull);

      // Reset currentState for retry
      currentState = const TestCompositeState(dataState: ApiState.initial());
      emittedStates.clear();

      failureState.retryFunction!();
      await Future<void>.delayed(Duration.zero);

      expect(emittedStates.length, equals(2));
      expect(emittedStates[1].dataState, isA<ApiStateFailure<String>>());
    });

    test('handleApiCall(force: false) skips execution during isLoading state and logs diagnostic warning', () async {
      currentState = const TestCompositeState(dataState: ApiState.loading());
      var executed = false;

      await handler.handleApiCall<String>(
        apiCall: (params) async {
          executed = true;
          return right('data');
        },
        params: 'param',
        force: false,
      );

      expect(executed, isFalse);
      expect(emittedStates, isEmpty);
      verify(() => mockLogger.warning(any(that: contains('skipped because state is already loading')))).called(1);
    });

    test('handleApiCall(force: true) executes API call even during isLoading state', () async {
      currentState = const TestCompositeState(dataState: ApiState.loading());
      var executed = false;

      await handler.handleApiCall<String>(
        apiCall: (params) async {
          executed = true;
          return right('Force Loaded Data');
        },
        params: 'param',
        force: true,
      );

      expect(executed, isTrue);
      expect(emittedStates.length, equals(2));
      expect(currentState.dataState.dataOrNull, equals('Force Loaded Data'));
      verifyNever(() => mockLogger.warning(any()));
    });

    test('handleApiCall tracks requestId and cleans up after completion', () async {
      await handler.handleApiCall<String>(
        apiCall: (params) async {
          expect(handler.currentRequestId, equals('request_123'));
          return right('data');
        },
        params: 'param',
        requestId: 'request_123',
      );

      expect(handler.currentRequestId, isNull);
    });

    test('cancelRequest invokes onCancelRequest and clears currentRequestId', () async {
      handler.handleApiCall<String>(
        apiCall: (params) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return right('data');
        },
        params: 'param',
        requestId: 'request_456',
      );

      expect(handler.currentRequestId, equals('request_456'));
      handler.cancelRequest();

      expect(cancelledRequestId, equals('request_456'));
      expect(handler.currentRequestId, isNull);
    });

    test('dispose invokes cancelRequest', () {
      handler.handleApiCall<String>(
        apiCall: (params) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return right('data');
        },
        params: 'param',
        requestId: 'request_789',
      );

      handler.dispose();
      expect(cancelledRequestId, equals('request_789'));
    });

    test('does not emit state if isClosed returns true when apiCall resolves', () async {
      await handler.handleApiCall<String>(
        apiCall: (params) async {
          isClosed = true;
          return right('data');
        },
        params: 'param',
      );

      expect(emittedStates.length, equals(1)); // Only loading emitted before apiCall completed
      expect(emittedStates[0].dataState, isA<ApiStateLoading<String>>());
    });

    test('falls back to GetIt logger if constructor logger is null', () async {
      GetIt.I.registerSingleton<CoreLoggerInterface>(mockLogger);

      final noLoggerHandler = ApiStateHandler<TestCompositeState, String>(
        emit: (s) => currentState = s,
        getState: () => currentState,
        isClosed: () => isClosed,
        getApiState: (s) => s.dataState,
        setApiState: (s, api) => s.copyWith(dataState: api),
      );

      currentState = const TestCompositeState(dataState: ApiState.loading());

      await noLoggerHandler.handleApiCall<String>(
        apiCall: (params) async => right('data'),
        params: 'param',
        force: false,
      );

      verify(() => mockLogger.warning(any(that: contains('skipped because state is already loading')))).called(1);
    });
  });
}
