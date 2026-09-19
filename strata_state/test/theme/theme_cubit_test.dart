import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_state/strata_state.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.delete(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('ThemeConfigEntity', () {
    test('defaultConfig should have light themeMode and false enableAutoSwitch', () {
      final config = ThemeConfigEntity.defaultConfig();
      expect(config.themeMode, equals(ThemeMode.light));
      expect(config.enableAutoSwitch, isFalse);
    });

    test('toJson and fromJson should serialize correctly', () {
      const config = ThemeConfigEntity(
        themeMode: ThemeMode.dark,
        enableAutoSwitch: true,
      );
      final json = config.toJson();
      final restored = ThemeConfigEntity.fromJson(json);

      expect(restored, equals(config));
    });
  });

  group('ThemeCubit', () {
    test('initial state defaults to defaultConfig', () {
      final cubit = ThemeCubit();
      expect(cubit.state, equals(ThemeConfigEntity.defaultConfig()));
    });

    test('setThemeMode updates state correctly', () {
      final cubit = ThemeCubit();
      cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state.themeMode, equals(ThemeMode.dark));
    });

    test('toggleTheme toggles light and dark modes', () {
      final cubit = ThemeCubit();
      expect(cubit.state.themeMode, equals(ThemeMode.light));

      cubit.toggleTheme();
      expect(cubit.state.themeMode, equals(ThemeMode.dark));

      cubit.toggleTheme();
      expect(cubit.state.themeMode, equals(ThemeMode.light));
    });

    test('toJson and fromJson for cubit state persistence', () {
      final cubit = ThemeCubit();
      const config = ThemeConfigEntity(
        themeMode: ThemeMode.dark,
        enableAutoSwitch: false,
      );
      final json = cubit.toJson(config);
      final restored = cubit.fromJson(json!);

      expect(restored, equals(config));
    });
  });
}
