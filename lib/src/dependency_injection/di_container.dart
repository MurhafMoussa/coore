import 'package:coore/src/api_handler/api_handler_impl.dart';
import 'package:coore/src/api_handler/api_handler_interface.dart';
import 'package:coore/src/api_handler/base_cache_store/mem_cache_store.dart';
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
import 'package:coore/src/navigation/core_navigator.dart';
import 'package:coore/src/network_status/cubit/network_status_cubit.dart';
import 'package:coore/src/network_status/service/network_status_imp.dart';
import 'package:coore/src/network_status/service/network_status_interface.dart';
import 'package:coore/src/theme/cubit/theme_cubit.dart';
import 'package:dio/dio.dart';
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
    ..registerLazySingleton<CoreLogger>(() => CoreLoggerImpl(getIt()))
    ..registerLazySingleton(() => _createDio(coreEntity.networkConfigEntity))
    ..registerLazySingleton<NetworkExceptionMapper>(
      () => DioNetworkExceptionMapper(),
    )
    ..registerLazySingleton<ApiHandlerInterface>(
      () => DioApiHandler(getIt(), getIt()),
    )
    ..registerLazySingleton(() => InternetConnection())
    ..registerLazySingleton<NetworkStatusInterface>(
      () => NetworkStatusImp(getIt()),
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
      () => CoreNavigator(
        logger: getIt(),
        navigationConfigEntity: coreEntity.navigationConfigEntity,
      ),
    )
    ..registerLazySingleton(
      () => ThemeCubit(
        repository: getIt(),
        themeConfigEntity: coreEntity.themeConfigEntity,
      ),
    )
    ..registerLazySingleton<SecureDatabaseInterface>(
      () => SecureDatabaseImp(getIt()),
    );
}

//todo(Murhaf): requires additional setup for other platforms
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

Dio _createDio(NetworkConfigEntity entity) {
  return Dio(
      BaseOptions(
        baseUrl: entity.baseUrl,
        connectTimeout: entity.connectTimeout,
        contentType: entity.defaultContentType,
        followRedirects: entity.followRedirects,
        maxRedirects: entity.maxRedirects,
        queryParameters: entity.defaultQueryParams,
        sendTimeout: entity.sendTimeout,
        receiveTimeout: entity.receiveTimeout,
        headers: entity.staticHeaders,
      ),
    )
    ..interceptors.addAll([
      if (entity.enableLogging)
        LoggingInterceptor(logger: getIt(), maxBodyLength: 2048),
      if (entity.enableCache)
        CachingInterceptor(
          cacheStore: MemoryCacheStore(),
          defaultCacheDuration: entity.cacheDuration,
        ),
      ...entity.interceptors,
    ]);
}
