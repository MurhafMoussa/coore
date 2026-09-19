import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_navigation/strata_navigation.dart';

class TestAuthGuard implements RouteGuardInterface {
  TestAuthGuard({required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    if (!isAuthenticated) {
      return '/login';
    }
    return null;
  }
}

class MockBuildContext extends Mock implements BuildContext {}
class MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  group('RouteGuardInterface', () {
    late MockBuildContext context;
    late MockGoRouterState state;

    setUp(() {
      context = MockBuildContext();
      state = MockGoRouterState();
    });

    test('returns redirect path when guard evaluation fails', () {
      final guard = TestAuthGuard(isAuthenticated: false);
      final result = guard.redirect(context, state);

      expect(result, equals('/login'));
    });

    test('returns null when guard evaluation succeeds', () {
      final guard = TestAuthGuard(isAuthenticated: true);
      final result = guard.redirect(context, state);

      expect(result, isNull);
    });
  });
}
