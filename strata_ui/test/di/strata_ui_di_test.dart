import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:strata_ui/strata_ui.dart';

void main() {
  group('StrataUiDiExtension', () {
    late GetIt getIt;

    setUp(() async {
      getIt = GetIt.asNewInstance();
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('registerStrataUi executes without error', () {
      expect(() => getIt.registerStrataUi(), returnsNormally);
    });
  });
}
