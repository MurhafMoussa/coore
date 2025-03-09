import 'package:flutter/material.dart';

abstract class Validator {
  const Validator();
  String? validate(String? value, BuildContext context);
}
