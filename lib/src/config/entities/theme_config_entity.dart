import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeConfigEntity extends Equatable {

  const ThemeConfigEntity({
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
    required this.enableAutoSwitch,
  });

  factory ThemeConfigEntity.defaultConfig() => ThemeConfigEntity(
    themeMode: ThemeMode.light,
    lightTheme: ThemeData(),
    darkTheme: ThemeData.dark(),
    enableAutoSwitch: false,
  );
  final ThemeMode themeMode;

  final ThemeData lightTheme;

  final ThemeData darkTheme;

  final bool enableAutoSwitch;

  ThemeConfigEntity copyWith({
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? enableAutoSwitch,
  }) {
    return ThemeConfigEntity(
      themeMode: themeMode ?? this.themeMode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      enableAutoSwitch: enableAutoSwitch ?? this.enableAutoSwitch,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    lightTheme,
    darkTheme,
    enableAutoSwitch,
  ];
}
