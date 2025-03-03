import 'dart:math';

extension IntExtensions on int {
  /// Returns `true` if all digits are the same.
  bool get isOneAKind {
    final s = toString();
    if (s.isEmpty) return false;
    final first = s[0];
    return s.runes.every((rune) => rune == first.codeUnitAt(0));
  }

  /// Generates a random string of [this] length.
  String get randomString {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        this,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }
}
