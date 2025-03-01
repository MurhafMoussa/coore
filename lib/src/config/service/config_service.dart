import 'package:coore/src/local_database/local_database_interface.dart';

class ConfigService {
  final LocalDatabaseInterface localDatabaseInterface;

  ConfigService(this.localDatabaseInterface);

  Future<void> saveLanguageCode(String languageCode) async {
    await localDatabaseInterface.save('languageCode', languageCode).run();
  }

  Future<String> getLanguageCode() async {
    final languageCodeEither =
        await localDatabaseInterface.get<String>('languageCode').run();
    return languageCodeEither.fold((l) => '', (r) => r??'');
  }
  Future<bool> getIsFirstStart() async {
    final languageCodeEither =
        await localDatabaseInterface.get<bool>('firstStart').run();
    return languageCodeEither.fold((l) => false, (r) => r??false);
  }
  Future<void> setFirstStart(bool isFirst) async {
    await localDatabaseInterface.save('firstStart', isFirst).run();

  }
}
