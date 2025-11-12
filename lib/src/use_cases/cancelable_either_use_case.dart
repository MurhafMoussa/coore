import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class CancelableEitherUseCase<Output, Input> extends UseCase {
  const CancelableEitherUseCase();

  UseCaseCancelableFutureResponse<Output> call(Input input);
}
