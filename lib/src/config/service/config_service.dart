import 'package:coore/src/local_database/local_database_interface.dart';
import 'package:flutter/material.dart';

class ConfigService {
  final LocalDatabaseInterface localDatabaseInterface;

  ConfigService(this.localDatabaseInterface);

  Future<void> saveLanguageCode(String languageCode) async {
    localDatabaseInterface.save<String>('languageCode', languageCode).run();
  }

  Future<String> getLanguageCode() async {
    final languageCodeEither =
        await localDatabaseInterface.get<String>('languageCode').run();
    return languageCodeEither.fold((l) => '', (r) => r ?? '');
  }

  Future<bool> getIsFirstStart() async {
    final languageCodeEither =
        await localDatabaseInterface.get<bool>('firstStart').run();
    return languageCodeEither.fold((l) => false, (r) => r ?? false);
  }

  Future<void> setFirstStart(bool isFirst) async {
    localDatabaseInterface.save<bool>('firstStart', isFirst).run();
  }

  Future<ThemeMode> getThemeMode() async {
    final themeConfigEither =
        await localDatabaseInterface.get<ThemeMode>('themeMode').run();
    return themeConfigEither.fold(
      (l) => ThemeMode.light,
      (r) => r ?? ThemeMode.light,
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    localDatabaseInterface.save<ThemeMode>('themeMode', themeMode).run();
  }
}
