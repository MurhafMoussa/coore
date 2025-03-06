import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that wraps the app and displays network connectivity status.
///
/// [NetworkStatusWrapper] provides a [NetworkStatusCubit]
/// It then listens to connectivity changes and, if
/// the device is disconnected, displays a banner at the bottom of the screen.
class NetworkStatusWrapper extends StatelessWidget {
  /// Creates a new [NetworkStatusWrapper].
  const NetworkStatusWrapper({
    super.key,
    required this.child,
    this.onConnect,
    this.onDisconnect,
  });

  /// The widget to display as the main content (e.g., your MaterialApp).
  final Widget child;

  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NetworkStatusCubit>(
      create: (_) => getIt<NetworkStatusCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<NetworkStatusCubit, ConnectionStatus>(
            listener: (context, status) {
              ScaffoldMessenger.maybeOf(context);
              switch (status) {
                case ConnectionStatus.connected:
                  {
                    onConnect?.call();
                  }
                case ConnectionStatus.disconnected:
                  {
                    onDisconnect?.call();
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
