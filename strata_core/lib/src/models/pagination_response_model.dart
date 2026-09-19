abstract class MetaModel {
  const MetaModel();
}

class NoMetaModel extends MetaModel {
  const NoMetaModel();
}

class PaginationResponseModel<T, M extends MetaModel> {
  const PaginationResponseModel({
    this.data = const [],
    this.meta,
  });

  final List<T> data;
  final M? meta;
}
