import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class ResultFutureUseCase<Output, Input> extends UseCase {
  const ResultFutureUseCase();

  /// Executes the use case with optional request cancellation support.
  ///
  /// To enable cancellation, use a static [requestId] string identifier when calling
  /// API handler methods (e.g., "get_user", "fetch_posts"). The same [requestId] must
  /// be used in [ApiStateHandler.handleApiCall] to enable cancellation via [CancelRequestManager].
  ResultFuture<Output> call(Input input);
}
