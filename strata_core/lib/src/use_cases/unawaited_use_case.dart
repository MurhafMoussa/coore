import 'usecase.dart';

abstract class UnawaitedUseCase<Output, Input> extends UseCase {
  const UnawaitedUseCase();

  Output call(Input input);
}
