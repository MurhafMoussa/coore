import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_state/strata_state.dart';

class MockStorage extends Mock implements Storage {}
class MockNetworkStatusInterface extends Mock implements NetworkStatusInterface {}

void main() {
  late Storage storage;
  late MockNetworkStatusInterface mockNetworkStatus;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.delete(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    HydratedBloc.storage = storage;

    mockNetworkStatus = MockNetworkStatusInterface();
    when(() => mockNetworkStatus.connectionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockNetworkStatus.dispose()).thenAnswer((_) async {});
  });

  group('Wrapper Widgets Tests in strata_state', () {
    testWidgets('ThemeWrapper provides ThemeCubit and renders child', (tester) async {
      final themeCubit = ThemeCubit();

      await tester.pumpWidget(
        MaterialApp(
          home: ThemeWrapper(
            themeCubit: themeCubit,
            builder: (context, themeConfig) {
              return Text('ThemeMode: ${themeConfig.themeMode}');
            },
          ),
        ),
      );

      expect(find.text('ThemeMode: ThemeMode.light'), findsOneWidget);
    });

    testWidgets('LocalizationWrapper provides LocalizationCubit and renders child', (tester) async {
      const config = LocalizationConfigEntity(
        supportedLocales: [Locale('en'), Locale('ar')],
        localizationsDelegates: [],
        defaultLocale: Locale('en'),
      );
      final localizationCubit = LocalizationCubit(config: config);

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationWrapper(
            localizationCubit: localizationCubit,
            builder: (context, locale) {
              return Text('Locale: ${locale.languageCode}');
            },
          ),
        ),
      );

      expect(find.text('Locale: en'), findsOneWidget);
    });

    testWidgets('NetworkStatusWrapper provides NetworkStatusCubit and renders child', (tester) async {
      final networkCubit = NetworkStatusCubit(networkStatus: mockNetworkStatus);

      await tester.pumpWidget(
        MaterialApp(
          home: NetworkStatusWrapper(
            networkStatusCubit: networkCubit,
            child: const Text('App Main Screen'),
          ),
        ),
      );

      expect(find.text('App Main Screen'), findsOneWidget);
    });
  });
}
