import 'package:strata_core/strata_core.dart';
import 'package:test/test.dart';

class TestNavigationService implements NavigationServiceInterface {
  String? lastGoLocation;
  Object? lastGoExtra;
  String? lastPushLocation;
  Object? lastPushExtra;
  Object? lastPopResult;
  bool popCalled = false;
  String? lastReplaceLocation;
  Object? lastReplaceExtra;
  bool canPopValue = true;

  @override
  void go(String location, {Object? extra}) {
    lastGoLocation = location;
    lastGoExtra = extra;
  }

  @override
  Future<T?> push<T>(String location, {Object? extra}) async {
    lastPushLocation = location;
    lastPushExtra = extra;
    return null;
  }

  @override
  void pop<T>([T? result]) {
    popCalled = true;
    lastPopResult = result;
  }

  @override
  void replace(String location, {Object? extra}) {
    lastReplaceLocation = location;
    lastReplaceExtra = extra;
  }

  @override
  bool canPop() => canPopValue;
}

void main() {
  group('NavigationServiceInterface', () {
    late TestNavigationService navigationService;

    setUp(() {
      navigationService = TestNavigationService();
    });

    test('go records location and extra parameters', () {
      navigationService.go('/home', extra: {'id': 123});

      expect(navigationService.lastGoLocation, equals('/home'));
      expect(navigationService.lastGoExtra, equals({'id': 123}));
    });

    test('push records location and extra parameters', () async {
      await navigationService.push<void>('/details', extra: 'data');

      expect(navigationService.lastPushLocation, equals('/details'));
      expect(navigationService.lastPushExtra, equals('data'));
    });

    test('pop records pop action and result', () {
      navigationService.pop<String>('result_data');

      expect(navigationService.popCalled, isTrue);
      expect(navigationService.lastPopResult, equals('result_data'));
    });

    test('replace records location and extra parameters', () {
      navigationService.replace('/login');

      expect(navigationService.lastReplaceLocation, equals('/login'));
      expect(navigationService.lastReplaceExtra, isNull);
    });

    test('canPop returns boolean status', () {
      expect(navigationService.canPop(), isTrue);
      navigationService.canPopValue = false;
      expect(navigationService.canPop(), isFalse);
    });
  });
}
