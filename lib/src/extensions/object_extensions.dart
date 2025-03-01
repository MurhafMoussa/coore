extension ObjectExtensions on Object? {
  /// Checks if the object is null.
  bool get isNull => this == null;

  /// Checks if a String, Iterable, or Map is null or “blank”.
  /// For String, blank means empty or only whitespace.
  bool get isNullOrBlank {
    if (this == null) return true;
    if (this is String) return (this as String).trim().isEmpty;
    if (this is Iterable || this is Map) return (this as dynamic).isEmpty;
    return false;
  }

  /// Checks if a String, Iterable, or Map is blank.
  bool get isBlank {
    if (this == null) return true;
    if (this is String) return (this as String).trim().isEmpty;
    if (this is Iterable || this is Map) return (this as dynamic).isEmpty;
    return false;
  }
}

/// Extension for obtaining a “dynamic length” from values that are
/// String, Iterable, Map, int, or double.
extension LengthExtensions on Object? {
  /// Returns length if applicable.
  /// For int/double, length of its string representation is returned.
  int? get dynamicLength {
    if (this == null) return null;
    if (this is String || this is Iterable || this is Map) {
      return (this as dynamic).length as int;
    }
    if (this is int) return this.toString().length;
    if (this is double) return this.toString().replaceAll('.', '').length;
    return null;
  }

  bool isLengthGreaterThan(int maxLength) =>
      dynamicLength != null ? dynamicLength! > maxLength : false;

  bool isLengthGreaterOrEqual(int maxLength) =>
      dynamicLength != null ? dynamicLength! >= maxLength : false;

  bool isLengthLessThan(int maxLength) =>
      dynamicLength != null ? dynamicLength! < maxLength : false;

  bool isLengthLessOrEqual(int maxLength) =>
      dynamicLength != null ? dynamicLength! <= maxLength : false;

  bool isLengthEqualTo(int otherLength) =>
      dynamicLength != null ? dynamicLength! == otherLength : false;

  bool isLengthBetween(int minLength, int maxLength) =>
      this != null &&
      isLengthGreaterOrEqual(minLength) &&
      isLengthLessOrEqual(maxLength);
}
