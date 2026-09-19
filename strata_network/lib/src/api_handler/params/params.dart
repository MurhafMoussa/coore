import 'package:equatable/equatable.dart';

/// Empty parameter class for requests requiring no arguments.
class const NoParams() extends Equatable {
  factory NoParams.fromJson(Map<String, dynamic> json) => const NoParams();

  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}

/// Simple parameter class holding a single string ID.
class const IdParam({required final String id}) extends Equatable {
  factory IdParam.fromJson(Map<String, dynamic> json) =>
      IdParam(id: json['id'] as String? ?? '');

  Map<String, dynamic> toJson({String? idKey}) => {idKey ?? 'id': id};

  @override
  List<Object?> get props => [id];
}

/// Abstract contract for pagination request parameters.
abstract class PaginationParams {
  int get batch;
  int get limit;
}

/// Default implementation of [PaginationParams].
class const DefaultPaginationParams({
  @override final int batch = 1,
  @override final int limit = 10,
}) extends Equatable implements PaginationParams {
  factory DefaultPaginationParams.fromJson(Map<String, dynamic> json) {
    return DefaultPaginationParams(
      batch: json['batch'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {'batch': batch, 'limit': limit};

  @override
  List<Object?> get props => [batch, limit];
}
