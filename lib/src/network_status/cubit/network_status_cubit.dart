import 'dart:async';

import 'package:coore/src/network_status/service/network_status_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A Cubit that manages the current network connection status.
///
/// It listens to changes from [NetworkStatusInterface.connectionStream]
/// and emits corresponding [ConnectionStatus] updates.
class NetworkStatusCubit extends Cubit<ConnectionStatus> {

  /// Creates a new [NetworkStatusCubit] with the provided [NetworkStatusInterface].
  ///
  /// The cubit initializes with an initial connection status and subscribes to
  /// further updates from the network status service.
  NetworkStatusCubit({required NetworkStatusInterface networkStatus})
    : _networkStatus = networkStatus,
      super(ConnectionStatus.disconnected) {
    _initialize();
  }
  final NetworkStatusInterface _networkStatus;
  late final StreamSubscription<ConnectionStatus> _subscription;

  /// Initializes the cubit by checking the current connection status and
  /// subscribing to changes from the network status stream.
  Future<void> _initialize() async {
    // Get the initial connection status.
    final connected = await _networkStatus.isConnected;
    emit(
      connected ? ConnectionStatus.connected : ConnectionStatus.disconnected,
    );

    // Listen to connection changes and emit them.
    _subscription = _networkStatus.connectionStream.listen((status) {
      emit(status);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _networkStatus.dispose();
    return super.close();
  }
}
