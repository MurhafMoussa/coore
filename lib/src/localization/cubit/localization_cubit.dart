import 'package:coore/src/config/entities/localization_config_entity.dart';
import 'package:coore/src/config/service/config_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit({required this.service, required this.config})
    : super(config.defaultLocale) {
    _initialize();
  }
  final ConfigService service;
  final LocalizationConfigEntity config;

  Future<void> _initialize() async {
    await _fetchLocale();
  }

  List<LocalizationsDelegate<dynamic>> get delegates =>
      config.localizationsDelegates;
  List<Locale> get supportedLocales => config.supportedLocales;
  Future<void> _fetchLocale() async {
    final languageCode = await service.getLanguageCode();
    final locale = languageCode.isNotEmpty
        ? Locale(languageCode)
        : config.defaultLocale;
    emit(locale);
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (!config.supportedLocales.contains(newLocale)) return;
    if (state == newLocale) return;

    await service.saveLanguageCode(newLocale.languageCode);
    emit(newLocale);
  }
}
