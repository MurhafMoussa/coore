/// Abstract base for all pagination strategies
abstract class PaginationParams {
  int get batch;

  int get limit;
}
