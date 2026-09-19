import 'package:equatable/equatable.dart';

/// Empty parameter class for requests requiring no arguments.
class NoParams extends Equatable {
  const NoParams();

  factory NoParams.fromJson(Map<String, dynamic> json) => const NoParams();

  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}

/// Simple parameter class holding a single string ID.
class IdParam extends Equatable {
  const IdParam({required this.id});

  final String id;

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
class DefaultPaginationParams extends Equatable implements PaginationParams {
  const DefaultPaginationParams({this.batch = 1, this.limit = 10});

  @override
  final int batch;

  @override
  final int limit;

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
