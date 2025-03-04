import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class StreamEitherUseCase<Output, Input> extends UseCase {
  const StreamEitherUseCase();

  RepositoryStreamResponse<Output> call(Input input);
}
