import 'dart:async';

import 'package:coore/src/network_status/service/network_status_interface.dart';
import 'package:coore/src/src.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkStatusImp implements NetworkStatusInterface {
  NetworkStatusImp(this._internetConnection, this._logger) {
    _init();
  }
  final InternetConnection _internetConnection;
  final CoreLogger _logger;
  final StreamController<ConnectionStatus> _controller =
      StreamController<ConnectionStatus>.broadcast();
  StreamSubscription<InternetStatus>? _subscription;

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

          break;
        case InternetStatus.disconnected:
          _controller.add(ConnectionStatus.disconnected);
          break;
      }
    })..onError((e, s) {
      _logger.error('Some thing went wrong in NetworkStatus', e, s);
    });
  }
}
