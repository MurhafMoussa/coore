import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class FutureEitherUseCase<Output, Input> extends UseCase {
  const FutureEitherUseCase();

  /// Executes the use case with optional request cancellation support.
  ///
  /// [requestId]: Optional request ID for cancellation support. If provided, the request
  ///              can be cancelled via [CancelRequestManager].
  UseCaseFutureResponse<Output> call(Input input);
}
