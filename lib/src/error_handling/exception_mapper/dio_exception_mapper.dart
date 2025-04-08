import 'package:coore/src/api_handler/models/error_response_model.dart';
import 'package:coore/src/error_handling/exception_mapper/network_exception_mapper.dart';
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:dio/dio.dart';

class DioNetworkExceptionMapper implements NetworkExceptionMapper {
  final Map<int, NetworkFailure Function(Error, StackTrace?)>
  _codeToFailureMap = {
    400:
        (Error error, StackTrace? stackTrace) =>
            BadRequestFailure(error.message, stackTrace),
    401:
        (Error error, StackTrace? stackTrace) =>
            UnauthorizedRequestFailure(error.message, stackTrace),

    403:
        (Error error, StackTrace? stackTrace) =>
            ForbiddenFailure(error.message, stackTrace),

    404:
        (Error error, StackTrace? stackTrace) =>
            NotFoundFailure(error.message, stackTrace),

    405:
        (Error error, StackTrace? stackTrace) =>
            MethodNotAllowedFailure(_defaultErrorMessage, stackTrace),

    406:
        (Error error, StackTrace? stackTrace) =>
            NotAcceptableFailure(_defaultErrorMessage, stackTrace),

    409:
        (Error error, StackTrace? stackTrace) =>
            ConflictFailure(_defaultErrorMessage, stackTrace),

    413:
        (Error error, StackTrace? stackTrace) =>
            PayloadTooLargeFailure(_defaultErrorMessage, stackTrace),
    422:
        (Error error, StackTrace? stackTrace) =>
            ValidationFailure(error.message, stackTrace),

    429:
        (Error error, StackTrace? stackTrace) =>
            TooManyRequestsFailure(_defaultErrorMessage, stackTrace),

    418:
        (Error error, StackTrace? stackTrace) =>
            TeapotFailure(_defaultErrorMessage, stackTrace),

    451:
        (Error error, StackTrace? stackTrace) =>
            UnavailableForLegalReasonsFailure(error.message, stackTrace),

    500:
        (Error error, StackTrace? stackTrace) =>
            InternalServerErrorFailure(_defaultErrorMessage, stackTrace),

    502:
        (Error error, StackTrace? stackTrace) =>
            BadGatewayFailure(_defaultErrorMessage, stackTrace),

    503:
        (Error error, StackTrace? stackTrace) =>
            ServiceUnavailableFailure(_defaultErrorMessage, stackTrace),

    504:
        (Error error, StackTrace? stackTrace) =>
            GatewayTimeoutFailure(_defaultErrorMessage, stackTrace),

    505:
        (Error error, StackTrace? stackTrace) =>
            HttpVersionNotSupportedFailure(_defaultErrorMessage, stackTrace),
  };

  @override
  NetworkFailure mapException(Exception exception, StackTrace? stackTrace) {
    if (exception is! DioException) {
      return NoInternetConnectionFailure(_defaultErrorMessage, stackTrace);
    }
    switch (exception.type) {
      case DioExceptionType.cancel:
        return RequestCancelledFailure('Request cancelled', stackTrace);

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestTimeoutFailure('Request timed out', stackTrace);

      case DioExceptionType.unknown:
        return NoInternetConnectionFailure(
          'No internet connection',
          stackTrace,
        );

      case DioExceptionType.badCertificate:
        return UnableToProcessFailure(
          'Invalid or expired SSL certificate',
          stackTrace,
        );

      case DioExceptionType.connectionError:
        return ConnectionErrorFailure(
          'Unable to establish a connection with the server',
          stackTrace,
        );

      case DioExceptionType.badResponse:
        return _mapBadResponse(exception.response, stackTrace);
    }
  }

  NetworkFailure _mapBadResponse(Response? response, StackTrace? stackTrace) {
    final error =
        ErrorResponseModel.fromJson(
          response?.data as Map<String, dynamic>,
        ).error;
    final statusCode = error.status;
    if (_codeToFailureMap[statusCode] != null) {
      return _codeToFailureMap[statusCode]!.call(error, stackTrace);
    }
    return InvalidStatusCodeFailure('Invalid status code', stackTrace);
  }

  static String get _defaultErrorMessage => 'Error, please try again later';
}
