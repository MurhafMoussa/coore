import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strata_ui/strata_ui.dart';

void main() {
  group('strata_ui Constants Tests', () {
    test('SpacingManager constants are instantiated', () {
      expect(SpacingManager.gap10, isA<Widget>());
      expect(SpacingManager.gap20, isA<Widget>());
    });

    test('PaddingManager constants are instantiated correctly', () {
      expect(PaddingManager.paddingAll16, equals(const EdgeInsets.all(16)));
      expect(PaddingManager.paddingHorizontal20.horizontal, equals(40));
    });

    test('BorderRadiusManager constants are instantiated', () {
      expect(BorderRadiusManager.radiusAll12, equals(const BorderRadius.all(Radius.circular(12))));
    });

    test('SizesManager icon sizes are defined', () {
      expect(SizesManager.iconSize24, equals(24.0));
      expect(SizesManager.imageSize80, equals(80.0));
    });
  });
}
