/// Simple lock mechanism for synchronous operations
class Lock {
  bool _locked = false;

  Future<T> synchronized<T>(Future<T> Function() func) async {
    while (_locked) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    _locked = true;
    try {
      return await func();
    } finally {
      _locked = false;
    }
  }
}
