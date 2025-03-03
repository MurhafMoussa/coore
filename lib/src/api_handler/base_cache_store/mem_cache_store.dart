import 'package:coore/src/api_handler/base_cache_store/base_cache_store_interface.dart';
import 'package:coore/src/api_handler/base_cache_store/cache_entry.dart';
import 'package:coore/src/utils/lock.dart';

class MemoryCacheStore implements BaseCacheStore {
  final Map<String, CacheEntry> _storage = {};
  final _lock = Lock();

  @override
  Future<CacheEntry?> get(String key) async {
    await _lock.synchronized(() {});
    return _storage[key];
  }

  @override
  Future<void> save(String key, CacheEntry entry) async {
    await _lock.synchronized(() {
      _storage[key] = entry;
    });
  }

  @override
  Future<void> delete(String key) async =>
      _lock.synchronized(() => _storage.remove(key));

  @override
  Future<void> clear() async => _lock.synchronized(() => _storage.clear());
}
