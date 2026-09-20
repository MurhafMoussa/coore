import 'package:mocktail/mocktail.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('LoggingInterceptor Tests', () {
    late MockCoreLogger mockLogger;
    late LoggingInterceptor interceptor;

    setUp(() {
      mockLogger = MockCoreLogger();
      interceptor = LoggingInterceptor(logger: mockLogger);
    });

    test('onRequest logs HTTP method and path', () {
      final options = createTestRequestOptions(path: '/test', method: 'GET');
      final handler = MockRequestInterceptorHandler();
      when(() => handler.next(options)).thenAnswer((_) {});

      interceptor.onRequest(options, handler);

      verify(() => mockLogger.debug('HTTP GET Request: /test')).called(1);
      verify(() => handler.next(options)).called(1);
    });

    test('onResponse logs status code and path', () {
      final options = createTestRequestOptions(path: '/test');
      final response = createTestResponse<dynamic>(requestOptions: options, statusCode: 200);
      final handler = MockResponseInterceptorHandler();
      when(() => handler.next(response)).thenAnswer((_) {});

      interceptor.onResponse(response, handler);

      verify(() => mockLogger.debug('HTTP Response [200]: /test')).called(1);
      verify(() => handler.next(response)).called(1);
    });

    test('onError logs error status code, path, and exception', () {
      final options = createTestRequestOptions(path: '/test');
      final dioException = createTestDioException(
        requestOptions: options,
        statusCode: 500,
      );
      final handler = MockErrorInterceptorHandler();
      when(() => handler.next(dioException)).thenAnswer((_) {});

      interceptor.onError(dioException, handler);

      verify(() => mockLogger.error('HTTP Error [500]: /test', dioException, any())).called(1);
      verify(() => handler.next(dioException)).called(1);
    });
  });
}
