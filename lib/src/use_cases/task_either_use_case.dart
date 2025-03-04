import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class TaskEitherUseCase<Output, Input> extends UseCase {
  const TaskEitherUseCase();

  RepositoryFutureResponse<Output> call(Input input);
}
