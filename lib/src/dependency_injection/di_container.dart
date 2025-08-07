import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:coore/src/api_handler/api_handler_impl.dart';
import 'package:coore/src/api_handler/api_handler_interface.dart';
import 'package:coore/src/api_handler/auth_token_manager.dart';
import 'package:coore/src/api_handler/base_cache_store/mem_cache_store.dart';
import 'package:coore/src/api_handler/interceptors/auth_interceptor.dart';
import 'package:coore/src/api_handler/interceptors/caching_interceptor.dart';
import 'package:coore/src/api_handler/interceptors/logging_interceptor.dart';
import 'package:coore/src/config/entities/core_config_entity.dart';
import 'package:coore/src/config/entities/network_config_entity.dart';
import 'package:coore/src/config/service/config_service.dart';
import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:coore/src/error_handling/exception_mapper/dio_exception_mapper.dart';
import 'package:coore/src/error_handling/exception_mapper/network_exception_mapper.dart';
import 'package:coore/src/local_storage/local_database/local_database_interface.dart';
import 'package:coore/src/local_storage/local_database/nosql_database_imp.dart';
import 'package:coore/src/local_storage/secure_database/secure_database_imp.dart';
import 'package:coore/src/local_storage/secure_database/secure_database_interface.dart';
import 'package:coore/src/localization/cubit/localization_cubit.dart';
import 'package:coore/src/network_status/cubit/network_status_cubit.dart';
import 'package:coore/src/network_status/service/network_status_imp.dart';
import 'package:coore/src/network_status/service/network_status_interface.dart';
import 'package:coore/src/theme/cubit/theme_cubit.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart' as logger;
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

Future<void> setupCoreDependencies(CoreConfigEntity coreEntity) async {
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  getIt
    ..registerLazySingleton(
      () => logger.Logger(
        filter: logger.DevelopmentFilter(),
        printer: logger.PrettyPrinter(
          dateTimeFormat: logger.DateTimeFormat.dateAndTime,
        ),
        output: logger.ConsoleOutput(),
        level: logger.Level.all,
      ),
    )
    ..registerLazySingleton(_createFlutterSecureStorage)
    ..registerLazySingleton<CoreLogger>(
      () => CoreLoggerImpl(getIt(), shouldLog: coreEntity.shouldLog),
    )
    ..registerLazySingleton(
      () => AuthTokenManager(
        getIt(),
        secureStorageEnabled: coreEntity.enableSecureStorage,
      ),
    )
    ..registerLazySingleton(
      () => _createDio(
        coreEntity.networkConfigEntity,
        directory,
        shouldLog: coreEntity.shouldLog,
      ),
    )
    ..registerLazySingleton<SecureDatabaseInterface>(
      () => SecureDatabaseImp(getIt()),
    )
    ..registerLazySingleton<NetworkExceptionMapper>(
      () => DioNetworkExceptionMapper(),
    )
    ..registerLazySingleton<ApiHandlerInterface>(
      () => DioApiHandler(getIt(), getIt()),
    )
    ..registerLazySingleton(() => InternetConnection())
    ..registerLazySingleton<NetworkStatusInterface>(
      () => NetworkStatusImp(getIt(), getIt()),
    )
    ..registerLazySingleton(() => NetworkStatusCubit(networkStatus: getIt()))
    ..registerFactoryParam<LocalDatabaseInterface, String, void>(
      (boxName, _) => HiveLocalDatabase(boxName),
    )
    ..registerLazySingleton(
      () => ConfigService(getIt<LocalDatabaseInterface>(param1: 'coreConfig')),
    )
    ..registerLazySingleton(
      () => LocalizationCubit(
        service: getIt(),
        config: coreEntity.localizationConfigEntity,
      ),
    )
    ..registerLazySingleton(
      () => ThemeCubit(
        usecase: getIt(),
        themeConfigEntity: coreEntity.themeConfigEntity,
      ),
    );
}

FlutterSecureStorage _createFlutterSecureStorage() {
  const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  return const FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iosOptions,
  );
}

Dio _createDio(
  NetworkConfigEntity entity,
  Directory directory, {
  bool shouldLog = false,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: entity.baseUrl,
      connectTimeout: entity.connectTimeout,
      // ... other base options ...
    ),
  );

  if (shouldLog) {
    dio.interceptors.add(
      LoggingInterceptor(logger: getIt(), maxBodyLength: 10000),
    );
  }

  if (entity.enableCache) {
    dio.interceptors.add(
      CachingInterceptor(
        cacheStore: MemoryCacheStore(),
        defaultCacheDuration: entity.cacheDuration,
      ),
    );
  }

  late final AuthInterceptor authInterceptor;
  switch (entity.authInterceptorType) {
    case AuthInterceptorType.tokenBased:
      authInterceptor = TokenAuthInterceptor(getIt());
      break;
    case AuthInterceptorType.cookieBased:
      final String appDocPath = directory.path;
      final jar = PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage('$appDocPath/.cookies/'),
      );
      dio.interceptors.add(CookieManager(jar));
      authInterceptor = CookieAuthInterceptor(getIt());
      break;
  }

  dio.interceptors.addAll([...entity.interceptors, authInterceptor]);

  return dio;
}
