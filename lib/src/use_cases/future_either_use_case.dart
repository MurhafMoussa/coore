import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class FutureEitherUseCase<Output, Input> extends UseCase {
  const FutureEitherUseCase();

  RepositoryFutureResponse<Output> call(Input input);
}
