import 'package:coore/src/utils/validators/validator.dart';
import 'package:flutter/material.dart';

class CompositeValidator implements Validator {
  CompositeValidator(this.validators);
  final List<Validator> validators;

  @override
  String? validate(String? value, BuildContext context) {
    for (final validator in validators) {
      final result = validator.validate(value, context);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
