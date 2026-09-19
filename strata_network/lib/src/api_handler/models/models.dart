export 'base_error_response_model.dart';

/// Abstract meta model for pagination metadata.
abstract class MetaModel {
  const MetaModel();
}

/// Default empty meta model.
class NoMetaModel extends MetaModel {
  const NoMetaModel();
}

/// Model wrapping paginated data and optional metadata.
class PaginationResponseModel<T, M extends MetaModel> {
  const PaginationResponseModel({
    this.data = const [],
    this.meta,
  });

  final List<T> data;
  final M? meta;

  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT, {
    M Function(Map<String, dynamic> json)? fromJsonM,
  }) {
    final rawData = json['data'] as List<dynamic>? ?? [];
    final parsedData = rawData
        .whereType<Map<String, dynamic>>()
        .map(fromJsonT)
        .toList();

    M? meta;
    if (fromJsonM != null && json.containsKey('meta') && json['meta'] != null) {
      meta = fromJsonM(json['meta'] as Map<String, dynamic>);
    } else if (M == NoMetaModel) {
      meta = const NoMetaModel() as M;
    }

    return PaginationResponseModel(
      data: parsedData,
      meta: meta,
    );
  }
}
