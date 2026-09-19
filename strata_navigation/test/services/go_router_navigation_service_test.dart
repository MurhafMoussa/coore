import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_navigation/strata_navigation.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('GoRouterNavigationService', () {
    late MockGoRouter mockRouter;
    late GoRouterNavigationService navigationService;

    setUp(() {
      mockRouter = MockGoRouter();
      navigationService = GoRouterNavigationService(router: mockRouter);
    });

    test('delegates go call to underlying GoRouter', () {
      when(() => mockRouter.go('/details', extra: 'param'))
          .thenReturn(null);

      navigationService.go('/details', extra: 'param');

      verify(() => mockRouter.go('/details', extra: 'param')).called(1);
    });

    test('delegates push call to underlying GoRouter', () async {
      when(() => mockRouter.push<String>('/profile', extra: null))
          .thenAnswer((_) async => 'result');

      final result = await navigationService.push<String>('/profile');

      expect(result, equals('result'));
      verify(() => mockRouter.push<String>('/profile', extra: null)).called(1);
    });

    test('delegates pop call to underlying GoRouter', () {
      when(() => mockRouter.pop<String>('done')).thenReturn(null);

      navigationService.pop<String>('done');

      verify(() => mockRouter.pop<String>('done')).called(1);
    });

    test('delegates replace call to underlying GoRouter', () {
      when(() => mockRouter.replace('/login', extra: null))
          .thenAnswer((_) async => null);

      navigationService.replace('/login');

      verify(() => mockRouter.replace('/login', extra: null)).called(1);
    });

    test('delegates canPop call to underlying GoRouter', () {
      when(() => mockRouter.canPop()).thenReturn(true);

      expect(navigationService.canPop(), isTrue);
      verify(() => mockRouter.canPop()).called(1);
    });
  });
}
