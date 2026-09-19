import 'package:dio/dio.dart';

/// Adapter interface for creating multipart/form-data payloads.
abstract class FormDataAdapter {
  /// Creates a [FormData] instance.
  FormData create();
}
