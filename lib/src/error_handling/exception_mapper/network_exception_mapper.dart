import 'package:coore/lib.dart';

abstract class NetworkExceptionMapper {
  final ErrorModelParser errorParser;

  NetworkExceptionMapper(this.errorParser,);
  // Abstract method that maps an exception to a Failure.
  Failure mapException(Exception exception, StackTrace? stackTrace);
}
