import 'package:coore/src/api_handler/models/error_response_model.dart';
import 'package:coore/src/error_handling/exception_mapper/network_exception_mapper.dart';
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:dio/dio.dart';

class DioNetworkExceptionMapper implements NetworkExceptionMapper {
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
    final error = ErrorResponseModel.fromJson(response?.data).error;
    final statusCode = error.status;
    switch (statusCode) {
      case 400:
        return BadRequestFailure(error.message, stackTrace);
      case 401:
        return UnauthorizedRequestFailure(error.message, stackTrace);
      case 403:
        return ForbiddenFailure(error.message, stackTrace);
      case 404:
        return NotFoundFailure(error.message, stackTrace);
      case 405:
        return MethodNotAllowedFailure(_defaultErrorMessage, stackTrace);
      case 406:
        return NotAcceptableFailure(_defaultErrorMessage, stackTrace);
      case 409:
        return ConflictFailure(_defaultErrorMessage, stackTrace);
      case 413:
        return PayloadTooLargeFailure(_defaultErrorMessage, stackTrace);
      case 422:
        return ValidationFailure(error.message, stackTrace);
      case 429:
        return TooManyRequestsFailure(_defaultErrorMessage, stackTrace);
      case 418:
        return TeapotFailure(_defaultErrorMessage, stackTrace);
      case 451:
        return UnavailableForLegalReasonsFailure(error.message, stackTrace);
      case 500:
        return InternalServerErrorFailure(_defaultErrorMessage, stackTrace);
      case 502:
        return BadGatewayFailure(_defaultErrorMessage, stackTrace);
      case 503:
        return ServiceUnavailableFailure(_defaultErrorMessage, stackTrace);
      case 504:
        return GatewayTimeoutFailure(_defaultErrorMessage, stackTrace);
      case 505:
        return HttpVersionNotSupportedFailure(_defaultErrorMessage, stackTrace);
      default:
        return InvalidStatusCodeFailure('Invalid status code', stackTrace);
    }
  }

  String get _defaultErrorMessage => 'Error, please try again later';
}
