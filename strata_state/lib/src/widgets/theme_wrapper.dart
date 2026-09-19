import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../config/theme_config_entity.dart';
import '../theme/theme_cubit.dart';

/// A wrapper widget that provides [ThemeCubit] to the widget tree
/// and builds UI components controlled by the cubit's theme state.
class ThemeWrapper extends StatelessWidget {
  const ThemeWrapper({
    super.key,
    required this.builder,
    this.themeCubit,
  });

  final Widget Function(BuildContext context, ThemeConfigEntity themeConfig)
      builder;
  final ThemeCubit? themeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (_) => themeCubit ?? GetIt.I<ThemeCubit>(),
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
