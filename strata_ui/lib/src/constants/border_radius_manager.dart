import 'package:flutter/material.dart';

abstract final class BorderRadiusManager {
  static const BorderRadius radiusAll16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusAll12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusAll24 = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusAll32 = BorderRadius.all(Radius.circular(32));
  static const BorderRadius radiusAll8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusAll4 = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusAll6 = BorderRadius.all(Radius.circular(6));
  static const BorderRadius radiusAll3 = BorderRadius.all(Radius.circular(3));
  static const BorderRadiusDirectional radiusDirectionalOnlyTopSE3BottomS5E0 =
      BorderRadiusDirectional.only(
        topEnd: Radius.circular(5),
        topStart: Radius.circular(5),
        bottomStart: Radius.circular(5),
      );
  static const BorderRadiusDirectional radiusDirectionalOnlyTopSE5BottomE5S0 =
      BorderRadiusDirectional.only(
        topEnd: Radius.circular(5),
        topStart: Radius.circular(5),
        bottomEnd: Radius.circular(5),
      );
  static const BorderRadius radiusAll2 = BorderRadius.all(Radius.circular(2));
  static const BorderRadius radiusOnlyTopRightTopLeft8 = BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(8),
  );
  static const BorderRadius radiusOnlyTopRightTopLeft24 = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );
  static const BorderRadius radiusOnlyBottomRightBottomLeft8 =
      BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
}
