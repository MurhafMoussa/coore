import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:strata_core/strata_core.dart';

import '../network/network_status_cubit.dart';

/// A widget that wraps the app and provides network status callbacks.
class NetworkStatusWrapper extends StatelessWidget {
  const NetworkStatusWrapper({
    super.key,
    required this.child,
    this.onConnect,
    this.onDisconnect,
    this.networkStatusCubit,
  });

  final Widget child;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final NetworkStatusCubit? networkStatusCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NetworkStatusCubit>(
      create: (_) => networkStatusCubit ?? GetIt.I<NetworkStatusCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<NetworkStatusCubit, ConnectionStatus>(
            listener: (context, status) {
              switch (status) {
                case ConnectionStatus.connected:
                  onConnect?.call();
                  break;
                case ConnectionStatus.disconnected:
                  onDisconnect?.call();
                  break;
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}
