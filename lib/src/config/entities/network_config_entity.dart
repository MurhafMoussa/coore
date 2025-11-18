import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class NetworkConfigEntity extends Equatable {
  const NetworkConfigEntity({
    required this.baseUrl,
    required this.excludedPaths,
    required this.refreshTokenApiEndpoint,
    required this.accessTokenKey,
    required this.refreshTokenKey,
    this.authInterceptorType = AuthInterceptorType.cookieBased,
    this.connectTimeout = const Duration(seconds: 60),
    this.sendTimeout = const Duration(seconds: 60),
    this.receiveTimeout = const Duration(seconds: 60),

    this.defaultQueryParams = const {},
    this.staticHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    this.interceptors = const [],
    this.defaultContentType = 'application/json',
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 3),
    this.retryOnStatusCodes = const [500, 502, 503, 504],
    this.requestEncoder,
    this.responseDecoder,
    this.enableCache = false,
    this.cacheDuration = const Duration(minutes: 5),

    this.followRedirects = true,
    this.maxRedirects = 5,
  });

  /// Base URL for API endpoints (e.g., "https://api.example.com")
  final String baseUrl;

  /// Timeout for establishing server connections
  final Duration connectTimeout;

  /// Timeout for sending data to the server
  final Duration sendTimeout;

  /// Timeout for receiving server responses
  final Duration receiveTimeout;

  /// Static headers added to every request
  final Map<String, String> staticHeaders;

  /// Default query parameters for requests
  final Map<String, dynamic> defaultQueryParams;

  /// Default content type for requests
  final String defaultContentType;

  /// Maximum number of automatic retries
  final int maxRetries;

  /// Delay between retry attempts
  final Duration retryInterval;

  /// HTTP status codes triggering retries (default 5xx errors)
  final List<int> retryOnStatusCodes;

  /// Enable response caching mechanism
  final bool enableCache;

  /// Cache validity duration
  final Duration cacheDuration;

  /// Automatic redirect following configuration
  final bool followRedirects;

  /// Maximum allowed redirects
  final int maxRedirects;

  /// Interceptors to be added to the Dio instance
  final List<Interceptor> interceptors;

  /// Authentication interceptor type
  final AuthInterceptorType authInterceptorType;

  /// Request encoder
  final RequestEncoder? requestEncoder;

  /// Response decoder
  final ResponseDecoder? responseDecoder;
  /// Refresh token API endpoint
  final String refreshTokenApiEndpoint;
  /// Access token key
  final String accessTokenKey;
  /// Refresh token key
  final String refreshTokenKey;
  /// Excluded paths that won't trigger the refresh token flow on 401 errors
  final List<String> excludedPaths;
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
  ];
}

enum AuthInterceptorType { tokenBased, cookieBased }
