import 'package:coore/src/api_handler/models/pagination_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'success_response_model.freezed.dart';
part 'success_response_model.g.dart';

/// {@template success_response_model}
/// The [SuccessResponseModel] is a generic response model for handling
/// successful API responses. It leverages the [Freezed] package for immutability
/// and code generation.
///
/// **Generic usage:**
/// - **T as a concrete type:** Directly extracting a single object.
/// - **T as a List:** Parsing lists of objects.
/// - **T as a [PaginationResponseModel]:** Handling paginated data responses.
///
/// **Note:** The key for extracting data from JSON is defined by [kDataKey].
/// It is currently set to `'data'` but can be changed to `'data'` if required.
/// {@endtemplate}
@Freezed(genericArgumentFactories: true)
abstract class SuccessResponseModel<T> with _$SuccessResponseModel<T> {
  /// Creates an instance of [SuccessResponseModel] from JSON.

  const factory SuccessResponseModel({required T data}) =
      _SuccessResponseModel<T>;

  /// Generates a [SuccessResponseModel] instance from a JSON [Map].
  ///
  /// The [fromJsonT] function is a converter used to transform the dynamic JSON
  /// value into the expected type [T].
  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => _$SuccessResponseModelFromJson(json, fromJsonT);

  /// Private helper that extracts the relevant portion of the JSON response.
  ///
  /// It uses [wrapperKey] (default is `'data'`) to extract the main payload.
  /// If [dataKey] is provided, it will further extract the nested data from
  /// `json[wrapperKey][dataKey]`.
  static T _dataFieldExtractor<T>(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT, {
    String wrapperKey = 'data',
    String? dataKey,
  }) {
    late final dynamic dataContent;
    if (dataKey != null) {
      if (json[wrapperKey] is Map<String, dynamic>) {
        dataContent = (json[wrapperKey] as Map<String, dynamic>)[dataKey];
      } else {
        throw FormatException(
          "Expected '$wrapperKey' to be a Map<String, dynamic> but got ${json[wrapperKey].runtimeType}",
        );
      }
    } else {
      dataContent = json[wrapperKey];
    }
    return SuccessResponseModel<T>.fromJson({
      wrapperKey: dataContent,
    }, (innerJson) => fromJsonT(innerJson)).data;
  }

  /// Extracts the data of type [T] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// final jsonResponse = {
  ///   'data': {'id': 1, 'name': 'Example Product'}
  /// };
  /// final product = SuccessResponseModel.getData&lt;Product&gt;(
  ///   jsonResponse,
  ///   (data) => data ,
  /// );
  /// ```
  static T getData<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) => _dataFieldExtractor(
    json,
    (innerJson) => fromJsonT(innerJson as Map<String, dynamic>),
  );

  /// Extracts a list of type [T] from the JSON response.
  ///
  /// Uses the private helper [_parseList] to validate and convert each item.
  ///
  /// Example:
  /// ```dart
  /// final jsonResponse = {
  ///   'data': [
  ///     {'id': 1, 'name': 'Product 1'},
  ///     {'id': 2, 'name': 'Product 2'},
  ///   ]
  /// };
  /// final productList = SuccessResponseModel.getList&lt;Product&gt;(
  ///   jsonResponse,
  ///   (item) => item, // In a real example, convert map to your model
  /// );
  /// ```
  static List<T> getList<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemConverter,
  ) {
    try {
      return _dataFieldExtractor<List<T>>(
        json,
        (data) => _parseList(data, itemConverter),
      );
    } catch (e) {
      throw FormatException('Failed to parse list: $e');
    }
  }

  /// Extracts a primitive value of type [T] from the JSON response.
  ///
  /// The [converter] function is used to convert the dynamic JSON value into [T].
  ///
  /// Example:
  /// ```dart
  /// final jsonResponse = {
  ///   'data': 42
  /// };
  /// final number = SuccessResponseModel.getPrimitive<int>(
  ///   jsonResponse,
  ///   (data) => data,
  /// );
  /// ```
  static T getPrimitive<T>(
    Map<String, dynamic> json,
    T Function(Object?) converter,
  ) => _dataFieldExtractor<T>(json, converter);

  /// Private helper that parses a JSON array into a [List] of [T].
  ///
  /// Throws a [FormatException] if [data] is not a List or if any item is not a JSON map.
  static List<T> _parseList<T>(
    Object? data,
    T Function(Map<String, dynamic>) converter,
  ) {
    if (data is! List<dynamic>) {
      throw FormatException('Expected list but got ${data.runtimeType}');
    }

    return data.map<T>((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('List item is not a map: ${item.runtimeType}');
      }
      return converter(item);
    }).toList();
  }
}
