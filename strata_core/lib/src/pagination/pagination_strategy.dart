abstract class PaginationStrategy {
  PaginationStrategy({required this.limit});

  final int limit;
  int get nextBatch;
  void reset();
  void increment();
  void decrement();

  void incrementByOne() {}
  void decrementByOne() {}
  bool get isFirst;
}

class SkipPaginationStrategy extends PaginationStrategy {
  SkipPaginationStrategy({super.limit = 20});

  int skip = 0;

  @override
  int get nextBatch => skip;

  @override
  void reset() {
    skip = 0;
  }

  @override
  void increment() {
    skip += limit;
  }

  @override
  void decrement() {
    skip -= limit;
  }

  @override
  void incrementByOne() {
    skip += 1;
  }

  @override
  void decrementByOne() {
    if (skip > 0) skip -= 1;
  }

  @override
  bool get isFirst => skip == 0;
}

class PagePaginationStrategy extends PaginationStrategy {
  PagePaginationStrategy({super.limit = 20});

  int page = 1;

  @override
  int get nextBatch => page;

  @override
  void reset() {
    page = 1;
  }

  @override
  void increment() {
    page += 1;
  }

  @override
  void decrement() {
    if (page > 1) page -= 1;
  }

  @override
  void incrementByOne() {
    increment();
  }

  @override
  void decrementByOne() {
    decrement();
  }

  @override
  bool get isFirst => page == 1;
}
