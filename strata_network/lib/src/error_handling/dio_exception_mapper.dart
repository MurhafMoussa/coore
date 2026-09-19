import 'package:dio/dio.dart';
import 'package:strata_core/strata_core.dart';
import 'network_exception_mapper_interface.dart';

/// Default Dio exception mapper converting [DioException] into [Failure] domain models.
class DioExceptionMapper implements NetworkExceptionMapperInterface {
  DioExceptionMapper(this.errorParser);

  final ErrorModelParser errorParser;

  @override
  Failure mapException(Object exception, StackTrace? stackTrace) {
    if (exception is! DioException) {
      return UnknownFailure(
        message: exception.toString(),
        stackTrace: stackTrace,
        originalException: exception,
      );
    }

    switch (exception.type) {
      case DioExceptionType.cancel:
        return ConnectionFailure(
          message: 'Request cancelled',
          code: 'CANCELLED',
          stackTrace: stackTrace,
          originalException: exception,
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
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

      case DioExceptionType.badResponse:
        return _mapServerResponse(exception.response, stackTrace, exception);
    }
  }

  Failure _mapServerResponse(
    Response<dynamic>? response,
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
    final errorModel = errorParser(response);
    final String message = errorModel.developerMessage;
    final String? requestId = response.headers.value('x-request-id');

    if (statusCode == 401) {
      return UnauthorizedFailure(
        message: message,
        code: 'AUTH_401',
        stackTrace: stackTrace,
        originalException: original,
      );
    }

    if (statusCode == 403) {
      return UnauthorizedFailure(
        message: message,
        code: 'AUTH_403',
        stackTrace: stackTrace,
        originalException: original,
      );
    }

    if (statusCode == 422) {
      return ValidationFailure(
        message: message,
        stackTrace: stackTrace,
        originalException: original,
      );
    }

    return ServerFailure(
      message: message,
      statusCode: statusCode,
      requestId: requestId,
      stackTrace: stackTrace,
      originalException: original,
    );
  }
}
