import 'package:coore/coore.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
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

    // Register CancelRequestManager in GetIt for testing
    if (getIt.isRegistered<CancelRequestManager>()) {
      getIt.unregister<CancelRequestManager>();
    }
    getIt.registerSingleton<CancelRequestManager>(CancelRequestManagerImpl());

    apiHandler = DioApiHandler(mockDio, mockExceptionMapper);
  });

  tearDown(() {
    if (getIt.isRegistered<CacheStore>()) {
      getIt.unregister<CacheStore>();
    }
    if (getIt.isRegistered<CancelRequestManager>()) {
      getIt.unregister<CancelRequestManager>();
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
      mockDio.get<dynamic>(
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
      mockDio.post<dynamic>(
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
      mockDio.put<dynamic>(
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
      mockDio.patch<dynamic>(
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
      mockDio.delete<dynamic>(
        any,
        data: anyNamed('data'),
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
        deleteOnError: anyNamed('deleteOnError'),
        lengthHeader: anyNamed('lengthHeader'),
        data: anyNamed('data'),
        fileAccessMode: anyNamed('fileAccessMode'),
      ),
    ).thenAnswer((_) async => response);
  }

  void mockGetWithProgress(
    Response response, {
    int receiveCount = 0,
    int receiveTotal = 0,
  }) {
    when(
      mockDio.get<dynamic>(
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
      mockDio.post<dynamic>(
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
      mockDio.put<dynamic>(
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
      mockDio.patch<dynamic>(
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
        deleteOnError: anyNamed('deleteOnError'),
        lengthHeader: anyNamed('lengthHeader'),
        data: anyNamed('data'),
        fileAccessMode: anyNamed('fileAccessMode'),
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

  Future<void> expectSuccess<T>(Future<dynamic> future, T expectedData) async {
    final result = await future;
    expect(result.isRight(), isTrue);
    (result as Either<Failure, dynamic>).fold(
      (Failure failure) {
        fail('Expected success but got failure: $failure');
      },
      (dynamic data) {
        expect(data as T, equals(expectedData));
      },
    );
  }

  Future<void> expectFailure(
    Future<dynamic> future,
    Failure expectedFailure,
  ) async {
    final result = await future;
    expect(result.isLeft(), isTrue);
    (result as Either<Failure, dynamic>).fold(
      (Failure failure) {
        expect(failure, equals(expectedFailure));
      },
      (dynamic data) {
        fail('Expected failure but got success: $data');
      },
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

  // Helper methods for creating DioExceptions
  DioException createDioException({
    DioExceptionType type = DioExceptionType.connectionTimeout,
    int? statusCode,
    Map<String, dynamic>? responseData,
  }) {
    return DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: type,
      response: statusCode != null
          ? Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: statusCode,
              data: responseData,
            )
          : null,
    );
  }

  // Helper method to mock DioException for any HTTP method
  void mockDioExceptionForMethod(String method, DioException exception) {
    switch (method.toUpperCase()) {
      case 'GET':
        when(
          mockDio.get<dynamic>(
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(exception);
        break;
      case 'POST':
        when(
          mockDio.post<dynamic>(
            any,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(exception);
        break;
      case 'PUT':
        when(
          mockDio.put<dynamic>(
            any,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(exception);
        break;
      case 'PATCH':
        when(
          mockDio.patch<dynamic>(
            any,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(exception);
        break;
      case 'DELETE':
        when(
          mockDio.delete<dynamic>(
            any,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).thenThrow(exception);
        break;
      case 'DOWNLOAD':
        when(
          mockDio.download(
            any,
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
            deleteOnError: anyNamed('deleteOnError'),
            lengthHeader: anyNamed('lengthHeader'),
            data: anyNamed('data'),
            fileAccessMode: anyNamed('fileAccessMode'),
          ),
        ).thenThrow(exception);
        break;
    }
  }

  // Helper method to test cancellation for any HTTP method
  Future<void> testCancellationForMethod(
    String method, {
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    String? url,
    String? downloadPath,
  }) async {
    switch (method.toUpperCase()) {
      case 'GET':
        mockDioGet(createSuccessResponse());
        break;
      case 'POST':
        mockDioPost(createSuccessResponse());
        break;
      case 'PUT':
        mockDioPut(createSuccessResponse());
        break;
      case 'PATCH':
        mockDioPatch(createSuccessResponse());
        break;
      case 'DELETE':
        mockDioDelete(createSuccessResponse());
        break;
      case 'DOWNLOAD':
        mockDioDownload(createSuccessResponse());
        break;
    }

    final cancelManager = getIt<CancelRequestManager>();
    final requestId = cancelManager.registerRequest();

    switch (method.toUpperCase()) {
      case 'GET':
        apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          requestId: requestId,
        );
        break;
      case 'POST':
        apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
          requestId: requestId,
        );
        break;
      case 'PUT':
        apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
          requestId: requestId,
        );
        break;
      case 'PATCH':
        apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
          requestId: requestId,
        );
        break;
      case 'DELETE':
        apiHandler.delete<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          requestId: requestId,
        );
        break;
      case 'DOWNLOAD':
        apiHandler.download<Map<String, dynamic>>(
          url ?? 'https://example.com/file',
          downloadPath ?? '/path/to/save',
          parser: (json) => json,
          requestId: requestId,
        );
        break;
    }

    cancelManager.cancelRequest(requestId);
    expect(cancelManager.getCancelToken(requestId)?.isCancelled, isTrue);
    cancelManager.unregisterRequest(requestId);
  }

  // Helper method to test authorization flag for any HTTP method
  Future<void> testAuthorizationFlagForMethod(
    String method, {
    required bool isAuthorized,
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
  }) async {
    switch (method.toUpperCase()) {
      case 'GET':
        mockDioGet(createSuccessResponse());
        break;
      case 'POST':
        mockDioPost(createSuccessResponse());
        break;
      case 'PUT':
        mockDioPut(createSuccessResponse());
        break;
      case 'PATCH':
        mockDioPatch(createSuccessResponse());
        break;
      case 'DELETE':
        mockDioDelete(createSuccessResponse());
        break;
      case 'DOWNLOAD':
        mockDioDownload(createSuccessResponse());
        break;
    }

    Future<dynamic> future;
    switch (method.toUpperCase()) {
      case 'GET':
        future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          isAuthorized: isAuthorized,
        );
        break;
      case 'POST':
        future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
          isAuthorized: isAuthorized,
        );
        break;
      case 'PUT':
        future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
          isAuthorized: isAuthorized,
        );
        break;
      case 'PATCH':
        future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
          isAuthorized: isAuthorized,
        );
        break;
      case 'DELETE':
        future = apiHandler.delete<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          isAuthorized: isAuthorized,
        );
        break;
      case 'DOWNLOAD':
        future = apiHandler.download<Map<String, dynamic>>(
          'https://example.com/file',
          '/path/to/save',
          parser: (json) => json,
          isAuthorized: isAuthorized,
        );
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    await future;

    // Verify authorization flag was set correctly
    switch (method.toUpperCase()) {
      case 'GET':
        verify(
          mockDio.get<dynamic>(
            '/test',
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == isAuthorized,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
        break;
      case 'POST':
        verify(
          mockDio.post<dynamic>(
            '/test',
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == isAuthorized,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).called(1);
        break;
      case 'PUT':
        verify(
          mockDio.put<dynamic>(
            '/test',
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == isAuthorized,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).called(1);
        break;
      case 'PATCH':
        verify(
          mockDio.patch<dynamic>(
            '/test',
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == isAuthorized,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).called(1);
        break;
      case 'DELETE':
        verify(
          mockDio.delete<dynamic>(
            '/test',
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == isAuthorized,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
        break;
      case 'DOWNLOAD':
        verify(
          mockDio.download(
            'https://example.com/file',
            '/path/to/save',
            options: argThat(
              predicate<Options>(
                (options) =>
                    options.extra != null &&
                    options.extra!['isAuthorized'] == isAuthorized,
              ),
              named: 'options',
            ),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
        break;
    }
  }

  // Helper method to test query parameters for any HTTP method
  Future<void> testQueryParametersForMethod(
    String method,
    Map<String, dynamic> queryParams, {
    Map<String, dynamic>? body,
  }) async {
    switch (method.toUpperCase()) {
      case 'GET':
        mockDioGet(createSuccessResponse());
        break;
      case 'POST':
        mockDioPost(createSuccessResponse());
        break;
      case 'PUT':
        mockDioPut(createSuccessResponse());
        break;
      case 'PATCH':
        mockDioPatch(createSuccessResponse());
        break;
      case 'DELETE':
        mockDioDelete(createSuccessResponse());
        break;
    }

    Future<dynamic> future;
    switch (method.toUpperCase()) {
      case 'GET':
        future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          queryParameters: queryParams,
        );
        break;
      case 'POST':
        future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          queryParameters: queryParams,
        );
        break;
      case 'PUT':
        future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          queryParameters: queryParams,
        );
        break;
      case 'PATCH':
        future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          queryParameters: queryParams,
        );
        break;
      case 'DELETE':
        future = apiHandler.delete<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          queryParameters: queryParams,
        );
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    await future;

    // Verify query parameters were passed correctly
    switch (method.toUpperCase()) {
      case 'GET':
        verify(
          mockDio.get<dynamic>(
            '/test',
            queryParameters: queryParams,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).called(1);
        break;
      case 'POST':
        verify(
          mockDio.post<dynamic>(
            '/test',
            data: anyNamed('data'),
            queryParameters: queryParams,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).called(1);
        break;
      case 'PUT':
        verify(
          mockDio.put<dynamic>(
            '/test',
            data: anyNamed('data'),
            queryParameters: queryParams,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).called(1);
        break;
      case 'PATCH':
        verify(
          mockDio.patch<dynamic>(
            '/test',
            data: anyNamed('data'),
            queryParameters: queryParams,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).called(1);
        break;
      case 'DELETE':
        verify(
          mockDio.delete<dynamic>(
            '/test',
            queryParameters: queryParams,
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
        break;
    }
  }

  // Helper method to test error handling with failure mapping
  Future<void> testErrorHandlingForMethod(
    String method,
    Failure expectedFailure,
    DioException dioException, {
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    String? url,
    String? downloadPath,
  }) async {
    mockDioExceptionForMethod(method, dioException);
    when(
      mockExceptionMapper.mapException(dioException, any),
    ).thenReturn(expectedFailure);

    Future<dynamic> future;
    switch (method.toUpperCase()) {
      case 'GET':
        future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        break;
      case 'POST':
        future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
        );
        break;
      case 'PUT':
        future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
        );
        break;
      case 'PATCH':
        future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
        );
        break;
      case 'DELETE':
        future = apiHandler.delete<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        break;
      case 'DOWNLOAD':
        future = apiHandler.download<Map<String, dynamic>>(
          url ?? 'https://example.com/file',
          downloadPath ?? '/path/to/save',
          parser: (json) => json,
        );
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    await expectFailure(future, expectedFailure);
  }

  // Helper method to test cancelled DioException
  Future<void> testCancelledExceptionForMethod(
    String method, {
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    String? url,
    String? downloadPath,
  }) async {
    final dioException = createDioException(type: DioExceptionType.cancel);
    mockDioExceptionForMethod(method, dioException);

    Future<dynamic> future;
    switch (method.toUpperCase()) {
      case 'GET':
        future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        break;
      case 'POST':
        future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
        );
        break;
      case 'PUT':
        future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
        );
        break;
      case 'PATCH':
        future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: body,
          formData: formData,
        );
        break;
      case 'DELETE':
        future = apiHandler.delete<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        break;
      case 'DOWNLOAD':
        future = apiHandler.download<Map<String, dynamic>>(
          url ?? 'https://example.com/file',
          downloadPath ?? '/path/to/save',
          parser: (json) => json,
        );
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    await expectLater(future, throwsA(isA<DioException>()));
  }

  // Helper method to test formData priority over body
  Future<void> testFormDataPriorityForMethod(String method) async {
    final mockFormData = createMockFormData();
    Future<dynamic> future;

    switch (method.toUpperCase()) {
      case 'POST':
        mockDioPost(createSuccessResponse());
        future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'should': 'be ignored'},
          formData: mockFormData,
        );
        break;
      case 'PUT':
        mockDioPut(createSuccessResponse());
        future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'should': 'be ignored'},
          formData: mockFormData,
        );
        break;
      case 'PATCH':
        mockDioPatch(createSuccessResponse());
        future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'should': 'be ignored'},
          formData: mockFormData,
        );
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    await future;

    verify(mockFormData.create()).called(1);

    final verifyCall = method.toUpperCase() == 'POST'
        ? mockDio.post<dynamic>
        : method.toUpperCase() == 'PUT'
        ? mockDio.put<dynamic>
        : mockDio.patch<dynamic>;

    verify(
      verifyCall(
        '/test',
        data: argThat(isNotNull, named: 'data'),
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
  }

  group('DioApiHandler', () {
    group('GET requests', () {
      test('should return success response with parsed data', () async {
        final responseData = {'id': 1, 'name': 'Test'};
        mockDioGet(createSuccessResponse(responseData));

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        await expectSuccess(future, responseData);
        verify(
          mockDio.get<dynamic>(
            '/test',
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle query parameters', () async {
        final queryParams = {'page': 1, 'limit': 10};
        mockDioGet(createSuccessResponse());

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          queryParameters: queryParams,
        );
        await future;

        verify(
          mockDio.get<dynamic>(
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

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          onReceiveProgress: (progress) => receivedProgress = progress,
        );
        await future;

        expect(receivedProgress, equals(0.5));
      });

      test('should handle caching when shouldCache is true', () async {
        mockDioGet(createSuccessResponse());

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          shouldCache: true,
        );
        await future;

        final options = captureOptions(
          verify(
            mockDio.get<dynamic>(
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
        // Check if cache options are present (CacheOptions.toExtra() adds multiple keys)
        expect(
          options.extra!.keys.any((key) => key.contains('cache')),
          isTrue,
          reason: 'Cache options should be present in extra map',
        );
      });

      test('should handle authorization flag', () async {
        mockDioGet(createSuccessResponse());

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          isAuthorized: false,
        );
        await future;

        verify(
          mockDio.get<dynamic>(
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

      test('should handle DioException and map to Failure', () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );
        const connectionFailure = ConnectionFailure(
          message: 'Request timed out',
          code: 'TIMEOUT',
        );

        when(
          mockDio.get<dynamic>(
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(dioException);

        when(
          mockExceptionMapper.mapException(dioException, any),
        ).thenReturn(connectionFailure);

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        await expectFailure(future, connectionFailure);
      });

      test('should return Future for cancellation support', () async {
        mockDioGet(createSuccessResponse());

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        expect(future, isA<Future>());
        // Future can be cancelled via CancelRequestManager with requestId
      });
    });

    group('POST requests', () {
      test('should return success response with parsed data', () async {
        final requestBody = {'name': 'Test'};
        final responseData = {'id': 1, 'name': 'Test'};
        mockDioPost(createSuccessResponse(responseData));

        final future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: requestBody,
        );

        await expectSuccess(future, responseData);
        verify(
          mockDio.post<dynamic>(
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

        final future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await future;

        verify(mockFormData.create()).called(1);
        verify(
          mockDio.post<dynamic>(
            '/test',
            data: argThat(isNotNull, named: 'data'),
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

        final future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
          onSendProgress: (progress) => sendProgress = progress,
          onReceiveProgress: (progress) => receiveProgress = progress,
        );
        await future;

        expect(sendProgress, equals(0.25));
        expect(receiveProgress, equals(0.75));
      });
    });

    group('DELETE requests', () {
      test('should return success response', () async {
        final responseData = {'deleted': true};
        mockDioDelete(createSuccessResponse(responseData));

        final future = apiHandler.delete<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        final result = await future;

        expect(result.isRight(), isTrue);
        verify(
          mockDio.delete<dynamic>(
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

        final future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: requestBody,
        );
        final result = await future;

        expect(result.isRight(), isTrue);
        verify(
          mockDio.put<dynamic>(
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

        final future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await future;

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

        final future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
          onSendProgress: (progress) => sendProgress = progress,
          onReceiveProgress: (progress) => receiveProgress = progress,
        );
        await future;

        expect(sendProgress, equals(0.3));
        expect(receiveProgress, equals(0.7));
      });
    });

    group('PATCH requests', () {
      test('should return success response', () async {
        final requestBody = {'name': 'Patched'};
        final responseData = {'id': 1, 'name': 'Patched'};
        mockDioPatch(createSuccessResponse(responseData));

        final future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: requestBody,
        );
        final result = await future;

        expect(result.isRight(), isTrue);
        verify(
          mockDio.patch<dynamic>(
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

        final future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await future;

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

        final future = apiHandler.patch<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
          onSendProgress: (progress) => sendProgress = progress,
          onReceiveProgress: (progress) => receiveProgress = progress,
        );
        await future;

        expect(sendProgress, equals(0.4));
        expect(receiveProgress, equals(0.6));
      });
    });

    group('DOWNLOAD requests', () {
      test('should return success response', () async {
        mockDioDownload(createSuccessResponse({'download': 'complete'}));

        final future = apiHandler.download<Map<String, dynamic>>(
          'https://example.com/file',
          '/path/to/save',
          parser: (json) => json,
        );
        final result = await future;

        expect(result.isRight(), isTrue);
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

        final future = apiHandler.download<Map<String, dynamic>>(
          'https://example.com/file',
          '/path/to/save',
          parser: (json) => json,
          onReceiveProgress: (progress) => receivedProgress = progress,
        );
        await future;

        expect(receivedProgress, equals(0.5));
      });
    });

    group('Error handling', () {
      test(
        'should handle generic Exception and return UnknownFailure',
        () async {
          final exception = Exception('Generic error');
          when(
            mockDio.get<dynamic>(
              any,
              queryParameters: anyNamed('queryParameters'),
              options: anyNamed('options'),
              cancelToken: anyNamed('cancelToken'),
              onReceiveProgress: anyNamed('onReceiveProgress'),
            ),
          ).thenThrow(exception);

          final future = apiHandler.get<Map<String, dynamic>>(
            '/test',
            parser: (json) => json,
          );
          final result = await future;

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(failure, isA<UnknownFailure>());
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
          mockDio.get<dynamic>(
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(dioException);

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        await expectLater(future, throwsA(isA<DioException>()));
      });

      test('should handle DioException in POST request', () async {
        const connectionFailure = ConnectionFailure(
          message: 'Connection failed',
          code: 'CONNECTION_ERROR',
        );
        final dioException = createDioException();

        await testErrorHandlingForMethod(
          'POST',
          connectionFailure,
          dioException,
          body: {'key': 'value'},
        );
      });

      test('should handle DioException in PUT request', () async {
        const serverFailure = ServerFailure(
          message: 'Server error',
          statusCode: 500,
        );
        final dioException = createDioException(
          type: DioExceptionType.badResponse,
          statusCode: 500,
        );

        await testErrorHandlingForMethod(
          'PUT',
          serverFailure,
          dioException,
          body: {'key': 'value'},
        );
      });

      test('should handle DioException in PATCH request', () async {
        const authFailure = AuthFailure(message: 'Unauthorized');
        final dioException = createDioException(
          type: DioExceptionType.badResponse,
          statusCode: 401,
        );

        await testErrorHandlingForMethod(
          'PATCH',
          authFailure,
          dioException,
          body: {'key': 'value'},
        );
      });

      test('should handle DioException in DELETE request', () async {
        const serverFailure = ServerFailure(
          message: 'Not found',
          statusCode: 404,
        );
        final dioException = createDioException(
          type: DioExceptionType.badResponse,
          statusCode: 404,
        );

        await testErrorHandlingForMethod('DELETE', serverFailure, dioException);
      });

      test('should handle DioException in DOWNLOAD request', () async {
        const connectionFailure = ConnectionFailure(
          message: 'Download failed',
          code: 'DOWNLOAD_ERROR',
        );
        final dioException = createDioException();

        await testErrorHandlingForMethod(
          'DOWNLOAD',
          connectionFailure,
          dioException,
        );
      });

      test('should handle generic Exception in POST request', () async {
        final exception = Exception('Generic POST error');
        when(
          mockDio.post<dynamic>(
            any,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenThrow(exception);

        final future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
        );
        final result = await future;

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Generic POST error'));
        }, (data) => fail('Expected failure but got success: $data'));
      });

      test('should handle cancelled DioException in POST request', () async {
        await testCancelledExceptionForMethod('POST', body: {'key': 'value'});
      });

      test('should handle cancelled DioException in PUT request', () async {
        await testCancelledExceptionForMethod('PUT', body: {'key': 'value'});
      });

      test('should handle cancelled DioException in PATCH request', () async {
        await testCancelledExceptionForMethod('PATCH', body: {'key': 'value'});
      });

      test('should handle cancelled DioException in DELETE request', () async {
        await testCancelledExceptionForMethod('DELETE');
      });

      test(
        'should handle cancelled DioException in DOWNLOAD request',
        () async {
          await testCancelledExceptionForMethod('DOWNLOAD');
        },
      );

      test('should handle ValidationFailure in POST request', () async {
        const validationFailure = ValidationFailure(
          errors: {'email': 'Invalid email format'},
        );
        final dioException = createDioException(
          type: DioExceptionType.badResponse,
          statusCode: 422,
        );

        await testErrorHandlingForMethod(
          'POST',
          validationFailure,
          dioException,
          body: {'email': 'invalid'},
        );
      });

      test('should handle UnauthorizedFailure in DELETE request', () async {
        const unauthorizedFailure = UnauthorizedFailure();
        final dioException = createDioException(
          type: DioExceptionType.badResponse,
          statusCode: 403,
        );

        await testErrorHandlingForMethod(
          'DELETE',
          unauthorizedFailure,
          dioException,
        );
      });

      test('should handle BusinessFailure in PUT request', () async {
        const businessFailure = BusinessFailure(message: 'Insufficient funds');
        final dioException = createDioException(
          type: DioExceptionType.badResponse,
          statusCode: 200,
          responseData: {'error': 'Insufficient funds'},
        );

        await testErrorHandlingForMethod(
          'PUT',
          businessFailure,
          dioException,
          body: {'amount': 1000},
        );
      });

      test(
        'should handle FormatFailure for invalid response data type',
        () async {
          // Response with data that is neither List, Map, nor String
          final response = Response<dynamic>(
            data: 12345, // Integer - invalid type
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          );

          mockDioGet(response);

          final future = apiHandler.get<Map<String, dynamic>>(
            '/test',
            parser: (json) => json,
          );

          final result = await future;
          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(failure, isA<FormatFailure>());
            expect(failure.message, equals('Invalid response data'));
          }, (data) => fail('Expected FormatFailure but got success: $data'));
        },
      );

      test('should handle null response data', () async {
        final response = Response<dynamic>(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test'),
        );

        mockDioGet(response);

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );

        final result = await future;
        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<FormatFailure>());
          expect(failure.message, equals('Invalid response data'));
        }, (data) => fail('Expected FormatFailure but got success: $data'));
      });

      test('should prioritize formData over body in POST request', () async {
        await testFormDataPriorityForMethod('POST');
      });

      test('should prioritize formData over body in PUT request', () async {
        await testFormDataPriorityForMethod('PUT');
      });

      test('should prioritize formData over body in PATCH request', () async {
        await testFormDataPriorityForMethod('PATCH');
      });

      test('should handle network timeout in GET request', () async {
        const connectionFailure = ConnectionFailure(
          message: 'Request timed out',
          code: 'TIMEOUT',
        );
        final dioException = createDioException(
          type: DioExceptionType.receiveTimeout,
        );

        await testErrorHandlingForMethod(
          'GET',
          connectionFailure,
          dioException,
        );
      });

      test('should handle network timeout in POST request', () async {
        const connectionFailure = ConnectionFailure(
          message: 'Request timed out',
          code: 'TIMEOUT',
        );
        final dioException = createDioException(
          type: DioExceptionType.sendTimeout,
        );

        await testErrorHandlingForMethod(
          'POST',
          connectionFailure,
          dioException,
          body: {'key': 'value'},
        );
      });
    });

    group('Cancellation', () {
      test('should support cancellation via requestId', () async {
        mockDioGet(createSuccessResponse());

        final cancelManager = getIt<CancelRequestManager>();
        final requestId = cancelManager.registerRequest();

        apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          requestId: requestId,
        );

        // Cancel the request
        cancelManager.cancelRequest(requestId);

        // Verify cancellation was called
        expect(cancelManager.getCancelToken(requestId)?.isCancelled, isTrue);

        // Cleanup
        cancelManager.unregisterRequest(requestId);
      });

      test('should not cancel if token is already cancelled', () async {
        mockDioGet(createSuccessResponse());

        final cancelManager = getIt<CancelRequestManager>();
        final requestId = cancelManager.registerRequest();

        cancelManager.cancelRequest(requestId);
        cancelManager.cancelRequest(requestId); // Second cancel should be safe

        expect(cancelManager.getCancelToken(requestId)?.isCancelled, isTrue);

        // Cleanup
        cancelManager.unregisterRequest(requestId);
      });

      test('should support cancellation via requestId for POST', () async {
        await testCancellationForMethod('POST', body: {'key': 'value'});
      });

      test('should support cancellation via requestId for PUT', () async {
        await testCancellationForMethod('PUT', body: {'key': 'value'});
      });

      test('should support cancellation via requestId for PATCH', () async {
        await testCancellationForMethod('PATCH', body: {'key': 'value'});
      });

      test('should support cancellation via requestId for DELETE', () async {
        await testCancellationForMethod('DELETE');
      });

      test('should support cancellation via requestId for DOWNLOAD', () async {
        await testCancellationForMethod('DOWNLOAD');
      });
    });

    group('Parser functionality', () {
      test('should parse response to custom type', () async {
        final responseData = {'id': 1, 'name': 'Test'};
        mockDioGet(createSuccessResponse(responseData));

        final future = apiHandler.get<TestModel>(
          '/test',
          parser: (json) => TestModel.fromJson(json),
        );
        final result = await future;

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (data) {
            expect(data, isNotNull);
            expect(data!.id, equals(1));
            expect(data.name, equals('Test'));
          },
        );
      });
    });

    group('Options building', () {
      test('should build options with JSON content type by default', () async {
        mockDioPost(createSuccessResponse());

        final future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          body: {'key': 'value'},
        );
        await future;

        verify(
          mockDio.post<dynamic>(
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

          final future = apiHandler.post<Map<String, dynamic>>(
            '/test',
            parser: (json) => json,
            formData: mockFormData,
          );
          await future;

          verify(
            mockDio.post<dynamic>(
              '/test',
              data: argThat(isNotNull, named: 'data'),
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

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        await future;

        verify(
          mockDio.get<dynamic>(
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

        final future = apiHandler.get<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          queryParameters: {},
        );
        await future;

        verify(
          mockDio.get<dynamic>(
            '/test',
            queryParameters: {},
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle null body in POST request', () async {
        mockDioPost(createSuccessResponse());

        final future = apiHandler.post<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
        );
        await future;

        verify(
          mockDio.post<dynamic>(
            '/test',
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle PUT with null body and formData', () async {
        final mockFormData = createMockFormData();
        mockDioPut(createSuccessResponse());

        final future = apiHandler.put<Map<String, dynamic>>(
          '/test',
          parser: (json) => json,
          formData: mockFormData,
        );
        await future;

        verify(mockFormData.create()).called(1);
        verify(
          mockDio.put<dynamic>(
            '/test',
            data: argThat(isNotNull, named: 'data'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      });

      test('should handle download with query parameters', () async {
        final queryParams = {'token': 'abc123'};
        mockDioDownload(createSuccessResponse({'download': 'complete'}));

        final future = apiHandler.download<Map<String, dynamic>>(
          'https://example.com/file',
          '/path/to/save',
          parser: (json) => json,
          queryParameters: queryParams,
        );
        await future;

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

    group('Authorization flag', () {
      test('should set authorization flag for POST request', () async {
        await testAuthorizationFlagForMethod(
          'POST',
          isAuthorized: true,
          body: {'key': 'value'},
        );
      });

      test('should set authorization flag for PUT request', () async {
        await testAuthorizationFlagForMethod(
          'PUT',
          isAuthorized: true,
          body: {'key': 'value'},
        );
      });

      test('should set authorization flag for PATCH request', () async {
        await testAuthorizationFlagForMethod(
          'PATCH',
          isAuthorized: true,
          body: {'key': 'value'},
        );
      });

      test('should set authorization flag for DELETE request', () async {
        await testAuthorizationFlagForMethod('DELETE', isAuthorized: true);
      });

      test('should set authorization flag for DOWNLOAD request', () async {
        await testAuthorizationFlagForMethod('DOWNLOAD', isAuthorized: true);
      });

      test('should not set authorization flag when false for POST', () async {
        await testAuthorizationFlagForMethod(
          'POST',
          isAuthorized: false,
          body: {'key': 'value'},
        );
      });
    });

    group('Query parameters', () {
      test('should handle query parameters for POST request', () async {
        await testQueryParametersForMethod(
          'POST',
          {'page': 1, 'limit': 10},
          body: {'key': 'value'},
        );
      });

      test('should handle query parameters for PUT request', () async {
        await testQueryParametersForMethod(
          'PUT',
          {'id': 123},
          body: {'key': 'value'},
        );
      });

      test('should handle query parameters for PATCH request', () async {
        await testQueryParametersForMethod(
          'PATCH',
          {'version': 2},
          body: {'key': 'value'},
        );
      });

      test('should handle query parameters for DELETE request', () async {
        await testQueryParametersForMethod('DELETE', {'id': 456});
      });
    });
  });
}
