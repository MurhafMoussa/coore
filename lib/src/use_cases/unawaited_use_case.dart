import 'package:coore/src/api_handler/entities/base_entity.dart';
import 'package:coore/src/api_handler/params/base_params.dart';
import 'package:coore/src/use_cases/usecase.dart';

abstract class UnawaitedUseCase<
  Output extends BaseEntity,
  Input extends BaseParams
>
    extends UseCase {
  const UnawaitedUseCase();

  Output call(Input input);
}
