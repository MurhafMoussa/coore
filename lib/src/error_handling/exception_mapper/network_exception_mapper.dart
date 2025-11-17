import 'package:coore/lib.dart';

abstract class NetworkExceptionMapper {
  final ErrorModelParser errorParser;
  final Map<int, FailureBuilder> codeToFailureMap;
  NetworkExceptionMapper(this.errorParser, this.codeToFailureMap);
  // Abstract method that maps an exception to a Failure.
  NetworkFailure mapException(Exception exception, StackTrace? stackTrace);
}
