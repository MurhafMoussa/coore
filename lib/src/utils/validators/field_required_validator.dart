import 'package:coore/src/utils/validators/validator.dart';

class FieldRequiredValidator extends Validator {
  const FieldRequiredValidator({this.message});
  final String? message;
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }
}
