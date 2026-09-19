import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../config/localization_config_entity.dart';

/// Persistent Hydrated Cubit for localization and locale state management.
class LocalizationCubit extends HydratedCubit<Locale> {
  LocalizationCubit({required this.config})
      : super(config.defaultLocale);

  final LocalizationConfigEntity config;

  List<LocalizationsDelegate<dynamic>> get delegates =>
      config.localizationsDelegates;
  List<Locale> get supportedLocales => config.supportedLocales;

  Future<void> changeLanguage(Locale newLocale) async {
    if (!config.supportedLocales.contains(newLocale)) return;
    if (state == newLocale) return;
    emit(newLocale);
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    try {
      final languageCode = json['languageCode'] as String?;
      final countryCode = json['countryCode'] as String?;
      if (languageCode != null && languageCode.isNotEmpty) {
        return Locale(languageCode, countryCode);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {
      'languageCode': state.languageCode,
      'countryCode': state.countryCode,
    };
  }
}
