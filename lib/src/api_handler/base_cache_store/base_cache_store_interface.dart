import 'package:coore/src/api_handler/base_cache_store/cache_entry.dart';

abstract class BaseCacheStore {
  Future<CacheEntry?> get(String key);

  Future<void> save(String key, CacheEntry entry);

  Future<void> delete(String key);

  Future<void> clear();
}
