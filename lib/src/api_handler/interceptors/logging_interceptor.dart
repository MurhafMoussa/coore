import 'dart:convert';

import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    required this.logger,
    this.maxBodyLength = 1024,
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
  });
  final CoreLogger logger;

  final int maxBodyLength;
  final bool logRequest;
  final bool logResponse;
  final bool logError;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      final message = _formatRequest(options);
      logger.warning(message);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      final message = _formatResponse(response);
      logger.info(message);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      final message = _formatError(err);
      logger.error(message);
    }
    super.onError(err, handler);
  }

  String _formatRequest(RequestOptions options) {
    final buffer =
        StringBuffer()
          ..writeln('*** Request ***')
          ..writeln('[${options.method}] ${options.uri}');

    // Headers
    if (options.headers.isNotEmpty) {
      buffer.writeln('Headers:');
      options.headers.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }

    // Query Parameters
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('Query Parameters:');
      options.queryParameters.forEach(
        (key, value) => buffer.writeln('  $key: $value'),
      );
    }

    // Body
    if (options.data != null) {
      buffer.writeln('Body:');
      if (options.data is FormData) {
        _formatFormData(options.data as FormData, buffer);
      } else {
        final body = _convertData(options.data);
        buffer.writeln(body);
      }
    }

    buffer.writeln('*** End Request ***');
    return buffer.toString();
  }

  String _formatResponse(Response response) {
    final buffer =
        StringBuffer()
          ..writeln('*** Response ***')
          ..writeln('[${response.statusCode}] ${response.requestOptions.uri}');

    // Headers
    if (!response.headers.isEmpty) {
      buffer.writeln('Headers:');
      response.headers.forEach((name, values) {
        buffer.writeln('  $name: $values');
      });
    }

    // Body
    if (response.data != null) {
      buffer
        ..writeln('Body:')
        ..writeln(_convertData(response.data));
    }

    buffer.writeln('*** End Response ***');
    return buffer.toString();
  }

  String _formatError(DioException err) {
    final buffer =
        StringBuffer()
          ..writeln('*** Error ***')
          ..writeln('[${err.type}] ${err.message}')
          ..writeln('URI: ${err.requestOptions.uri}');

    if (err.response != null) {
      buffer.writeln('Status Code: ${err.response?.statusCode}');
    }

    if (err.error != null) {
      buffer
        ..writeln('Error Details:')
        ..writeln(err.response?.data);
    }

    buffer
      ..writeln('Stack Trace:')
      ..writeln(err.stackTrace.toString())
      ..writeln('*** End Error ***');
    return buffer.toString();
  }

  void _formatFormData(FormData formData, StringBuffer buffer) {
    buffer.writeln('FormData:');
    if (formData.fields.isNotEmpty) {
      buffer.writeln('Fields:');
      for (final field in formData.fields) {
        buffer.writeln('  ${field.key}: ${field.value}');
      }
    }
    if (formData.files.isNotEmpty) {
      buffer.writeln('Files:');
      for (final file in formData.files) {
        buffer.writeln(
          '  ${file.key}: ${file.value.filename} '
          '(Content-Type: ${file.value.contentType}, '
          'Length: ${file.value.length} bytes)',
        );
      }
    }
  }

  String _convertData(dynamic data) {
    if (data == null) return 'null';

    String dataStr;
    if (data is Map || data is List) {
      try {
        dataStr = const JsonEncoder.withIndent('  ').convert(data);
      } catch (_) {
        dataStr = data.toString();
      }
    } else {
      dataStr = data.toString();
    }

    if (dataStr.length > maxBodyLength) {
      dataStr = '${dataStr.substring(0, maxBodyLength)}... [trimmed]';
    }
    return dataStr;
  }
}
