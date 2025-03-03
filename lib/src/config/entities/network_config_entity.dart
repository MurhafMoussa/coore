import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class NetworkConfigEntity extends Equatable {

  const NetworkConfigEntity({
    required this.baseUrl,

    this.connectTimeout = const Duration(seconds: 10),
    this.sendTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
    this.enableLogging = false,
    this.staticHeaders = const {},
    this.defaultQueryParams = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    this.interceptors = const [],
    this.defaultContentType = 'application/json',
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 1),
    this.retryOnStatusCodes = const [500, 502, 503, 504],
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

  /// Enable detailed request/response logging
  final bool enableLogging;

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
  final List<Interceptor> interceptors;

  @override
  List<Object?> get props => [
    baseUrl,

    connectTimeout,
    sendTimeout,
    receiveTimeout,
    enableLogging,

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
