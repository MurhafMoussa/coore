import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:coore/lib.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart' as logger;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

Future<void> setupCoreDependencies(CoreConfigEntity coreEntity) async {
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  getIt
    ..registerLazySingletonAsync(() => DeviceInfoPlugin().deviceInfo)
    ..registerLazySingletonAsync(() => PackageInfo.fromPlatform())
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
    ..registerLazySingleton<CacheStore>(() => MemCacheStore())
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
    )
    ..registerLazySingleton<PlatformServiceInterface>(
      () => PlatformServiceImpl(getIt(), getIt()),
    )
    ..registerLazySingleton(() => PlatformCubit(service: getIt()));
}

/// Get the platform service instance
PlatformServiceInterface get platformService =>
    getIt<PlatformServiceInterface>();

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
    final cacheOptions = CacheOptions(
      // A store is required for caching. We'll use MemCacheStore for in-memory caching.
      store: getIt<CacheStore>(),

      // The default policy. We'll set it to "do not cache" by default.
      // We will override this on a per-request basis.
      policy: CachePolicy.noCache,

      // Default max duration for cache entries.
      maxStale: entity.cacheDuration,
    );
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
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
