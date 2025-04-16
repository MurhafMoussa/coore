import 'package:coore/src/error_handling/failures/network_failure.dart';

abstract interface class NetworkExceptionMapper {
  // Abstract method that maps an exception to a Failure.
  NetworkFailure mapException(Exception exception, StackTrace? stackTrace);
}
