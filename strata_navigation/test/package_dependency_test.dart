import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('strata_navigation Package Boundary Audit', () {
    test('pubspec.yaml must NOT import prohibited UI state/database dependencies', () {
      final pubspecFile = File('pubspec.yaml');
      expect(pubspecFile.existsSync(), isTrue, reason: 'pubspec.yaml should exist');

      final content = pubspecFile.readAsStringSync();

      const prohibitedDependencies = [
        'flutter_bloc',
        'dio',
        'hive',
        'isar',
        'drift',
      ];

      for (final dep in prohibitedDependencies) {
        expect(
          content.contains('$dep:'),
          isFalse,
          reason: 'strata_navigation must NOT depend on $dep',
        );
      }
    });
  });
}
