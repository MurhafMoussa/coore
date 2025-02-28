/// Simple lock mechanism for synchronous operations
class Lock {
  bool _locked = false;

  Future<void> synchronized(Function() func) async {
    while (_locked) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    _locked = true;
    try {
      func();
    } finally {
      _locked = false;
    }
  }
}
