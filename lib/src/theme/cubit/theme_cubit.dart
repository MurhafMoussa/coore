import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coore/src/config/entities/theme_config_entity.dart';
import 'package:coore/src/config/service/config_service.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeConfigEntity> {
  ThemeCubit({
    required ConfigService usecase,
    required ThemeConfigEntity themeConfigEntity,
  }) : _configService = usecase,

       super(themeConfigEntity) {
    _init();
  }
  final ConfigService _configService;

  Future<void> _init() async {
    final savedThemeMode = await _configService.getThemeMode(state.themeMode);

    if (savedThemeMode != state.themeMode && !isClosed) {
      emit(state.copyWith(themeMode: savedThemeMode));
    }
  }

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode, enableAutoSwitch: false));
    _configService.setThemeMode(mode);
  }
}
