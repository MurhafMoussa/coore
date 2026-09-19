import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:strata_state/strata_state.dart';

void main() {
  group('StrataStateDiExtension Tests', () {
    test('registerStrataState executes without error', () {
      final getIt = GetIt.asNewInstance();
      getIt.registerStrataState();
      expect(getIt, isNotNull);
    });
  });
}
