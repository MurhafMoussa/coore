import 'package:coore/src/typedefs/core_typedefs.dart';

abstract class Defaults {
  static const Id invalidId = -1;
  static const String defaultString = '';
  static const bool defaultBool = false;
  static const int defaultInt = 0;
  static const double defaultDouble = 0.0;
  static const num defaultNum = 0;
  static const List defaultList = [];
  static const Map defaultMap = {};
  static DateTime defaultDateTime = DateTime(9999, 12, 31);
}
