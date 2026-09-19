import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_state/strata_state.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;
  late LocalizationConfigEntity config;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.delete(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    HydratedBloc.storage = storage;

    config = const LocalizationConfigEntity(
      supportedLocales: [Locale('en'), Locale('ar')],
      localizationsDelegates: [],
      defaultLocale: Locale('en'),
    );
  });

  group('LocalizationCubit', () {
    test('initial state defaults to config defaultLocale', () {
      final cubit = LocalizationCubit(config: config);
      expect(cubit.state, equals(const Locale('en')));
    });

    test('changeLanguage updates locale when supported', () async {
      final cubit = LocalizationCubit(config: config);
      await cubit.changeLanguage(const Locale('ar'));
      expect(cubit.state, equals(const Locale('ar')));
    });

    test('changeLanguage ignores unsupported locales', () async {
      final cubit = LocalizationCubit(config: config);
      await cubit.changeLanguage(const Locale('fr'));
      expect(cubit.state, equals(const Locale('en')));
    });

    test('toJson and fromJson for locale persistence', () {
      final cubit = LocalizationCubit(config: config);
      const locale = Locale('ar', 'SA');
      final json = cubit.toJson(locale);
      final restored = cubit.fromJson(json!);

      expect(restored, equals(locale));
    });
  });
}
