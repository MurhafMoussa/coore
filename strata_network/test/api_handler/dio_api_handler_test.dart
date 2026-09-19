import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}
class MockNetworkExceptionMapper extends Mock implements NetworkExceptionMapperInterface {}
class MockCancelRequestManager extends Mock implements CancelRequestManagerInterface {}

void main() {
  group('DioApiHandler Tests', () {
    late MockDio mockDio;
    late MockNetworkExceptionMapper mockExceptionMapper;
    late MockCancelRequestManager mockCancelManager;
    late DioApiHandler handler;

    setUpAll(() {
      registerFallbackValue(CancelToken());
      registerFallbackValue(Options());
    });

    setUp(() {
      mockDio = MockDio();
      mockExceptionMapper = MockNetworkExceptionMapper();
      mockCancelManager = MockCancelRequestManager();

      handler = DioApiHandler(
        mockDio,
        mockExceptionMapper,
        cancelRequestManager: mockCancelManager,
      );
    });

    test('get executes successful GET request and parses response', () async {
      final options = RequestOptions(path: '/users');
      when(
        () => mockDio.get<dynamic>(
          '/users',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
          data: {'name': 'John Doe'},
        ),
      );

      final result = await handler.get<String>(
        '/users',
        parser: (Map<String, dynamic> json) => json['name'] as String,
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => ''), equals('John Doe'));
    });

    test('registers and unregisters cancel token when requestId is provided', () async {
      final dummyToken = CancelToken();
      when(() => mockCancelManager.registerRequest('req_123'))
          .thenReturn(dummyToken);
      when(() => mockCancelManager.unregisterToken('req_123', dummyToken))
          .thenAnswer((_) {});

      final options = RequestOptions(path: '/users');
      when(
        () => mockDio.get<dynamic>(
          '/users',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: dummyToken,
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
          data: {'id': '123'},
        ),
      );

      await handler.get<String>(
        '/users',
        parser: (Map<String, dynamic> json) => json['id'] as String,
        requestId: 'req_123',
      );

      verify(() => mockCancelManager.registerRequest('req_123')).called(1);
      verify(() => mockCancelManager.unregisterToken('req_123', dummyToken)).called(1);
    });

    test('maps DioException to Failure when request fails', () async {
      final options = RequestOptions(path: '/error');
      final dioException = DioException(
        requestOptions: options,
        response: Response(statusCode: 500, requestOptions: options),
      );

      when(
        () => mockDio.get<dynamic>(
          '/error',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenThrow(dioException);

      when(() => mockExceptionMapper.mapException(dioException, any()))
          .thenReturn(const ServerFailure(message: 'Internal Server Error', statusCode: 500));

      final result = await handler.get<String>(
        '/error',
        parser: (Map<String, dynamic> json) => '',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });
}
