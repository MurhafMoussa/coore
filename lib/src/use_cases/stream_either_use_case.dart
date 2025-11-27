import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class ResultStreamUseCase<Output, Input> extends UseCase {
  const ResultStreamUseCase();

  ResultStream<Output> call(Input input);
}
