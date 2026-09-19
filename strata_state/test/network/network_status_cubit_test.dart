import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_state/strata_state.dart';

class MockNetworkStatusInterface extends Mock implements NetworkStatusInterface {}

void main() {
  late MockNetworkStatusInterface mockNetworkStatus;
  late StreamController<ConnectionStatus> streamController;

  setUp(() {
    mockNetworkStatus = MockNetworkStatusInterface();
    streamController = StreamController<ConnectionStatus>.broadcast();
    when(() => mockNetworkStatus.connectionStream)
        .thenAnswer((_) => streamController.stream);
    when(() => mockNetworkStatus.dispose()).thenAnswer((_) async {});
  });

  tearDown(() {
    streamController.close();
  });

  group('NetworkStatusCubit', () {
    test('initial state is connected and updates on stream events', () async {
      final cubit = NetworkStatusCubit(networkStatus: mockNetworkStatus);
      expect(cubit.state, equals(ConnectionStatus.connected));

      streamController.add(ConnectionStatus.disconnected);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, equals(ConnectionStatus.disconnected));

      streamController.add(ConnectionStatus.connected);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, equals(ConnectionStatus.connected));

      await cubit.close();
      verify(() => mockNetworkStatus.dispose()).called(1);
    });
  });
}
