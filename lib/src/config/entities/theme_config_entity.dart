import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeConfigEntity extends Equatable {
  const ThemeConfigEntity({
    required this.themeMode,

    required this.enableAutoSwitch,
  });

  factory ThemeConfigEntity.defaultConfig() => const ThemeConfigEntity(
    themeMode: ThemeMode.light,

    enableAutoSwitch: false,
  );
  final ThemeMode themeMode;

  final bool enableAutoSwitch;

  ThemeConfigEntity copyWith({
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? enableAutoSwitch,
  }) {
    return ThemeConfigEntity(
      themeMode: themeMode ?? this.themeMode,

      enableAutoSwitch: enableAutoSwitch ?? this.enableAutoSwitch,
    );
  }
  
  @override
  List<Object?> get props => [themeMode, enableAutoSwitch];
}
