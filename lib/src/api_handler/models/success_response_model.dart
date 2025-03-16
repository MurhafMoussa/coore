import 'package:coore/src/api_handler/models/pagination_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'success_response_model.freezed.dart';
part 'success_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class SuccessResponseModel<T> with _$SuccessResponseModel<T> {
  const factory SuccessResponseModel({
    @JsonKey(name: 'products')
    required T data, // Will be renamed to 'data' later
  }) = _SuccessResponseModel<T>;

  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$SuccessResponseModelFromJson(json, fromJsonT);

  // Helper to safely convert JSON while preserving type information
  static T _safeFromJson<T>(
    Object? json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Expected Map<String, dynamic> but got ${json.runtimeType}',
      );
    }
    return fromJson(json);
  }

  // Base data extractor
  static T getData<T>(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => SuccessResponseModel.fromJson(json, fromJsonT).data;

  // List data extractor with nested type safety
  static List<T> getList<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = getData<List<dynamic>>(
      json,
      (list) =>
          (list as List<dynamic>?)?.map((item) {
            return _safeFromJson(item, fromJson);
          }).toList() ??
          [],
    );
    return data.cast<T>();
  }

  // Paginated list extractor with full type safety
  static List<T> getPaginatedList<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final paginationData = getData<PaginationResponseModel<T>>(
      json,
      (paginationJson) => PaginationResponseModel<T>.fromJson(
        _safeFromJson(paginationJson, (json) => json),
        (item) => _safeFromJson(item, fromJson),
      ),
    );
    return paginationData.data;
  }

  // Primitive value extractor (for booleans, numbers, strings)
  static T getPrimitive<T>(
    Map<String, dynamic> json,
    T Function(Object?) converter,
  ) {
    return getData<T>(json, (value) {
      if (value is! T) {
        throw FormatException('Expected type $T but got ${value.runtimeType}');
      }
      return converter(value);
    });
  }
}
