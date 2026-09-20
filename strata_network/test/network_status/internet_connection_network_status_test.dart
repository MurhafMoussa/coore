import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

class MockInternetConnection extends Mock implements InternetConnection {}
class MockCoreLoggerInterface extends Mock implements CoreLoggerInterface {}

void main() {
  late MockInternetConnection mockInternetConnection;
  late MockCoreLoggerInterface mockLogger;
  late StreamController<InternetStatus> statusController;

  setUp(() {
    mockInternetConnection = MockInternetConnection();
    mockLogger = MockCoreLoggerInterface();
    statusController = StreamController<InternetStatus>.broadcast();

    when(() => mockInternetConnection.onStatusChange)
        .thenAnswer((_) => statusController.stream);
  });

  tearDown(() {
    statusController.close();
  });

  group('InternetConnectionNetworkStatus', () {
    test('isConnected returns internet status from InternetConnection', () async {
      when(() => mockInternetConnection.hasInternetAccess)
          .thenAnswer((_) async => true);

      final service =
          InternetConnectionNetworkStatus(mockInternetConnection, mockLogger);
      final isConnected = await service.isConnected;

      expect(isConnected, isTrue);
    });

    test('connectionStream emits ConnectionStatus on status changes', () async {
      final service =
          InternetConnectionNetworkStatus(mockInternetConnection, mockLogger);

      expectLater(
        service.connectionStream,
        emitsInOrder([
          ConnectionStatus.connected,
          ConnectionStatus.disconnected,
        ]),
      );

      statusController.add(InternetStatus.connected);
      statusController.add(InternetStatus.disconnected);
    });
  });
}
