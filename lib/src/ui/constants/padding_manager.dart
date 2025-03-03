import 'package:flutter/material.dart';

abstract final class PaddingManager {
  static const EdgeInsets paddingTop48 = EdgeInsets.only(top: 48);
  static const EdgeInsets paddingBottom8 = EdgeInsets.only(bottom: 8);
  static const EdgeInsets paddingBottom16 = EdgeInsets.only(bottom: 16);
  static const EdgeInsets paddingBottom4 = EdgeInsets.only(bottom: 4);
  static const EdgeInsets paddingVertical48 = EdgeInsets.symmetric(
    vertical: 48,
  );
  static const EdgeInsets paddingVertical16 = EdgeInsets.symmetric(
    vertical: 16,
  );
  static const EdgeInsets paddingOnlyT4B2 = EdgeInsets.only(top: 4, bottom: 2);
  static const EdgeInsets paddingOnlyT5 = EdgeInsets.only(top: 5);
  static const EdgeInsets paddingAll20 = EdgeInsets.all(20);
  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static final EdgeInsets paddingHorizontal16Top56 = paddingHorizontal16
      .copyWith(top: 56);
  static const EdgeInsets paddingHorizontal30 = EdgeInsets.symmetric(
    horizontal: 30,
  );
  static const EdgeInsets paddingHorizontal8 = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const EdgeInsets paddingHorizontal20 = EdgeInsets.symmetric(
    horizontal: 20,
  );
  static const EdgeInsets paddingHorizontal14 = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const EdgeInsets paddingHorizontal4Vertical16 = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 16,
  );
  static const EdgeInsets paddingHorizontal8Vertical4 = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const EdgeInsets paddingHorizontal20Vertical10 = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  );
  static const EdgeInsets paddingHorizontal20Vertical15 = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 15,
  );
  static const EdgeInsets paddingHorizontal20Vertical6 = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 6,
  );
  static const EdgeInsets paddingHorizontal10Vertical7 = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 7,
  );
  static const EdgeInsets paddingHorizontal10Vertical15 = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 15,
  );
  static const EdgeInsets paddingHorizontal20Vertical25 = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 25,
  );
  static const EdgeInsets paddingHorizontal8Vertical16 = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 16,
  );
  static const EdgeInsets paddingHorizontal4Vertical8 = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 8,
  );
  static const EdgeInsets paddingHorizontal2Vertical8 = EdgeInsets.symmetric(
    horizontal: 2,
    vertical: 8,
  );
  static const EdgeInsets paddingAll10 = EdgeInsets.all(10);
  static const EdgeInsets paddingHorizontal2Vertical6 = EdgeInsets.symmetric(
    horizontal: 2,
    vertical: 6,
  );
  static const EdgeInsets paddingOnlyLR2T4B3 = EdgeInsets.only(
    left: 2,
    right: 2,
    top: 4,
    bottom: 3,
  );
  static const EdgeInsets paddingHorizontal4 = EdgeInsets.symmetric(
    horizontal: 4,
  );
  static const EdgeInsets paddingHorizontal24 = EdgeInsets.symmetric(
    horizontal: 24,
  );
  static const EdgeInsets paddingHorizontal12 = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets paddingHorizontal32 = EdgeInsets.symmetric(
    horizontal: 32,
  );
  static const EdgeInsets paddingHorizontal24Vertical16 = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );
  static const EdgeInsets paddingHorizontal16Vertical8 = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets paddingHorizontal17Vertical7 = EdgeInsets.symmetric(
    horizontal: 17,
    vertical: 7,
  );
  static const EdgeInsets paddingHorizontal16Vertical12 = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets paddingHorizontal15Vertical18 = EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 18,
  );
  static const EdgeInsetsDirectional paddingDirectionalOnlyS19E16T10 =
      EdgeInsetsDirectional.only(start: 19, end: 16, top: 10);
  static const EdgeInsets paddingHorizontal36 = EdgeInsets.symmetric(
    horizontal: 37,
  );
  static const EdgeInsets paddingVertical12 = EdgeInsets.symmetric(
    vertical: 12,
  );
  static const EdgeInsets paddingVertical15 = EdgeInsets.symmetric(
    vertical: 15,
  );
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets paddingVertical20 = EdgeInsets.symmetric(
    vertical: 20,
  );
  static const EdgeInsets paddingHorizontal12Vertical16 = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 12,
  );

  static const EdgeInsetsDirectional paddingDirectionalTBS4E10 =
      EdgeInsetsDirectional.only(top: 4, bottom: 4, start: 4, end: 10);
  static const EdgeInsetsDirectional paddingDirectionalTB4S8E16 =
      EdgeInsetsDirectional.only(top: 4, bottom: 4, start: 8, end: 16);
  static const EdgeInsetsDirectional paddingDirectionalHorizontal6 =
      EdgeInsetsDirectional.symmetric(horizontal: 6);
  static const EdgeInsetsDirectional paddingDirectionalOnlyTB16S0E16 =
      EdgeInsetsDirectional.only(top: 16, bottom: 16, end: 16);
  static const EdgeInsetsDirectional paddingDirectionalOnlyS20 =
      EdgeInsetsDirectional.only(start: 20);
  static const EdgeInsetsDirectional paddingDirectionalOnlyE8 =
      EdgeInsetsDirectional.only(end: 8);
  static const EdgeInsets paddingOnlyTLR12B16 = EdgeInsets.only(
    top: 12,
    bottom: 16,
    right: 12,
    left: 12,
  );
  static const EdgeInsets paddingLRT8B16 = EdgeInsets.only(
    top: 8,
    bottom: 16,
    left: 8,
    right: 8,
  );
  static const EdgeInsets paddingAll16 = EdgeInsets.all(16);
  static const EdgeInsets paddingAll18 = EdgeInsets.all(18);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(24);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(32);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(12);
  static const EdgeInsets paddingAll14 = EdgeInsets.all(14);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(8);
  static const EdgeInsets paddingAll4 = EdgeInsets.all(4);
  static const EdgeInsets paddingAll6 = EdgeInsets.all(6);
}
