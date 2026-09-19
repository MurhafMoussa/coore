---
type: Spec
title: Strata Network Package Refactoring & Production-Grade Architecture
---

## Problem

The current `strata_network` package contains architectural flaws, parameter duplication, and leaks of external Dio types:
1. `ApiHandlerInterface` defines methods with ~10 repeated optional parameters (`isAuthorized`, `enableRetry`, `maxRetryAttempts`, `retryDelay`, `requestId`, `shouldCache`, progress callbacks), leading to parameter noise and maintenance overhead.
2. `FormDataAdapter` directly imports and exposes Dio `FormData`, violating package encapsulation boundaries and forcing caller/host applications to depend on `package:dio`.
3. Interceptors (`RetryInterceptor`, `TokenRefreshInterceptorInterface`, `DioApiHandler`) utilize `GetIt.instance` directly within request/error execution paths, creating hidden dependencies and reducing testability.
4. `NetworkStatusImp` violates the monorepo concrete naming convention specified in `GLOSSARY.md` by using the prohibited `Imp` suffix.
5. Dependency injection registration (`registerStrataNetwork`) does not populate all `NetworkConfigEntity` `BaseOptions` fields (such as `contentType`, `followRedirects`, `maxRedirects`, `defaultQueryParams`, status validation) nor configure the complete interceptor pipeline (cookie management, logging, retry, token injection).
6. Retry execution in `RetryInterceptor` relies on a fixed delay instead of production-grade exponential backoff with jitter.

## Proposed Outcome

Refactor `strata_network` into a clean, fully encapsulated, production-grade HTTP client infrastructure package that:
- Simplifies `ApiHandlerInterface` method signatures using a unified `ApiRequestOptions` model.
- Completely encapsulates `package:dio` types, exposing framework-agnostic models (`NetworkFormData`, `NetworkFile`) and zero Dio exports.
- Eliminates Service Locator (`GetIt`) calls inside interceptors and handlers in favor of constructor dependency injection.
- Replaces `NetworkStatusImp` with `InternetConnectionNetworkStatus` per `GLOSSARY.md`.
- Fully populates `Dio` `BaseOptions` and attaches all configured interceptors (including `dio_cookie_manager` support) in `registerStrataNetwork`.
- Implements exponential backoff with jitter in `RetryInterceptor`.
- Provides a reactive `unauthenticatedStream` on `TokenManagerInterface` for Clean Architecture session expiration handling.

## User Stories

1. As a developer using `strata_network`, I want to send HTTP requests with clean, optional configuration parameters via `ApiRequestOptions` so that method calls on `ApiHandlerInterface` are concise and maintainable.
2. As a feature developer in a host application, I want to send multipart form data using `NetworkFormData` without importing Dio or knowing that Dio is used under the hood.
3. As a Clean Architecture architect, I want `TokenManagerInterface` to emit unauthenticated events via a stream so that my presentation layer (`AuthBloc` / router) can reactively redirect users on 401 session expiration without requiring UI context in DI setup.
4. As a framework maintainer, I want all network interceptors and handlers to receive their dependencies via constructor injection so that unit testing is deterministic without static `GetIt` state.
5. As a mobile developer, I want automatic request retries to use exponential backoff with jitter so that server load is minimized during network recovery.

## Requirements

### ApiHandlerInterface & Request Options
1. `ApiHandlerInterface` methods MUST accept an optional `ApiRequestOptions? options` parameter instead of individual configuration flags/callbacks: [L1]
   - `get<T>(String path, {required T Function(Map<String, dynamic> json) parser, Map<String, dynamic>? queryParameters, ApiRequestOptions? options})`
   - `post<T>(String path, {required T Function(Map<String, dynamic> json) parser, Map<String, dynamic>? body, NetworkFormData? formData, Map<String, dynamic>? queryParameters, ApiRequestOptions? options})`
   - `put<T>(String path, {required T Function(Map<String, dynamic> json) parser, Map<String, dynamic>? body, NetworkFormData? formData, Map<String, dynamic>? queryParameters, ApiRequestOptions? options})`
   - `patch<T>(String path, {required T Function(Map<String, dynamic> json) parser, Map<String, dynamic>? body, NetworkFormData? formData, Map<String, dynamic>? queryParameters, ApiRequestOptions? options})`
   - `delete<T>(String path, {required T Function(Map<String, dynamic> json) parser, Map<String, dynamic>? queryParameters, ApiRequestOptions? options})`
   - `download<T>(String url, String downloadDestinationPath, {required T Function(Map<String, dynamic> json) parser, Map<String, dynamic>? queryParameters, ApiRequestOptions? options})`
2. `ApiRequestOptions` MUST be an immutable class containing:
   - `bool isAuthorized` (default: `false`)
   - `bool shouldCache` (default: `false`)
   - `bool enableRetry` (default: `true`)
   - `int? maxRetryAttempts`
   - `Duration? retryDelay`
   - `String? requestId`
   - `Map<String, String>? headers` (for per-request headers like idempotency keys)
   - `ProgressTrackerCallback? onSendProgress`
   - `ProgressTrackerCallback? onReceiveProgress`
   - `Map<String, dynamic>? extra` [L1]

### Multipart Form Data Abstraction
3. `FormDataAdapter` MUST be replaced with `NetworkFormData` and `NetworkFile` in `strata_network`. [L1]
4. `NetworkFormData` MUST accept `Map<String, dynamic> fields` and `List<NetworkFile> files`. [L1]
5. `NetworkFile` MUST specify `fieldName`, `filePath`, optional `filename`, and optional `contentType`. [L1]
6. `DioApiHandler` MUST internally convert `NetworkFormData` into Dio `FormData` without exposing Dio types to `ApiHandlerInterface` callers. [L1, L2]

