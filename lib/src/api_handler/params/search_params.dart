// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:coore/lib.dart';

class SearchParams extends BaseParams {
  const SearchParams({super.cancelTokenAdapter, required this.query});

  final String query;
  @override
  BaseParams attachCancelToken({
    CancelRequestAdapter? cancelTokenAdapter,
    String? query,
  }) => SearchParams(
    query: query ?? this.query,
    cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,

  );
   
  @override
  List<Object?> get props => [query];

  @override
  Map<String, dynamic> toJson() => {'query': query};

  SearchParams copyWith({
    String? query,
  }) {
    return SearchParams(
      query: query ?? this.query,
    );
  }
}
