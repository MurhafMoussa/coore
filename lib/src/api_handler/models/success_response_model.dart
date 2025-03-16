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
/// It is currently set to `'products'` but can be changed to `'data'` if required.
/// {@endtemplate}
@Freezed(genericArgumentFactories: true)
abstract class SuccessResponseModel<T> with _$SuccessResponseModel<T> {
  /// Creates an instance of [SuccessResponseModel] from JSON.

  const factory SuccessResponseModel({
    @JsonKey(name: 'products') required T data,
  }) = _SuccessResponseModel<T>;

  /// Generates a [SuccessResponseModel] instance from a JSON [Map].
  ///
  /// The [fromJsonT] function is a converter used to transform the dynamic JSON
  /// value into the expected type [T].
  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => _$SuccessResponseModelFromJson(json, fromJsonT);

  /// Extracts the data of type [T] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// final jsonResponse = {
  ///   'products': {'id': 1, 'name': 'Example Product'}
  /// };
  /// final product = SuccessResponseModel.getData<Map<String, dynamic>>(
  ///   jsonResponse,
  ///   (data) => data as Map<String, dynamic>,
  /// );
  /// ```
  static T getData<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) =>
      SuccessResponseModel<T>.fromJson(
        json,
        (innerJson) => fromJsonT(innerJson),
      ).data;

  /// Extracts a list of type [T] from the JSON response.
  ///
  /// Uses the private helper [_parseList] to validate and convert each item.
  ///
  /// Example:
  /// ```dart
  /// final jsonResponse = {
  ///   'products': [
  ///     {'id': 1, 'name': 'Product 1'},
  ///     {'id': 2, 'name': 'Product 2'},
  ///   ]
  /// };
  /// final productList = SuccessResponseModel.getList<Map<String, dynamic>>(
  ///   jsonResponse,
  ///   (item) => item, // In a real example, convert map to your model
  /// );
  /// ```
  static List<T> getList<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemConverter,
  ) {
    try {
      return getData<List<T>>(json, (data) => _parseList(data, itemConverter));
    } catch (e) {
      throw FormatException('Failed to parse list: $e');
    }
  }

  /// Extracts a paginated list of type [T] from the JSON response.
  ///
  /// This method expects the JSON to represent a paginated response and uses the
  /// private helper [_parsePagination] to convert the nested pagination object.
  ///
  /// Example:
  /// ```dart
  /// // Assume jsonResponse contains paginated data in the 'products' key.
  /// final jsonResponse = {
  ///   'products': {
  ///     'data': [
  ///       {'id': 1, 'name': 'Paginated Product 1'},
  ///       {'id': 2, 'name': 'Paginated Product 2'},
  ///     ],
  ///     'currentPage': 1,
  ///     'totalPages': 5,
  ///   }
  /// };
  /// final paginatedList = SuccessResponseModel.getPaginatedList<Map<String, dynamic>>(
  ///   jsonResponse,
  ///   (item) => item, // Replace with a proper conversion to your model
  /// );
  /// ```
  static List<T> getPaginatedList<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemConverter,
  ) {
    try {
      final pagination = getData<PaginationResponseModel<T>>(
        json,
        (data) => _parsePagination(data, itemConverter),
      );
      return pagination.data;
    } catch (e) {
      throw FormatException('Failed to parse paginated list: $e');
    }
  }

  /// Extracts a primitive value of type [T] from the JSON response.
  ///
  /// The [converter] function is used to convert the dynamic JSON value into [T].
  ///
  /// Example:
  /// ```dart
  /// final jsonResponse = {
  ///   'products': 42
  /// };
  /// final number = SuccessResponseModel.getPrimitive<int>(
  ///   jsonResponse,
  ///   (data) => data as int,
  /// );
  /// ```
  static T getPrimitive<T>(
    Map<String, dynamic> json,
    T Function(Object?) converter,
  ) => getData<T>(json, converter);

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

  /// Private helper that parses a JSON map into a [PaginationResponseModel] of [T].
  ///
  /// Throws a [FormatException] if [data] is not a JSON map or if any item within
  /// the pagination data is not a JSON map.
  static PaginationResponseModel<T> _parsePagination<T>(
    Object? data,
    T Function(Map<String, dynamic>) converter,
  ) {
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Expected pagination map but got ${data.runtimeType}',
      );
    }

    return PaginationResponseModel<T>.fromJson(data, (item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException(
          'Pagination item is not a map: ${item.runtimeType}',
        );
      }
      return converter(item);
    });
  }
}
