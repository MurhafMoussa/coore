import '../typedefs/result_typedefs.dart';
import 'usecase.dart';

abstract class ResultStreamUseCase<Output, Input> extends UseCase {
  const ResultStreamUseCase();

  ResultStream<Output> call(Input input);
}
