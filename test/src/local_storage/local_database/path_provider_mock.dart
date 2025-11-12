import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return './test_hive';
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return './test_hive';
  }

  @override
  Future<String?> getLibraryPath() async {
    return './test_hive';
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return './test_hive';
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return './test_hive';
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return <String>['./test_hive'];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>['./test_hive'];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return './test_hive';
  }

  @override
  Future<String?> getApplicationCachePath() async {
    return './test_hive';
  }
}
