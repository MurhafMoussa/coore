import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Package Dependency Boundary Tests for strata_network', () {
    test('strata_network must not import Flutter or third-party UI/routing packages', () {
      final libDir = Directory('lib');
      expect(libDir.existsSync(), isTrue);

      final forbiddenImports = [
        'package:flutter/',
        'package:flutter_bloc/',
        'package:go_router/',
        'package:skeletonizer/',
      ];

      final dartFiles = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        for (final forbidden in forbiddenImports) {
          expect(
            content.contains(forbidden),
            isFalse,
            reason: 'File ${file.path} contains forbidden import $forbidden',
          );
        }
      }
    });
  });
}
