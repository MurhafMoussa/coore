// localization_config.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocalizationConfigEntity extends Equatable {

  const LocalizationConfigEntity({
    required this.supportedLocales,
    required this.localizationsDelegates,
    required this.defaultLocale,
  });
  final List<Locale> supportedLocales;
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale defaultLocale;

  @override
  List<Object> get props => [
    supportedLocales,
    localizationsDelegates,
    defaultLocale,
  ];
}
