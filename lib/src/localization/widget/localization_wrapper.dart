import 'package:coore/src/dependency_injection/di_container.dart';
import 'package:coore/src/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper widget that provides [LocalizationCubit] to the widget tree
/// and builds a [MaterialApp] whose locale is controlled by the cubit's state.
class LocalizationWrapper extends StatelessWidget {
  const LocalizationWrapper({super.key, required this.builder, this.listener});

  /// The builder that will wrap the material app.
  final BlocWidgetBuilder<Locale> builder;

  /// The listener that will wrap the material app.
  final BlocWidgetListener<Locale>? listener;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocalizationCubit>(
      create: (context) => getIt<LocalizationCubit>(),
      child: Builder(
        builder: (context) {
          return BlocConsumer<LocalizationCubit, Locale>(
            builder: builder,
            listener: listener ?? (context, state) {},
          );
        },
      ),
    );
  }
}
