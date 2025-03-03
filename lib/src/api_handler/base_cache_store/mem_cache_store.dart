import '../../utils/lock.dart';
import 'base_cache_store_interface.dart';
import 'cache_entry.dart';

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
