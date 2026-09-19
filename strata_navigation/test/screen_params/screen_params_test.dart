import 'package:flutter_test/flutter_test.dart';
import 'package:strata_navigation/strata_navigation.dart';

class SampleParams extends BaseScreenParams {
  const SampleParams({required this.id});

  final String id;

  @override
  Map<String, String> get pathParams => {'id': id};

  @override
  Map<String, dynamic> get queryParams => {'active': true};

  @override
  Map<String, Object> get extra => {'metadata': 'sample'};
}

void main() {
  group('BaseScreenParams and NoScreenParams', () {
    test('NoScreenParams provides empty maps and supports value equality', () {
      const params1 = NoScreenParams();
      const params2 = NoScreenParams();

      expect(params1.queryParams, isEmpty);
      expect(params1.pathParams, isEmpty);
      expect(params1.extra, isEmpty);
      expect(params1, equals(params2));
    });

    test('Custom BaseScreenParams exposes configured params', () {
      const params = SampleParams(id: '42');

      expect(params.pathParams, equals({'id': '42'}));
      expect(params.queryParams, equals({'active': true}));
      expect(params.extra, equals({'metadata': 'sample'}));
      expect(params, equals(const SampleParams(id: '42')));
    });
  });
}