### Encapsulation & Code Quality
7. `lib/strata_network.dart` MUST NOT export any Dio classes (`Dio`, `FormData`, `Options`, `CancelToken`, `DioException`, `Interceptor`). [L1, L2]
8. All concrete classes in `strata_network` MUST use standard Dart primary constructors and adhere to `GLOSSARY.md` naming conventions. [L2, L5]
9. `NetworkStatusImp` MUST be renamed to `InternetConnectionNetworkStatus`. [L5]

### Dependency Injection & Interceptors
10. `RetryInterceptor`, `TokenRefreshInterceptorInterface`, and `DioApiHandler` MUST receive `Dio` or required dependencies explicitly via constructor parameters, eliminating runtime `GetIt.instance` calls. `TokenRefreshInterceptorInterface` MUST receive `Dio dio` via constructor to perform refresh HTTP requests and retries directly without depending on `ApiHandlerInterface`. [L5]
11. `registerStrataNetwork` MUST configure `BaseOptions` with all `NetworkConfigEntity` fields (`baseUrl`, `connectTimeout`, `sendTimeout`, `receiveTimeout`, `staticHeaders`, `defaultQueryParams`, `defaultContentType`, `followRedirects`, `maxRedirects`, status code validation `200..299`). [L3]
12. `registerStrataNetwork` MUST accept `required NetworkConfigEntity config` and `required ErrorModelParser errorParser`, omitting `customDio` and `onUnauthenticated`. [L3]
13. `strata_network` MUST add `dio_cookie_manager` and `cookie_jar` to dependencies. When `config.authInterceptorType == AuthInterceptorType.cookieBased`, `registerStrataNetwork` MUST register a `CookieJar` singleton in `GetIt` and attach `CookieManager(cookieJar)` to `Dio`. [L3, L5]
14. `LoggingInterceptor` MUST log HTTP requests/responses using `CoreLoggerInterface` from `strata_core`. `registerStrataNetwork` MUST check `GetIt.instance.isRegistered<CoreLoggerInterface>()` and pass the registered logger (defaulting to `NoOpCoreLogger()`) to `LoggingInterceptor`. [L3]

### Retry Mechanism
15. `RetryInterceptor` MUST support exponential backoff calculation (`retryInterval * 2^attempt`) with randomized jitter for transient failure retries. [L5]

### Authentication & Session Expiration
16. `TokenManagerInterface` MUST expose `Stream<void> get unauthenticatedStream` and `void notifyUnauthenticated()`. [L4, L5]
17. `DefaultTokenManager` MUST implement `unauthenticatedStream` using a broadcast stream controller, and accept an optional `CookieJar` parameter so `clearTokens()` clears stored cookies when cookie authentication is active. [L4, L5]

## Technical Decisions

1. **`ApiRequestOptions` Design**: Encapsulates per-request overrides in an immutable value object, defaulting `isAuthorized: false`, `enableRetry: true`, and `shouldCache: false`. [L1]
2. **Framework-Agnostic Form Data**: `NetworkFormData` and `NetworkFile` wrap raw paths/fields so host apps do not depend on Dio IO file streams or Dio FormData classes. [L1]
3. **Constructor Injection over Service Locator**: Replaces `GetIt.instance` in `RetryInterceptor` and `TokenRefreshInterceptorInterface` with explicit `Dio` references passed at interceptor construction time, resolving interceptor setup order without circular DI dependencies. [L5]
4. **Cookie Authentication Support**: Adds `dio_cookie_manager` and `cookie_jar` to `strata_network/pubspec.yaml` to handle cookie persistence for cookie-based authentication flows, registering `CookieJar` in `GetIt` for lifecycle reset inside `DefaultTokenManager`. [L3, L5]
5. **Reactive Session Expiration Stream**: Exposes `unauthenticatedStream` on `TokenManagerInterface` so `AuthRepository` (Data) can bridge expiration events to `WatchSessionExpirationUseCase` (Domain) and `AuthBloc` (Presentation). [L4]

## Testing Strategy

1. **Unit Tests (`DioApiHandler`)**:
   - Verify `get`, `post`, `put`, `patch`, `delete`, `download` apply options (`headers`, `isAuthorized`, `enableRetry`, progress callbacks) correctly to Dio `Options`.
   - Verify `NetworkFormData` conversion maps fields and file attachments accurately to Dio `FormData`.
2. **Unit Tests (`RetryInterceptor`)**:
   - Verify retries execute with exponential backoff delays and honor `maxRetryAttempts` and status code filters without calling `GetIt`.
3. **Unit Tests (`DefaultTokenManager`)**:
   - Verify `notifyUnauthenticated()` emits events on `unauthenticatedStream` and `clearTokens()` clears cookies when `CookieJar` is supplied.
4. **Unit Tests (`registerStrataNetwork` & Network Status)**:
   - Rename `test/network_status/network_status_imp_test.dart` to `test/network_status/internet_connection_network_status_test.dart`.
   - Verify DI registers `Dio`, `ApiHandlerInterface`, `TokenManagerInterface`, `InternetConnectionNetworkStatus`, and `NetworkExceptionMapperInterface` with full `BaseOptions` and correct interceptor pipeline.
5. **Package Boundary Audit Test (`package_dependency_test.dart`)**:
   - Verify `strata_network` contains zero Flutter/UI imports and does not re-export Dio types in `lib/strata_network.dart`.

## Out of Scope

- Implementing UI screens or BLoC handlers in `strata_network` (maintained in `strata_state` or host application).
- Modifying `strata_core` Failure models or `ApiState` domain definitions.
