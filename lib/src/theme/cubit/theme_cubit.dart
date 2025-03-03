import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coore/src/config/service/config_service.dart';
import 'package:flutter/material.dart';

import '../../config/entities/theme_config_entity.dart';

class ThemeCubit extends Cubit<ThemeConfigEntity> {
  final ConfigService _configService;
  final ThemeConfigEntity _configEntity;
  Timer? _autoSwitchTimer;

  ThemeCubit({
    required ConfigService repository,
    required ThemeConfigEntity themeConfigEntity,
  }) : _configService = repository,
       _configEntity = themeConfigEntity,

       super(ThemeConfigEntity.defaultConfig()) {
    _init();
  }

  Future<void> _init() async {
    final savedThemeMode = await _configService.getThemeMode();
    emit(_configEntity.copyWith(themeMode: savedThemeMode));
    if (_configEntity.enableAutoSwitch) _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _autoSwitchTimer?.cancel();
    _autoSwitchTimer = Timer.periodic(const Duration(minutes: 20), (_) {
      _updateThemeBasedOnTime();
    });
    _updateThemeBasedOnTime(); // Initial check
  }

  void _updateThemeBasedOnTime() {
    final currentHour = DateTime.now().hour;
    final isNight = currentHour < 6 || currentHour >= 18;
    final newMode = isNight ? ThemeMode.dark : ThemeMode.light;

    if (state.themeMode != newMode) {
      emit(state.copyWith(themeMode: newMode));
      _configService.setThemeMode(newMode);
    }
  }

  void toggleAutoSwitch(bool enable) {
    if (enable) {
      _startAutoSwitch();
    } else {
      _autoSwitchTimer?.cancel();
    }
    emit(state.copyWith(enableAutoSwitch: enable));
  }

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode, enableAutoSwitch: false));
    _configService.setThemeMode(mode);
    _autoSwitchTimer?.cancel();
  }

  @override
  Future<void> close() {
    _autoSwitchTimer?.cancel();
    return super.close();
  }
}
