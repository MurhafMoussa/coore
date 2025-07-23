import 'package:coore/src/config/entities/theme_config_entity.dart';
import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:coore/src/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper widget that provides [ThemeCubit] to the widget tree
/// and builds a [MaterialApp] whose theme mode is controlled by the cubit's state.
class ThemeWrapper extends StatelessWidget {
  const ThemeWrapper({super.key, required this.builder});

  /// The builder that will wrap the material app.
  final Widget Function(BuildContext context, ThemeConfigEntity themeConfig)
  builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => getIt<ThemeCubit>(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeConfigEntity>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode ||
                previous.enableAutoSwitch != current.enableAutoSwitch,
            builder: builder,
          );
        },
      ),
    );
  }
}
