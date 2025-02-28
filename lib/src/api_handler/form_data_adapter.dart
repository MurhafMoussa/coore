import 'package:dio/dio.dart';

/// An adapter for creating multipart form data.
///
/// This interface abstracts the process of converting a map of key-value
/// pairs into a [FormData] object suitable for sending multipart/form-data
/// HTTP requests. It is useful for ensuring that your application can
/// easily swap out implementations if needed.
abstract class FormDataAdapter {
  /// Creates a [FormData] instance from the provided [data] map.
  ///
  /// The [data] map should contain key-value pairs where values can be
  /// primitive types, lists, or [MultipartFile] instances. The returned
  /// [dynamic type] is ready to be used in an HTTP request.
  dynamic createFormData(Map<String, dynamic> data);
}

/// A Dio-based implementation of the [FormDataAdapter] interface.
///
/// This implementation leverages Dio's [FormData.fromMap] constructor
/// to build a multipart form data object from a map of key-value pairs.
class DioFormDataAdapter implements FormDataAdapter {
  /// Creates and returns a [FormData] object from the provided [data] map.
  ///
  /// This method uses Dio's [FormData.fromMap] to convert the input data into
  /// a [FormData] instance, which is then suitable for use in a multipart
  /// HTTP request.
  @override
  FormData createFormData(Map<String, dynamic> data) {
    return FormData.fromMap(data);
  }
}
