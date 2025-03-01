extension OneAKindList<T> on List<T> {
  /// Returns `true` if all elements are equal.
  bool get isOneAKind {
    if (isEmpty) return false;
    return every((element) => element == first);
  }
}
