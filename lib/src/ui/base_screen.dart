import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:coore/src/navigation/screen_params/base_screen_params.dart';
import 'package:flutter/material.dart';

/// Abstract base class for screens with parameter handling.
abstract class BaseStatefulScreen<T extends BaseScreenParams>
    extends StatefulWidget {
  const BaseStatefulScreen({required this.param, super.key});

  final T param;

  /// Factory method for creating a screen.
  static Widget createScreen<T extends BaseScreenParams>({
    required T param,
    required Widget Function(T param) successBuilder,
    Widget Function()? errorBuilder,
  }) {
    try {
      return successBuilder(param);
    } catch (e, trace) {
      getIt<CoreLogger>().error('Error in creating screen', e, trace);

      return errorBuilder?.call() ?? _defaultErrorScreen();
    }
  }

  /// Returns a default error screen widget.
  static Widget _defaultErrorScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('ROUTE ERROR CHECK THE ROUTE GENERATOR')),
    );
  }
}

abstract class BaseStatelessScreen<T extends BaseScreenParams>
    extends StatelessWidget {
  const BaseStatelessScreen({required this.param, super.key});

  final T param;

  /// Factory method for creating a screen.
  static Widget createScreen<T extends BaseScreenParams>({
    required T param,
    required Widget Function(T param) successBuilder,
    Widget Function()? errorBuilder,
  }) {
    try {
      return successBuilder(param);
    } catch (e, trace) {
      getIt<CoreLogger>().error('Error in creating screen', e, trace);

      return errorBuilder?.call() ?? _defaultErrorScreen();
    }
  }

  /// Returns a default error screen widget.
  static Widget _defaultErrorScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('ROUTE ERROR CHECK THE ROUTE GENERATOR')),
    );
  }
}
