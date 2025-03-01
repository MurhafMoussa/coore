import 'package:coore/src/api_handler/api_handler_impl.dart';
import 'package:coore/src/api_handler/api_handler_interface.dart';
import 'package:coore/src/api_handler/base_cache_store/mem_cache_store.dart';
import 'package:coore/src/api_handler/interceptors/caching_interceptor.dart';
import 'package:coore/src/api_handler/interceptors/logging_interceptor.dart';
import 'package:coore/src/config/entities/core_config_entity.dart';
import 'package:coore/src/config/entities/network_config_entity.dart';
import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:coore/src/environment/environment_config.dart';
import 'package:coore/src/error_handling/exception_mapper/dio_exception_mapper.dart';
import 'package:coore/src/error_handling/exception_mapper/network_exception_mapper.dart';
import 'package:coore/src/network_status/cubit/network_status_cubit.dart';
import 'package:coore/src/network_status/service/network_status_imp.dart';
import 'package:coore/src/network_status/service/network_status_interface.dart';
import 'package:coore/src/ui/message_viewers/toaster.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart' as logger;

final getIt = GetIt.instance;

Future<void> setupCoreDependencies(CoreConfigEntity coreEntity) async {
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
    ..registerLazySingleton<CoreLogger>(() => CoreLoggerImpl(getIt()))
    ..registerLazySingleton(() => EnvironmentConfig())
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
    ..registerLazySingleton(() => Toaster());
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
        responseType: ResponseType.json,
        sendTimeout: entity.sendTimeout,
        receiveTimeout: entity.receiveTimeout,
        headers: entity.staticHeaders,
      ),
    )
    ..interceptors.addAll([
      if (entity.enableLogging)
        LoggingInterceptor(
          logger: getIt(),
          logError: true,
          logRequest: true,
          logResponse: true,
          maxBodyLength: 2048,
        ),
      if (entity.enableCache)
        CachingInterceptor(
          cacheStore: MemoryCacheStore(),
          defaultCacheDuration: entity.cacheDuration,
        ),
      ...entity.interceptors,
    ]);
}
