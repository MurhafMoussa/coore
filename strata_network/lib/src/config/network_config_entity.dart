import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Authentication interceptor type options.
enum AuthInterceptorType { tokenBased, cookieBased }

/// Configuration options for `strata_network` HTTP client and interceptors.
class const NetworkConfigEntity({
  required final String baseUrl,
  required final List<String> excludedPaths,
  required final String refreshTokenApiEndpoint,
  required final String accessTokenKey,
  required final String refreshTokenKey,
  final AuthInterceptorType authInterceptorType = AuthInterceptorType.cookieBased,
  final Duration connectTimeout = const Duration(seconds: 60),
  final Duration sendTimeout = const Duration(seconds: 60),
  final Duration receiveTimeout = const Duration(seconds: 60),
  final Map<String, dynamic> defaultQueryParams = const {},
  final Map<String, String> staticHeaders = const {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
  final List<Interceptor> interceptors = const [],
  final String defaultContentType = 'application/json',
  final int maxRetries = 3,
  final Duration retryInterval = const Duration(seconds: 3),
  final List<int> retryOnStatusCodes = const [500, 502, 503, 504],
  final bool enableCache = false,
  final Duration cacheDuration = const Duration(minutes: 5),
  final bool enableRetry = true,
  final bool followRedirects = true,
  final int maxRedirects = 5,
  final bool enableTokenInjection = true,
  final bool enableRefreshTokenBehavior = true,
}) extends Equatable {

  @override
  List<Object?> get props => [
        baseUrl,
        connectTimeout,
        sendTimeout,
        receiveTimeout,
        staticHeaders,
        defaultQueryParams,
        defaultContentType,
        maxRetries,
        retryInterval,
        retryOnStatusCodes,
        enableCache,
        cacheDuration,
        followRedirects,
        maxRedirects,
        enableRetry,
        excludedPaths,
        authInterceptorType,
        refreshTokenApiEndpoint,
        accessTokenKey,
        refreshTokenKey,
        enableTokenInjection,
        enableRefreshTokenBehavior,
      ];
}
