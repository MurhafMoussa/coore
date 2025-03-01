// localization_config.dart
import 'package:flutter/material.dart';

class LocalizationConfigEntity {
  final List<Locale> supportedLocales;
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale defaultLocale;

  LocalizationConfigEntity({
    required this.supportedLocales,
    required this.localizationsDelegates,
    required this.defaultLocale,
  });
}
