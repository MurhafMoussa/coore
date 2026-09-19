import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strata_core/strata_core.dart';

/// A Cubit that manages the current network connection status.
class NetworkStatusCubit extends Cubit<ConnectionStatus> {
  NetworkStatusCubit({required NetworkStatusInterface networkStatus})
      : _networkStatus = networkStatus,
        super(ConnectionStatus.connected) {
    _initialize();
  }

  final NetworkStatusInterface _networkStatus;
  late final StreamSubscription<ConnectionStatus> _subscription;

  Future<void> _initialize() async {
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
