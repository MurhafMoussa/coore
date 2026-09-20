import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

void main() {
  group('Models and Params Tests', () {
    test('NoParams serialization and value equality', () {
      const params1 = NoParams();
      final params2 = NoParams.fromJson({});
      expect(params1, equals(params2));
      expect(params1.toJson(), isEmpty);
      expect(params1.props, isEmpty);
    });

    test('IdParam serialization and value equality', () {
      const param1 = IdParam(id: '123');
      final param2 = IdParam.fromJson({'id': '123'});
      expect(param1, equals(param2));
      expect(param1.toJson(), equals({'id': '123'}));
      expect(param1.toJson(idKey: 'custom_id'), equals({'custom_id': '123'}));
      expect(param1.props, equals(['123']));

      final emptyParam = IdParam.fromJson({});
      expect(emptyParam.id, isEmpty);
    });

    test('DefaultPaginationParams serialization and value equality', () {
      const pagination1 = DefaultPaginationParams(batch: 2, limit: 20);
      final pagination2 = DefaultPaginationParams.fromJson({'batch': 2, 'limit': 20});
      expect(pagination1, equals(pagination2));
      expect(pagination1.toJson(), equals({'batch': 2, 'limit': 20}));
      expect(pagination1.props, equals([2, 20]));

      final defaultPagination = DefaultPaginationParams.fromJson({});
      expect(defaultPagination.batch, equals(1));
      expect(defaultPagination.limit, equals(10));
    });

    test('NetworkConfigEntity props props equality', () {
      const config1 = NetworkConfigEntity(
        baseUrl: 'https://api.com',
        excludedPaths: ['/ping'],
        refreshTokenApiEndpoint: '/refresh',
        accessTokenKey: 'access',
        refreshTokenKey: 'refresh',
      );
      const config2 = NetworkConfigEntity(
        baseUrl: 'https://api.com',
        excludedPaths: ['/ping'],
        refreshTokenApiEndpoint: '/refresh',
        accessTokenKey: 'access',
        refreshTokenKey: 'refresh',
      );
      expect(config1.props, equals(config2.props));
    });

    test('ApiRequestOptions, NetworkFile, NetworkFormData props equality', () {
      const options = ApiRequestOptions(isAuthorized: true, requestId: 'r1');
      expect(options.props, containsAll([true, 'r1']));

      const file = NetworkFile(fieldName: 'f', filePath: '/p');
      expect(file.props, containsAll(['f', '/p']));

      const formData = NetworkFormData(fields: {'a': 'b'});
      expect(formData.props, containsAll([{'a': 'b'}, <NetworkFile>[]]));
    });
  });
}
