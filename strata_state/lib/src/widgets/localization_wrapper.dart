import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../localization/localization_cubit.dart';

/// A wrapper widget that provides [LocalizationCubit] to the widget tree
/// and builds UI components controlled by the cubit's locale state.
class LocalizationWrapper extends StatelessWidget {
  const LocalizationWrapper({
    super.key,
    required this.builder,
    this.listener,
    this.localizationCubit,
  });

  final BlocWidgetBuilder<Locale> builder;
  final BlocWidgetListener<Locale>? listener;
  final LocalizationCubit? localizationCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocalizationCubit>(
      create: (_) => localizationCubit ?? GetIt.I<LocalizationCubit>(),
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
