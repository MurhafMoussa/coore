import 'package:coore/src/dependency_injection/dependency_injection.dart';
import 'package:coore/src/ui/message_viewers/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/network_status_cubit.dart';
import '../service/network_status_interface.dart';

/// A widget that wraps the app and displays network connectivity status.
///
/// [NetworkStatusWrapper] provides a [NetworkStatusCubit]
/// It then listens to connectivity changes and, if
/// the device is disconnected, displays a banner at the bottom of the screen.
class NetworkStatusWrapper extends StatelessWidget {
  /// The widget to display as the main content (e.g., your MaterialApp).
  final Widget child;

  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  /// Creates a new [NetworkStatusWrapper].
  const NetworkStatusWrapper({
    super.key,
    required this.child,
    this.onConnect,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NetworkStatusCubit>(
      create: (_) => getIt<NetworkStatusCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<NetworkStatusCubit, ConnectionStatus>(
            listener: (context, status) {
              switch (status) {
                case ConnectionStatus.connected:
                  {
                    if (onConnect != null) {
                      onConnect!();
                    } else {
                      getIt<Toaster>().showToastNoContext(
                        message: 'You are online!',
                        backgroundColor: Colors.lightGreenAccent,
                        textColor: Colors.black54,
                      );
                    }
                  }
                case ConnectionStatus.disconnected:
                  {
                    if (onDisconnect != null) {
                      onDisconnect!();
                    } else {
                      getIt<Toaster>().showToastNoContext(
                        message:
                            'You are offline, check your internet connection',
                        backgroundColor: Theme.of(context).colorScheme.error,
                        textColor: Colors.white,
                      );
                    }
                  }
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}
