import 'package:coore/src/utils/validators/validator.dart';

class CompositeValidator implements Validator {
  CompositeValidator(this.validators);
  final List<Validator> validators;

  @override
  String? validate(String? value) {
    for (final validator in validators) {
      final result = validator.validate(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
