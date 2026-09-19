import '../typedefs/result_typedefs.dart';
import 'usecase.dart';

abstract class ResultFutureUseCase<Output, Input> extends UseCase {
  const ResultFutureUseCase();

  ResultFuture<Output> call(Input input);
}
