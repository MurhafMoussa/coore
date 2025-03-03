import 'package:dio/dio.dart';

class CacheEntry {

  CacheEntry({
    required this.data,
    required this.headers,
    required this.statusCode,
    required this.statusMessage,
    required this.expiresAt,
    required this.timestamp,
  });

  factory CacheEntry.fromResponse(Response response, Duration duration) {
    return CacheEntry(
      data: response.data,
      headers: response.headers,
      statusCode: response.statusCode ?? 200,
      statusMessage: response.statusMessage ?? '',
      expiresAt: DateTime.now().add(duration),
      timestamp: DateTime.now(),
    );
  }
  final dynamic data;
  final Headers headers;
  final int statusCode;
  final String statusMessage;
  final DateTime expiresAt;
  final DateTime timestamp;

  Response<dynamic> toResponse(RequestOptions options) {
    return Response<dynamic>(
      data: data,
      headers: headers,
      statusCode: statusCode,
      statusMessage: statusMessage,
      requestOptions: options,
      extra: {'fromCache': true},
    );
  }
}
