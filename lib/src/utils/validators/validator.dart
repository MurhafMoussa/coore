import 'package:flutter/material.dart';

abstract class Validator {
  const Validator();
  String? validate(dynamic value, BuildContext context);
}
