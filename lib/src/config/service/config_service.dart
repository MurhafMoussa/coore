import 'package:coore/lib.dart';
import 'package:coore/src/local_storage/local_database/local_database_interface.dart';
import 'package:flutter/material.dart';

class ConfigService {
  ConfigService(this.localDatabaseInterface);
  final LocalDatabaseInterface localDatabaseInterface;

  Future<void> saveLanguageCode(String languageCode) async {
    localDatabaseInterface.save<String>('languageCode', languageCode);
  }

  Future<String> getLanguageCode() async {
    final languageCodeEither = await localDatabaseInterface.get<String>(
      'languageCode',
    );
    return languageCodeEither.fold((l) => '', (r) => r ?? '');
  }

  Future<bool> getIsFirstStart() async {
    final languageCodeEither = await localDatabaseInterface.get<bool>(
      'firstStart',
    );
    return languageCodeEither.fold((l) => false, (r) => r ?? false);
  }

  Future<void> setFirstStart(bool isFirst) async {
    localDatabaseInterface.save<bool>('firstStart', isFirst);
  }

  Future<ThemeMode> getThemeMode(ThemeMode defaultThemeMode) async {
    final themeConfigEither = await localDatabaseInterface.get<String>(
      'themeMode',
    );
    return themeConfigEither.fold(
      (l) => defaultThemeMode,
      (r) => r != null
          ? ThemeMode.values.firstWhere((element) => element.name == r)
          : defaultThemeMode,
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    localDatabaseInterface.save<String>('themeMode', themeMode.name);
  }
}
