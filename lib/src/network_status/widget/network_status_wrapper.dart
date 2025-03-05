import 'package:coore/lib.dart';
import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:coore/src/network_status/cubit/network_status_cubit.dart';
import 'package:coore/src/network_status/service/network_status_interface.dart';
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
              switch (status) {
                case ConnectionStatus.connected:
                  {
                    if (onConnect != null) {
                      onConnect!();
                    } else {
                      context.scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'You are online!',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: context.colorScheme.primary,
                        ),
                      );
                    }
                  }
                case ConnectionStatus.disconnected:
                  {
                    if (onDisconnect != null) {
                      onDisconnect!();
                    } else {
                      context.scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'You are offline',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: context.colorScheme.error,
                        ),
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
