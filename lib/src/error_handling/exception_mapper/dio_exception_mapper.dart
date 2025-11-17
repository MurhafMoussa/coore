import 'package:coore/src/api_handler/models/base_error_response_model.dart';
import 'package:coore/src/error_handling/exception_mapper/network_exception_mapper.dart';
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:dio/dio.dart';

class DioNetworkExceptionMapper extends NetworkExceptionMapper {
  DioNetworkExceptionMapper(
    super.errorParser,
    super.codeToFailureMap, {
    this.defaultErrorMessage,
  }) {
    _defaultCodeToFailureMap = {
      405: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          MethodNotAllowedFailure(_defaultErrorMessage, stackTrace: stackTrace),

      406: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          NotAcceptableFailure(_defaultErrorMessage, stackTrace: stackTrace),

      409: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          ConflictFailure(_defaultErrorMessage, stackTrace: stackTrace),

      413: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          PayloadTooLargeFailure(_defaultErrorMessage, stackTrace: stackTrace),

      429: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          TooManyRequestsFailure(_defaultErrorMessage, stackTrace: stackTrace),

      418: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          TeapotFailure(_defaultErrorMessage, stackTrace: stackTrace),

      500: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          InternalServerErrorFailure(
            _defaultErrorMessage,
            stackTrace: stackTrace,
          ),

      502: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          BadGatewayFailure(_defaultErrorMessage, stackTrace: stackTrace),

      503: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          ServiceUnavailableFailure(
            _defaultErrorMessage,
            stackTrace: stackTrace,
          ),

      504: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          GatewayTimeoutFailure(_defaultErrorMessage, stackTrace: stackTrace),

      505: (BaseErrorResponseModel error, StackTrace? stackTrace) =>
          HttpVersionNotSupportedFailure(
            _defaultErrorMessage,
            stackTrace: stackTrace,
          ),
    };
    codeToFailureMap.addAll(_defaultCodeToFailureMap);
  }
  final String? defaultErrorMessage;
  late final Map<
    int,
    NetworkFailure Function(BaseErrorResponseModel, StackTrace?)
  >
  _defaultCodeToFailureMap;

  @override
  NetworkFailure mapException(Exception exception, StackTrace? stackTrace) {
    if (exception is! DioException) {
      return NoInternetConnectionFailure(
        _defaultErrorMessage,
        stackTrace: stackTrace,
      );
    }
    switch (exception.type) {
      case DioExceptionType.cancel:
        return RequestCancelledFailure(
          'Request cancelled',
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestTimeoutFailure(
          'Request timed out',
          stackTrace: stackTrace,
        );

      case DioExceptionType.unknown:
        return NoInternetConnectionFailure(
          'No internet connection',
          stackTrace: stackTrace,
        );

      case DioExceptionType.badCertificate:
        return UnableToProcessFailure(
          'Invalid or expired SSL certificate',
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionError:
        return ConnectionErrorFailure(
          'Unable to establish a connection with the server',
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        return _mapBadResponse(exception.response, stackTrace);
    }
  }

  NetworkFailure _mapBadResponse(Response? response, StackTrace? stackTrace) {
    final error = errorParser(response);
    return codeToFailureMap[error.status]?.call(error, stackTrace) ??
        InvalidStatusCodeFailure('Invalid status code', stackTrace: stackTrace);
  }

  String get _defaultErrorMessage =>
      defaultErrorMessage ?? 'Error, please try again later';
}
