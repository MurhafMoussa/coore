import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'network_status_interface.dart';

class NetworkStatusImp implements NetworkStatusInterface {
  final InternetConnection _internetConnection;
  final StreamController<ConnectionStatus> _controller =
      StreamController<ConnectionStatus>.broadcast();
  StreamSubscription<InternetStatus>? _subscription;

  NetworkStatusImp(this._internetConnection) {
    _init();
  }

  @override
  Stream<ConnectionStatus> get connectionStream => _controller.stream;

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }

  @override
  Future<bool> get isConnected async =>
      await _internetConnection.hasInternetAccess;

  Future<void> _init() async {
    _subscription = _internetConnection.onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          _controller.add(ConnectionStatus.connected);
        case InternetStatus.disconnected:
          _controller.add(ConnectionStatus.disconnected);
      }
    })..onError((_, _) {
      _controller.add(ConnectionStatus.disconnected);
    });
  }
}
