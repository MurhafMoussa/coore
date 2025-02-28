import 'package:coore/src/error_handling/failures/failure.dart';

abstract class ExceptionMapper {
  // Abstract method that maps an exception to a Failure.
  Failure mapException(Exception exception, StackTrace? stackTrace);
}
