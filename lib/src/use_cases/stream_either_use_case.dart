import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

import '../api_handler/entities/base_entity.dart';
import '../api_handler/params/base_params.dart';

abstract class StreamEitherUseCase<
  Output extends BaseEntity,
  Input extends BaseParams
>
    extends UseCase {
  const StreamEitherUseCase();

  RepositoryStreamResponse<Output> call(Input input);
}
