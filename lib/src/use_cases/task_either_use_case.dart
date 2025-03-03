import 'package:coore/src/api_handler/entities/base_entity.dart';
import 'package:coore/src/api_handler/params/base_params.dart';
import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class TaskEitherUseCase<
  Output extends BaseEntity,
  Input extends BaseParams
>
    extends UseCase {
  const TaskEitherUseCase();

  RepositoryFutureResponse<Output> call(Input input);
}
