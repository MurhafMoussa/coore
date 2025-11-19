import 'package:coore/lib.dart';
import 'package:coore/src/local_storage/nosql_database/nosql_database_interface.dart';
import 'package:flutter/material.dart';

class ConfigService {
  ConfigService(this.localDatabaseInterface);
  final NoSqlDatabaseInterface localDatabaseInterface;

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
    try {
      final themeConfigEither = await localDatabaseInterface.get<String>(
        'themeMode',
      );

      return themeConfigEither.fold((l) => defaultThemeMode, (savedString) {
        if (savedString == null) return defaultThemeMode;

        return ThemeMode.values.firstWhere(
          (e) => e.name == savedString,
          orElse: () => defaultThemeMode,
        );
      });
    } catch (e) {
      return defaultThemeMode;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    localDatabaseInterface.save<String>('themeMode', themeMode.name);
  }
}
