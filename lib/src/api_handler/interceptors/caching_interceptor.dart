import 'dart:async';

import 'package:dio/dio.dart';

import '../base_cache_store/base_cache_store_interface.dart';
import '../base_cache_store/cache_entry.dart';

/// A Dio interceptor that handles caching of GET requests.
///
/// This interceptor checks if a GET request should be cached (based on the
/// 'shouldCache' flag in the request options). If a valid, unexpired cache
/// entry exists for the request, it returns the cached response directly.
/// Otherwise, it allows the request to proceed and caches the response
/// upon receiving it.
///
/// The interceptor uses a [BaseCacheStore] to persist cache entries and
/// utilizes configurable keys and durations for cache management.
class CachingInterceptor extends Interceptor {
  /// The cache store used for saving and retrieving cached responses.
  final BaseCacheStore cacheStore;

  /// The default duration for which a cached response is considered valid.
  final Duration defaultCacheDuration;

  /// The key in the request's extra data used to store/retrieve the cache key.
  final String cacheKeyExtra;

  /// The key in the request's extra data that forces a refresh, bypassing the cache.
  final String forceRefreshExtra;

  /// Creates a new [CachingInterceptor] instance.
  ///
  /// [cacheStore] is required to store and retrieve cache entries.
  /// Optional parameters include:
  /// - [defaultCacheDuration]: How long a cache entry remains valid (default: 30 minutes).
  /// - [forceRefreshExtra]: The extra key that, when set to true, forces the request to bypass the cache.
  CachingInterceptor({
    required this.cacheStore,
    this.defaultCacheDuration = const Duration(minutes: 30),
    this.cacheKeyExtra = 'cacheKey',
    this.forceRefreshExtra = 'forceRefresh',
  });

  /// Intercepts outgoing requests.
  ///
  /// If the request is a GET and has caching enabled (via the 'shouldCache'
  /// flag in [options.extra]), this method checks for an existing cached
  /// response using a generated cache key. If a valid cache entry exists and
  /// force refresh is not requested, the cached response is returned immediately.
  /// Otherwise, the cache key is attached to the request for future response caching.
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldCacheRequest(options)) {
      final cacheKey = _getCacheKey(options);
      final forceRefresh = options.extra[forceRefreshExtra] == true;

      if (!forceRefresh) {
        final cached = await cacheStore.get(cacheKey);
        if (cached != null && !_isExpired(cached)) {
          // Resolve the request immediately with the cached response.
          handler.resolve(
            cached.toResponse(options),
            true, // indicate it's from cache
          );
          return;
        }
      }

      // Attach the cache key to the request's extra data for later use in onResponse.
      options.extra[cacheKeyExtra] = cacheKey;
    }

    // Continue with the request if caching is not applicable or no valid cache exists.
    handler.next(options);
  }

  /// Intercepts incoming responses.
  ///
  /// If the original request should be cached (i.e., it's a GET with caching enabled),
  /// this method saves the response in the cache store using the cache key that was
  /// attached to the request in [onRequest]. The response is wrapped in a [CacheEntry]
  /// with an expiration time defined by [defaultCacheDuration].
  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (_shouldCacheRequest(response.requestOptions)) {
      final cacheKey = response.requestOptions.extra[cacheKeyExtra];

      if (cacheKey != null) {
        await cacheStore.save(
          cacheKey,
          CacheEntry.fromResponse(response, defaultCacheDuration),
        );
      }
    }

    // Pass the response to the next interceptor in the chain.
    handler.next(response);
  }

  /// Determines whether a given request should be cached.
  ///
  /// A request is considered cacheable if it is a GET request and if the
  /// 'shouldCache' flag in [options.extra] is set to true.
  bool _shouldCacheRequest(RequestOptions options) {
    return options.method.toLowerCase() == 'get' &&
        options.extra['shouldCache'] == true;
  }

  /// Generates a unique cache key for a request.
  ///
  /// The key is based on the request URI.
  /// This allows differentiation of cache entries based on the endpoint and user-specific data.
  String _getCacheKey(RequestOptions options) {
    final headersKey = options.headers.entries.map((e) => e.value).join('|');

    return '${options.uri}_$headersKey';
  }

  /// Checks whether a cache entry has expired.
  ///
  /// Returns `true` if the current time is after the cache entry's expiration time,
  /// indicating that the cache entry is no longer valid.
  bool _isExpired(CacheEntry entry) {
    return DateTime.now().isAfter(entry.expiresAt);
  }
}
