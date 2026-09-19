import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../config/theme_config_entity.dart';

/// Persistent Hydrated Cubit for theme state management.
class ThemeCubit extends HydratedCubit<ThemeConfigEntity> {
  ThemeCubit({ThemeConfigEntity? initialConfig})
      : super(initialConfig ?? ThemeConfigEntity.defaultConfig());

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode, enableAutoSwitch: false));
  }

  void toggleTheme() {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    setThemeMode(nextMode);
  }

  @override
  ThemeConfigEntity? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeConfigEntity.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeConfigEntity state) {
    return state.toJson();
  }
}
