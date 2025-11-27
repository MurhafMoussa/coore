import 'package:coore/coore.dart';
import 'package:dio/dio.dart';

class DioExceptionMapper extends NetworkExceptionMapper {
  DioExceptionMapper(super.errorParser);

  @override
  Failure mapException(Object exception, StackTrace? stackTrace) {
    // 1. If it's not a DioException, it's an unexpected crash.
    if (exception is! DioException) {
      return UnknownFailure(
        message: exception.toString(),
        stackTrace: stackTrace,
        originalException: exception,
      );
    }

    // 2. Handle specific Dio errors (Timeouts, No Internet)
    switch (exception.type) {
      case DioExceptionType.cancel:
        return const OperationCancelledFailure(message: 'Request cancelled');

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ConnectionFailure(
          message: 'Request timed out',
          code: 'TIMEOUT',
          stackTrace: stackTrace,
          originalException: exception,
        );

      case DioExceptionType.unknown:
      case DioExceptionType.connectionError:
        return ConnectionFailure(
          message: 'Unable to connect to server',
          code: 'NO_INTERNET',
          stackTrace: stackTrace,
          originalException: exception,
        );

      case DioExceptionType.badCertificate:
        return ConnectionFailure(
          message: 'Invalid SSL Certificate',
          code: 'SSL_ERR',
          stackTrace: stackTrace,
          originalException: exception,
        );

      // 3. Handle Server Responses (4xx, 5xx)
      case DioExceptionType.badResponse:
        return _mapServerResponse(exception.response, stackTrace, exception);
    }
  }

  Failure _mapServerResponse(
    Response? response,
    StackTrace? stackTrace,
    Object original,
  ) {
    if (response == null) {
      return UnknownFailure(
        message: 'Empty response from server',
        stackTrace: stackTrace,
      );
    }

    final int statusCode = response.statusCode ?? 500;

    // Parse the backend error message (using your existing parser logic)
    final errorModel = errorParser(response);
    final String message = errorModel.developerMessage;
    final String? requestId = response.headers.value(
      'x-request-id',
    ); // Traceability!

    // 4. Handle Specific Status Codes
    if (statusCode == 401) {
      return AuthFailure(
        message: message,
        stackTrace: stackTrace,
        originalException: original,
      );
    }

    if (statusCode == 403) {
      return UnauthorizedFailure(
        message: message,
        stackTrace: stackTrace,
        originalException: original,
      );
    }

    if (statusCode == 422) {
      return ValidationFailure(
        message: message,
        errors: errorModel.validationErrors,
        stackTrace: stackTrace,
        originalException: original,
      );
    }

    // 5. Default Server Failure
    return ServerFailure(
      message: message,
      statusCode: statusCode,
      requestId: requestId,
      stackTrace: stackTrace,
      originalException: original,
    );
  }
}
