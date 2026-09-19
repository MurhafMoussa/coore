import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:strata_core/strata_core.dart';

import '../api_handler/api_handler_interface.dart';
import '../api_handler/cancel_request_manager_interface.dart';
import '../api_handler/default_cancel_request_manager.dart';
import '../api_handler/dio_api_handler.dart';
import '../api_handler/models/models.dart';
import '../auth/default_token_manager.dart';
import '../auth/token_manager_interface.dart';
import '../config/network_config_entity.dart';
import '../error_handling/dio_exception_mapper.dart';
import '../error_handling/network_exception_mapper_interface.dart';

/// Extension on [GetIt] to register `strata_network` dependencies.
extension StrataNetworkDiExtension on GetIt {
  /// Registers network infrastructure singletons.
  void registerStrataNetwork({
    required NetworkConfigEntity config,
    ErrorModelParser? errorParser,
    Dio? customDio,
    void Function()? onUnauthenticated,
  }) {
    if (!isRegistered<NetworkConfigEntity>()) {
      registerSingleton<NetworkConfigEntity>(config);
    }

    if (!isRegistered<CancelRequestManagerInterface>()) {
      registerLazySingleton<CancelRequestManagerInterface>(
        () => DefaultCancelRequestManager(),
      );
    }

    if (!isRegistered<TokenManagerInterface>()) {
      registerLazySingleton<TokenManagerInterface>(
        () => DefaultTokenManager(
          sensitiveStorage: isRegistered<SensitiveStorageInterface>()
              ? get<SensitiveStorageInterface>()
              : null,
          secureStorageEnabled: true,
          onUnauthenticated: onUnauthenticated,
        ),
      );
    }

    if (!isRegistered<NetworkExceptionMapperInterface>()) {
      registerLazySingleton<NetworkExceptionMapperInterface>(
        () => DioExceptionMapper(
          errorParser ?? (response) => _DefaultErrorResponseModel(response),
        ),
      );
    }

    if (!isRegistered<Dio>()) {
      registerLazySingleton<Dio>(() {
        final dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: config.baseUrl,
                connectTimeout: config.connectTimeout,
                sendTimeout: config.sendTimeout,
                receiveTimeout: config.receiveTimeout,
                headers: config.staticHeaders,
              ),
            );
        return dio;
      });
    }

    if (!isRegistered<ApiHandlerInterface>()) {
      registerLazySingleton<ApiHandlerInterface>(
        () => DioApiHandler(
          get<Dio>(),
          get<NetworkExceptionMapperInterface>(),
          cancelRequestManager: get<CancelRequestManagerInterface>(),
        ),
      );
    }
  }
}

class _DefaultErrorResponseModel extends BaseErrorResponseModel {
  _DefaultErrorResponseModel(Response<dynamic>? response)
      : super(
          status: response?.statusCode ?? 500,
          developerMessage:
              response?.statusMessage ?? 'An error occurred during request',
          timestamp: DateTime.now(),
        );

  @override
  Map<String, String> get validationErrors => {};
}
