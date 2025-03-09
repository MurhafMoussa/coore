import 'package:coore/src/utils/validators/validator.dart';
import 'package:flutter/material.dart';

class FieldRequiredValidator extends Validator {
  const FieldRequiredValidator({this.message});
  final String? message;
  @override
  String? validate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }
}
