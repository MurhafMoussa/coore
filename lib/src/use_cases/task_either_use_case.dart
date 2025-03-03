import 'package:coore/src/use_cases/usecase.dart';

import '../api_handler/entities/base_entity.dart';
import '../api_handler/params/base_params.dart';
import '../typedefs/core_typedefs.dart';

abstract class TaskEitherUseCase<
  Output extends BaseEntity,
  Input extends BaseParams
>
    extends UseCase {
  const TaskEitherUseCase();

  RepositoryFutureResponse<Output> call(Input input);
}
