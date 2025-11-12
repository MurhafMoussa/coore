import 'package:async/async.dart';
import 'package:coore/src/api_handler/api_handler_impl.dart';
import 'package:coore/src/api_handler/form_data_adapter.dart';
import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:coore/src/error_handling/exception_mapper/network_exception_mapper.dart';
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_handler_impl_test.mocks.dart';

// Test model for parser testing
class TestModel {
  final int id;
  final String name;

  TestModel({required this.id, required this.name});

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(id: json['id'] as int, name: json['name'] as String);
  }
}

@GenerateMocks([Dio, NetworkExceptionMapper, CacheStore, FormDataAdapter])
void main() {
  late DioApiHandler apiHandler;
  late MockDio mockDio;
  late MockNetworkExceptionMapper mockExceptionMapper;
  late MockCacheStore mockCacheStore;

  setUp(() {
    mockDio = MockDio();
    mockExceptionMapper = MockNetworkExceptionMapper();
    mockCacheStore = MockCacheStore();

    // Register CacheStore in GetIt for testing
    if (getIt.isRegistered<CacheStore>()) {
      getIt.unregister<CacheStore>();
    }
    getIt.registerSingleton<CacheStore>(mockCacheStore);

    apiHandler = DioApiHandler(mockDio, mockExceptionMapper);
  });

  tearDown(() {
    if (getIt.isRegistered<CacheStore>()) {
      getIt.unregister<CacheStore>();
    }
  });

  // Utility functions
  Response createSuccessResponse([Map<String, dynamic>? data]) {
    return Response(
      data: data ?? {'result': 'success'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/test'),
    );
  }

  void mockDioGet(Response response) {
    when(
      mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((_) async => response);
  }

  void mockDioPost(Response response) {
    when(
      mockDio.post(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((_) async => response);
  }

  void mockDioPut(Response response) {
    when(
      mockDio.put(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((_) async => response);
  }

  void mockDioPatch(Response response) {
    when(
      mockDio.patch(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((_) async => response);
  }

  void mockDioDelete(Response response) {
    when(
      mockDio.delete(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
      ),
    ).thenAnswer((_) async => response);
  }

  void mockDioDownload(Response response) {
    when(
      mockDio.download(
        any,
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((_) async => response);
  }

  void mockGetWithProgress(
    Response response, {
    int receiveCount = 0,
    int receiveTotal = 0,
  }) {
    when(
      mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((invocation) async {
      final onReceive =
          invocation.namedArguments[#onReceiveProgress] as ProgressCallback?;
      if (onReceive != null && receiveTotal > 0) {
        onReceive(receiveCount, receiveTotal);
      }
      return response;
    });
  }

  void mockPostWithProgress(
    Response response, {
    int sendCount = 0,
    int sendTotal = 0,
    int receiveCount = 0,
    int receiveTotal = 0,
  }) {
    when(
      mockDio.post(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((invocation) async {
      final onSend =
          invocation.namedArguments[#onSendProgress] as ProgressCallback?;
      final onReceive =
          invocation.namedArguments[#onReceiveProgress] as ProgressCallback?;
      if (onSend != null && sendTotal > 0) {
        onSend(sendCount, sendTotal);
      }
      if (onReceive != null && receiveTotal > 0) {
        onReceive(receiveCount, receiveTotal);
      }
      return response;
    });
  }

  void mockPutWithProgress(
    Response response, {
    int sendCount = 0,
    int sendTotal = 0,
    int receiveCount = 0,
    int receiveTotal = 0,
  }) {
    when(
      mockDio.put(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((invocation) async {
      final onSend =
          invocation.namedArguments[#onSendProgress] as ProgressCallback?;
      final onReceive =
          invocation.namedArguments[#onReceiveProgress] as ProgressCallback?;
      if (onSend != null && sendTotal > 0) {
        onSend(sendCount, sendTotal);
      }
      if (onReceive != null && receiveTotal > 0) {
        onReceive(receiveCount, receiveTotal);
      }
      return response;
    });
  }

  void mockPatchWithProgress(
    Response response, {
    int sendCount = 0,
    int sendTotal = 0,
    int receiveCount = 0,
    int receiveTotal = 0,
  }) {
    when(
      mockDio.patch(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((invocation) async {
      final onSend =
          invocation.namedArguments[#onSendProgress] as ProgressCallback?;
      final onReceive =
          invocation.namedArguments[#onReceiveProgress] as ProgressCallback?;
      if (onSend != null && sendTotal > 0) {
        onSend(sendCount, sendTotal);
      }
      if (onReceive != null && receiveTotal > 0) {
        onReceive(receiveCount, receiveTotal);
      }
      return response;
    });
  }

  void mockDownloadWithProgress(
    Response response, {
    int receiveCount = 0,
    int receiveTotal = 0,
  }) {
    when(
      mockDio.download(
        any,
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((invocation) async {
      final onReceive =
          invocation.namedArguments[#onReceiveProgress] as ProgressCallback?;
      if (onReceive != null && receiveTotal > 0) {
        onReceive(receiveCount, receiveTotal);
      }
      return response;
    });
  }

  Future<void> expectSuccess<T>(
    CancelableOperation<dynamic> operation,
    T expectedData,
  ) async {
    final result = await operation.value;
    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail('Expected success but got failure: $failure'),
      (data) => expect(data, equals(expectedData)),
    );
  }

  Future<void> expectFailure(
    CancelableOperation<dynamic> operation,
    NetworkFailure expectedFailure,
  ) async {
    final result = await operation.value;
    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, equals(expectedFailure)),
      (data) => fail('Expected failure but got success: $data'),
    );
  }

  MockFormDataAdapter createMockFormData() {
    final mockFormData = MockFormDataAdapter();
    final formData = FormData.fromMap({'key': 'value'});
    when(mockFormData.create()).thenReturn(formData);
    return mockFormData;
  }

  Options captureOptions(VerificationResult verification) {
    final captured = verification.captured;
    expect(captured.length, greaterThan(0));
    return captured.first as Options;
  }

  group('DioApiHandler', () {
    group('GET requests', () {
      test('should return success response with parsed data', () async {
        final responseData = {'id': 1, 'name': 'Test'};
        mockDioGet(createSuccessResponse(responseData));

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        await expectSuccess(operation, responseData);
        verify(
          mockDio.get(
            '/test',
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle query parameters', () async {
        final queryParams = {'page': 1, 'limit': 10};
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          queryParameters: queryParams,
        );
        await operation.value;

        verify(
          mockDio.get(
            '/test',
            queryParameters: queryParams,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle progress callback', () async {
        double? receivedProgress;
        mockGetWithProgress(
          createSuccessResponse(),
          receiveCount: 50,
          receiveTotal: 100,
        );

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          onReceiveProgress: (progress) => receivedProgress = progress,
        );
        await operation.value;

        expect(receivedProgress, equals(0.5));
      });

      test('should handle caching when shouldCache is true', () async {
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          shouldCache: true,
        );
        await operation.value;

        final options = captureOptions(
          verify(
            mockDio.get(
              '/test',
              queryParameters: anyNamed('queryParameters'),
              options: captureAnyNamed('options'),
              cancelToken: anyNamed('cancelToken'),
              onReceiveProgress: anyNamed('onReceiveProgress'),
            ),
          ),
        );

        expect(options.extra, isNotNull);
        expect(options.extra!['isAuthorized'], equals(true));
        expect(options.extra!.containsKey('cache-policy'), isTrue);
      });

      test('should handle authorization flag', () async {
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          isAuthorized: false,
        );
        await operation.value;

        verify(
          mockDio.get(
            '/test',
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == false,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle DioException and map to NetworkFailure', () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );
        const networkFailure = RequestTimeoutFailure('Request timed out');

        when(
          mockDio.get(
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(dioException);

        when(
          mockExceptionMapper.mapException(dioException, any),
        ).thenReturn(networkFailure);

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        await expectFailure(operation, networkFailure);
      });

      test('should return cancelable operation', () async {
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        expect(operation, isA<CancelableOperation>());
        expect(operation.isCanceled, isFalse);

        operation.cancel();
        expect(operation.isCanceled, isTrue);
      });
    });

    group('POST requests', () {
      test('should return success response with parsed data', () async {
        final requestBody = {'name': 'Test'};
        final responseData = {'id': 1, 'name': 'Test'};
        mockDioPost(createSuccessResponse(responseData));

        final operation = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: requestBody,
        );

        await expectSuccess(operation, responseData);
        verify(
          mockDio.post(
            '/test',
            data: requestBody,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle form data', () async {
        final mockFormData = createMockFormData();
        mockDioPost(createSuccessResponse());

        final operation = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await operation.value;

        verify(mockFormData.create()).called(1);
        verify(
          mockDio.post(
            '/test',
            data: any,
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.contentType == Headers.multipartFormDataContentType,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle progress callbacks', () async {
        double? sendProgress;
        double? receiveProgress;
        mockPostWithProgress(
          createSuccessResponse(),
          sendCount: 25,
          sendTotal: 100,
          receiveCount: 75,
          receiveTotal: 100,
        );

        final operation = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
          onSendProgress: (progress) => sendProgress = progress,
          onReceiveProgress: (progress) => receiveProgress = progress,
        );
        await operation.value;

        expect(sendProgress, equals(0.25));
        expect(receiveProgress, equals(0.75));
      });
    });

    group('DELETE requests', () {
      test('should return success response', () async {
        final responseData = {'deleted': true};
        mockDioDelete(createSuccessResponse(responseData));

        final operation = apiHandler.delete<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        await operation.value;

        expect((await operation.value).isRight(), isTrue);
        verify(
          mockDio.delete(
            '/test',
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });
    });

    group('PUT requests', () {
      test('should return success response', () async {
        final requestBody = {'name': 'Updated'};
        final responseData = {'id': 1, 'name': 'Updated'};
        mockDioPut(createSuccessResponse(responseData));

        final operation = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: requestBody,
        );
        await operation.value;

        expect((await operation.value).isRight(), isTrue);
        verify(
          mockDio.put(
            '/test',
            data: requestBody,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle form data', () async {
        final mockFormData = createMockFormData();
        mockDioPut(createSuccessResponse());

        final operation = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await operation.value;

        verify(mockFormData.create()).called(1);
      });

      test('should handle progress callbacks', () async {
        double? sendProgress;
        double? receiveProgress;
        mockPutWithProgress(
          createSuccessResponse(),
          sendCount: 30,
          sendTotal: 100,
          receiveCount: 70,
          receiveTotal: 100,
        );

        final operation = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
          onSendProgress: (progress) => sendProgress = progress,
          onReceiveProgress: (progress) => receiveProgress = progress,
        );
        await operation.value;

        expect(sendProgress, equals(0.3));
        expect(receiveProgress, equals(0.7));
      });
    });

    group('PATCH requests', () {
      test('should return success response', () async {
        final requestBody = {'name': 'Patched'};
        final responseData = {'id': 1, 'name': 'Patched'};
        mockDioPatch(createSuccessResponse(responseData));

        final operation = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: requestBody,
        );
        await operation.value;

        expect((await operation.value).isRight(), isTrue);
        verify(
          mockDio.patch(
            '/test',
            data: requestBody,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle form data', () async {
        final mockFormData = createMockFormData();
        mockDioPatch(createSuccessResponse());

        final operation = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await operation.value;

        verify(mockFormData.create()).called(1);
      });

      test('should handle progress callbacks', () async {
        double? sendProgress;
        double? receiveProgress;
        mockPatchWithProgress(
          createSuccessResponse(),
          sendCount: 40,
          sendTotal: 100,
          receiveCount: 60,
          receiveTotal: 100,
        );

        final operation = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
          onSendProgress: (progress) => sendProgress = progress,
          onReceiveProgress: (progress) => receiveProgress = progress,
        );
        await operation.value;

        expect(sendProgress, equals(0.4));
        expect(receiveProgress, equals(0.6));
      });
    });

    group('DOWNLOAD requests', () {
      test('should return success response', () async {
        mockDioDownload(createSuccessResponse({'download': 'complete'}));

        final operation = apiHandler.download<Map<String, dynamic>>(
          'https://example.com/file',
          '/path/to/save',
          parser: (json) => json,
        );
        await operation.value;

        expect((await operation.value).isRight(), isTrue);
        verify(
          mockDio.download(
            'https://example.com/file',
            '/path/to/save',
            options: argThat(
              predicate<Options>(
                (options) => options.responseType == ResponseType.stream,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle progress callback', () async {
        double? receivedProgress;
        mockDownloadWithProgress(
          createSuccessResponse({'download': 'complete'}),
          receiveCount: 50,
          receiveTotal: 100,
        );

        final operation = apiHandler.download<Map<String, dynamic>>(
          'https://example.com/file',
          '/path/to/save',
          parser: (json) => json,
          onReceiveProgress: (progress) => receivedProgress = progress,
        );
        await operation.value;

        expect(receivedProgress, equals(0.5));
      });
    });

    group('Error handling', () {
      test(
        'should handle generic Exception and return NoInternetConnectionFailure',
        () async {
          final exception = Exception('Generic error');
          when(
            mockDio.get(
              any,
              queryParameters: anyNamed('queryParameters'),
              options: anyNamed('options'),
              cancelToken: anyNamed('cancelToken'),
              onReceiveProgress: anyNamed('onReceiveProgress'),
            ),
          ).thenThrow(exception);

          final operation = apiHandler.get<Map<String, dynamic>>(
            '/test',
            parser: (json) => json,
          );
          final result = await operation.value;

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(failure, isA<NoInternetConnectionFailure>());
            expect(failure.message, contains('Generic error'));
          }, (data) => fail('Expected failure but got success: $data'));
        },
      );

      test('should handle cancelled DioException by rethrowing', () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.cancel,
        );

        when(
          mockDio.get(
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(dioException);

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        await expectLater(operation.value, throwsA(isA<DioException>()));
      });
    });

    group('Cancellation', () {
      test('should return cancelable operation', () async {
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        expect(operation, isA<CancelableOperation>());
        expect(operation.isCanceled, isFalse);

        operation.cancel();
        expect(operation.isCanceled, isTrue);
      });

      test('should not cancel if token is already cancelled', () async {
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        operation.cancel();
        operation.cancel();

        expect(operation.isCanceled, isTrue);
      });
    });

    group('Parser functionality', () {
      test('should parse response to custom type', () async {
        final responseData = {'id': 1, 'name': 'Test'};
        mockDioGet(createSuccessResponse(responseData));

        final operation = apiHandler.get<TestModel>(
          '/test',
          parser: (json) => TestModel.fromJson(json),
        );
        final result = await operation.value;

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (data) {
            expect(data.id, equals(1));
            expect(data.name, equals('Test'));
          },
        );
      });
    });

    group('Options building', () {
      test('should build options with JSON content type by default', () async {
        mockDioPost(createSuccessResponse());

        final operation = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
        );
        await operation.value;

        verify(
          mockDio.post(
            '/test',
            data: {'key': 'value'},
            options: argThat(
              predicate<Options>(
                (options) => options.contentType == Headers.jsonContentType,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test(
        'should build options with multipart content type for form data',
        () async {
          final mockFormData = createMockFormData();
          mockDioPost(createSuccessResponse());

          final operation = apiHandler.post<Map<String, dynamic>>(
            '/test',
            parser: (json) => json,
            formData: mockFormData,
          );
          await operation.value;

          verify(
            mockDio.post(
              '/test',
              data: any,
              options: argThat(
                predicate<Options>(
                  (options) =>
                      options.contentType ==
                      Headers.multipartFormDataContentType,
                ),
                named: 'options',
              ),
              cancelToken: anyNamed('cancelToken'),
            ),
          ).called(1);
        },
      );

      test('should not add cache options when shouldCache is false', () async {
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        await operation.value;

        verify(
          mockDio.get(
            '/test',
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == true &&
                    !options.extra!.containsKey('cache-policy'),
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });
    });

    group('Edge cases', () {
      test('should handle empty query parameters', () async {
        mockDioGet(createSuccessResponse());

        final operation = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          queryParameters: {},
        );
        await operation.value;

        verify(
          mockDio.get(
            '/test',
            queryParameters: {},
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle null body in POST request', () async {
        mockDioPost(createSuccessResponse());

        final operation = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        await operation.value;

        verify(
          mockDio.post(
            '/test',
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle PUT with null body and formData', () async {
        final mockFormData = createMockFormData();
        mockDioPut(createSuccessResponse());

        final operation = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await operation.value;

        verify(mockFormData.create()).called(1);
        verify(
          mockDio.put(
            '/test',
            data: any,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle download with query parameters', () async {
        final queryParams = {'token': 'abc123'};
        mockDioDownload(createSuccessResponse({'download': 'complete'}));

        final operation = apiHandler.download<Map<String, dynamic>>(
          'https://example.com/file',
          '/path/to/save',
          parser: (json) => json,
          queryParameters: queryParams,
        );
        await operation.value;

        verify(
          mockDio.download(
            'https://example.com/file',
            '/path/to/save',
            queryParameters: queryParams,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });
    });
  });
}
