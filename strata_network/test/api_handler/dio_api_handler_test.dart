import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}
class MockNetworkExceptionMapper extends Mock implements NetworkExceptionMapperInterface {}
class MockCancelRequestManager extends Mock implements CancelRequestManagerInterface {}

void main() {
  group('ApiRequestOptions & NetworkFormData Models Tests', () {
    test('ApiRequestOptions has correct default values', () {
      const options = ApiRequestOptions();
      expect(options.isAuthorized, isFalse);
      expect(options.shouldCache, isFalse);
      expect(options.enableRetry, isTrue);
      expect(options.maxRetryAttempts, isNull);
      expect(options.retryDelay, isNull);
      expect(options.requestId, isNull);
      expect(options.headers, isNull);
      expect(options.onSendProgress, isNull);
      expect(options.onReceiveProgress, isNull);
      expect(options.extra, isNull);
    });

    test('ApiRequestOptions supports value equality', () {
      const options1 = ApiRequestOptions(
        isAuthorized: true,
        enableRetry: false,
        headers: {'Authorization': 'Bearer 123'},
      );
      const options2 = ApiRequestOptions(
        isAuthorized: true,
        enableRetry: false,
        headers: {'Authorization': 'Bearer 123'},
      );
      expect(options1, equals(options2));
    });

    test('NetworkFormData and NetworkFile encapsulate fields and files correctly', () {
      const file = NetworkFile(
        fieldName: 'avatar',
        filePath: '/tmp/avatar.png',
        filename: 'avatar.png',
        contentType: 'image/png',
      );
      const formData = NetworkFormData(
        fields: {'name': 'John'},
        files: [file],
      );

      expect(file.fieldName, equals('avatar'));
      expect(file.filePath, equals('/tmp/avatar.png'));
      expect(file.filename, equals('avatar.png'));
      expect(file.contentType, equals('image/png'));

      expect(formData.fields, equals({'name': 'John'}));
      expect(formData.files, hasLength(1));
      expect(formData.files.first, equals(file));
    });
  });

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
        mockCancelManager,
      );
    });

    test('get executes successful GET request and applies request options correctly', () async {
      final reqOptions = RequestOptions(path: '/users');
      Options? capturedOptions;

      when(
        () => mockDio.get<dynamic>(
          '/users',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((invocation) async {
        capturedOptions = invocation.namedArguments[#options] as Options?;
        return Response<dynamic>(
          requestOptions: reqOptions,
          statusCode: 200,
          data: {'name': 'John Doe'},
        );
      });

      const options = ApiRequestOptions(
        isAuthorized: true,
        shouldCache: true,
        enableRetry: false,
        maxRetryAttempts: 3,
        retryDelay: Duration(seconds: 2),
        headers: {'X-Custom-Header': 'CustomValue'},
        extra: {'customExtraKey': 'customExtraValue'},
      );

      final result = await handler.get<String>(
        '/users',
        parser: (Map<String, dynamic> json) => json['name'] as String,
        options: options,
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => ''), equals('John Doe'));

      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.headers, equals({'X-Custom-Header': 'CustomValue'}));
      expect(capturedOptions!.extra!['isAuthorized'], isTrue);
      expect(capturedOptions!.extra!['shouldCache'], isTrue);
      expect(capturedOptions!.extra!['enableRetry'], isFalse);
      expect(capturedOptions!.extra!['maxRetryAttempts'], equals(3));
      expect(capturedOptions!.extra!['retryDelay'], equals(2000));
      expect(capturedOptions!.extra!['customExtraKey'], equals('customExtraValue'));
    });

    test('registers and unregisters cancel token when requestId is provided in options', () async {
      final dummyToken = CancelToken();
      when(() => mockCancelManager.registerRequest('req_123'))
          .thenReturn(dummyToken);
      when(() => mockCancelManager.unregisterToken('req_123', dummyToken))
          .thenAnswer((_) {});

      final reqOptions = RequestOptions(path: '/users');
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
          requestOptions: reqOptions,
          statusCode: 200,
          data: {'id': '123'},
        ),
      );

      await handler.get<String>(
        '/users',
        parser: (Map<String, dynamic> json) => json['id'] as String,
        options: const ApiRequestOptions(requestId: 'req_123'),
      );

      verify(() => mockCancelManager.registerRequest('req_123')).called(1);
      verify(() => mockCancelManager.unregisterToken('req_123', dummyToken)).called(1);
    });

    test('post converts NetworkFormData fields into Dio FormData', () async {
      final reqOptions = RequestOptions(path: '/upload');
      dynamic capturedData;
      Options? capturedDioOptions;

      when(
        () => mockDio.post<dynamic>(
          '/upload',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((invocation) async {
        capturedData = invocation.namedArguments[#data];
        capturedDioOptions = invocation.namedArguments[#options] as Options?;
        return Response<dynamic>(
          requestOptions: reqOptions,
          statusCode: 200,
          data: {'status': 'success'},
        );
      });

      const formData = NetworkFormData(
        fields: {'username': 'johndoe', 'age': 30},
      );

      final result = await handler.post<String>(
        '/upload',
        parser: (json) => json['status'] as String,
        formData: formData,
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => ''), equals('success'));
      expect(capturedData, isA<FormData>());

      final dioFormData = capturedData as FormData;
      final fieldKeys = dioFormData.fields.map((e) => e.key).toList();
      expect(fieldKeys, containsAll(['username', 'age']));
      expect(dioFormData.fields.firstWhere((e) => e.key == 'username').value, equals('johndoe'));
      expect(dioFormData.fields.firstWhere((e) => e.key == 'age').value, equals('30'));
      expect(capturedDioOptions!.contentType, equals(Headers.multipartFormDataContentType));
    });

    test('put executes PUT request with ApiRequestOptions', () async {
      final reqOptions = RequestOptions(path: '/update');
      when(
        () => mockDio.put<dynamic>(
          '/update',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: reqOptions,
          statusCode: 200,
          data: {'updated': true},
        ),
      );

      final result = await handler.put<bool>(
        '/update',
        parser: (json) => json['updated'] as bool,
        body: {'title': 'New Title'},
        options: const ApiRequestOptions(isAuthorized: true),
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => false), isTrue);
    });

    test('patch executes PATCH request with ApiRequestOptions', () async {
      final reqOptions = RequestOptions(path: '/patch');
      when(
        () => mockDio.patch<dynamic>(
          '/patch',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: reqOptions,
          statusCode: 200,
          data: {'patched': true},
        ),
      );

      final result = await handler.patch<bool>(
        '/patch',
        parser: (json) => json['patched'] as bool,
        body: {'field': 'value'},
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => false), isTrue);
    });

    test('delete executes DELETE request with ApiRequestOptions', () async {
      final reqOptions = RequestOptions(path: '/delete');
      when(
        () => mockDio.delete<dynamic>(
          '/delete',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: reqOptions,
          statusCode: 200,
          data: {'deleted': true},
        ),
      );

      final result = await handler.delete<bool>(
        '/delete',
        parser: (json) => json['deleted'] as bool,
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => false), isTrue);
    });

    test('download executes DOWNLOAD request with ApiRequestOptions', () async {
      final reqOptions = RequestOptions(path: '/file.zip');
      when(
        () => mockDio.download(
          '/file.zip',
          '/dest/file.zip',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: reqOptions,
          statusCode: 200,
          data: 'SUCCESS',
        ),
      );

      final result = await handler.download<String>(
        '/file.zip',
        '/dest/file.zip',
        parser: (json) => json['data'] as String,
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => ''), equals('SUCCESS'));
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
