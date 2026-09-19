/// Contract for disposable API state handlers managed by BLoC/Cubit state hosts.
abstract interface class DisposableApiStateHandlerInterface {
  /// Disposes resources held by the handler (e.g. pending requests).
  void dispose();
}
