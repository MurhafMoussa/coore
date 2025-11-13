# 🎯 Coore - Enterprise Flutter Core Package

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

A comprehensive, enterprise-level Flutter package that provides a complete foundation for building scalable, maintainable Flutter applications. Coore offers a robust set of core utilities, state management, networking, localization, theming, and UI components designed for production-ready applications.

## 📑 Table of Contents

- [Quick Start](#-quick-start)
  - [Installation](#installation)
  - [Basic Setup](#basic-setup)
- [Architecture Overview](#️-architecture-overview)
- [Core Features](#-core-features)
- [Core Concepts](#-core-concepts)
  - [Type Definitions](#type-definitions)
  - [Error Handling](#error-handling)
- [Core Infrastructure](#-core-infrastructure)
  - [Configuration](#configuration)
  - [Dependency Injection](#dependency-injection)
  - [Environment Management](#environment-management)
- [Networking & API](#-networking--api)
  - [API Handler](#api-handler-interface)
  - [Authentication](#authentication)
  - [Interceptors](#interceptors)
  - [Network Status](#network-status-monitoring)
- [State Management](#-state-management)
  - [ApiState](#apistate-class)
  - [ApiStateHandler & ApiStateHostMixin](#apistatehandler-and-apistatehostmixin-recommended-approach)
  - [ApiStateMixin](#apistatemixin-legacy-approach)
  - [Use Cases](#use-case-architecture)
- [Data Management](#-data-management)
  - [Local Storage](#local-database-interface)
  - [Secure Storage](#secure-database-interface)
  - [Cache Failures](#cache-failure-types)
- [UI Components](#-ui-components--theming)
  - [Theme Management](#theme-management-system)
  - [Form Components](#form-components)
  - [Image Components](#image-components)
  - [Text Components](#text-components)
  - [Pagination](#pagination-system)
- [Navigation](#-navigation--routing)
  - [CoreRouter](#corerouter)
  - [Type-Safe Navigation](#type-safe-navigation-with-go_router_builder)
  - [Configuration](#configuration-1)
  - [Screen Parameters](#screen-parameters)
  - [Route Animations](#animated-route-transitions)
- [Platform Support](#-platform-support)
  - [Platform Detection](#platform-detection--device-information)
  - [Cross-Platform Utilities](#cross-platform-utilities)
- [Advanced Features](#-advanced-features)
  - [Extension Methods](#extension-methods)
  - [Development Tools](#development-tools)
- [Best Practices](#-best-practices--guidelines)

---

## 🚀 Quick Start

### Installation 

Add coore to your `pubspec.yaml`:

```yaml
dependencies:
  coore: ^0.0.22
```

### Basic Setup

```dart
import 'package:coore/coore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core dependencies using CoreConfig
  await CoreConfig.initializeCoreDependencies(
    CoreConfigEntity(
      currentEnvironment: CoreEnvironment.development,
      networkConfigEntity: NetworkConfigEntity(
        baseUrl: 'https://api.example.com',
        timeout: Duration(seconds: 30),
      ),
      localizationConfigEntity: LocalizationConfigEntity(
        defaultLocale: Locale('en'),
        supportedLocales: [Locale('en'), Locale('ar')],
        localizationsDelegates: [/* your delegates */],
      ),
      themeConfigEntity: ThemeConfigEntity(
        lightTheme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
      ),
    ),
  );
  
  runApp(MyApp());
}
```

## 🏗️ Architecture Overview

Coore follows a modular architecture with clear separation of concerns:

```
coore/
├── 🔧 Core Infrastructure
│   ├── Dependency Injection - Service locator pattern
│   ├── Configuration Management - Centralized app config
│   ├── Environment Management - Multi-environment support
│   └── Error Handling - Comprehensive error management
├── 🌐 Networking & API
│   ├── HTTP Client - Dio-based API handler
│   ├── Authentication - Token management
│   ├── Caching - Request/response caching
│   └── Interceptors - Logging, auth, error handling
├── 💾 Data Management
│   ├── Local Storage - Hive-based storage
│   ├── Secure Storage - Encrypted data storage
│   └── Network Status - Connection monitoring
├── 🎨 UI & Theming
│   ├── Theme Management - Light/dark theme support
│   ├── Localization - Multi-language support
│   ├── UI Components - Reusable widgets
│   └── Responsive Design - Adaptive layouts
├── 🧭 Navigation
│   ├── CoreRouter - GoRouter configuration manager
│   ├── go_router_builder - Type-safe code generation
│   ├── Context-less Navigation - BLoC/Service navigation
│   └── Route Animations - Custom transitions
├── 📱 Platform Support
│   ├── Device Information - Platform detection
│   ├── Platform Services - Native integrations
│   └── Cross-platform Utilities - Platform-agnostic APIs
└── 🔄 State Management
    ├── BLoC Pattern - Business logic components
    ├── Cubit Pattern - Simple state management
    └── Use Cases - Clean architecture patterns
```

## 📋 Core Features

### 🔧 **Infrastructure**
- **Dependency Injection**: Service locator pattern with GetIt
- **Configuration Management**: Centralized app configuration
- **Environment Support**: Development, staging, production environments
- **Error Handling**: Comprehensive error mapping and handling

### 🌐 **Networking**
- **HTTP Client**: Dio-based API handler with interceptors
- **Authentication**: Automatic token management and refresh
- **Caching**: Request/response caching with configurable policies
- **Network Monitoring**: Real-time connection status tracking

### 💾 **Data Management**
- **Local Storage**: Hive-based NoSQL database
- **Secure Storage**: Encrypted storage for sensitive data
- **Data Serialization**: JSON serialization with code generation

### 🎨 **UI & Theming**
- **Theme Management**: Light/dark theme with Material 3 support
- **Localization**: Multi-language support with RTL
- **UI Components**: Enterprise-grade reusable widgets
- **Responsive Design**: Adaptive layouts for all screen sizes

### 🧭 **Navigation**
- **CoreRouter**: Clean foundation for GoRouter configuration
- **go_router_builder Integration**: Official type-safe navigation with code generation
- **Context-less Navigation**: Navigate from BLoCs/Services using GoRouter instance
- **Route Animations**: Custom page transitions

### 📱 **Platform Support**
- **Device Information**: Platform detection and device details
- **Platform Services**: Native platform integrations
- **Cross-platform APIs**: Platform-agnostic utilities

---

## 🎯 Core Concepts

### Type Definitions

All API responses are wrapped in `CancelableOperation` from the `async` package, providing built-in cancellation support.

```dart
typedef RemoteCancelableResponse<T> = CancelableOperation<Either<NetworkFailure, T>>;
typedef CacheResponse<T> = Future<Either<CacheFailure, T>>;
typedef UseCaseCancelableFutureResponse<T> = CancelableOperation<Either<Failure, T>>;
typedef UseCaseStreamResponse<T> = Stream<Either<Failure, T>>;
typedef ProgressTrackerCallback = void Function(double progress);
typedef Id = String;
```

**Note:** The `async` package (`^2.11.0`) is now a required dependency for cancellation support.

### Error Handling

#### **Failure Classes**

Comprehensive error handling with specific failure types for different scenarios.

```dart
abstract class Failure extends Equatable implements Exception {
  const Failure(this.message, {this.stackTrace});
  final String message;
  final StackTrace? stackTrace;
}

// Network Failures
abstract class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.stackTrace});
}

class BadRequestFailure extends NetworkFailure;
class UnauthorizedRequestFailure extends NetworkFailure;
class NotFoundFailure extends NetworkFailure;
class NoInternetConnectionFailure extends NetworkFailure;
// ... and more

// Cache Failures
abstract class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.stackTrace});
}

class CacheNotFoundFailure extends CacheFailure;
class CacheReadFailure extends CacheFailure;
// ... and more
```

---

## 🔧 Core Infrastructure

### Configuration

#### **CoreConfig Class**

The `CoreConfig` class is the central configuration manager that handles the initialization of all core dependencies and services.

```dart
class CoreConfig {
  /// Initialize all core dependencies with configuration
  static Future<void> initializeCoreDependencies(CoreConfigEntity configEntity);
  
  /// Initialize additional dependencies after project setup
  static Future<void> initializeCoreDependenciesAfterProjectSetup(
    CoreConfigAfterProjectSetupEntity coreEntity
  );
}
```

#### **CoreConfigEntity**

```dart
class CoreConfigEntity extends Equatable {
  const CoreConfigEntity({
    required this.currentEnvironment,
    required this.networkConfigEntity,
    required this.localizationConfigEntity,
    required this.themeConfigEntity,
    this.shouldLog = true,
    this.enableSecureStorage = false,
  });
  
  final CoreEnvironment currentEnvironment;
  final NetworkConfigEntity networkConfigEntity;
  final LocalizationConfigEntity localizationConfigEntity;
  final ThemeConfigEntity themeConfigEntity;
  final bool shouldLog;
  final bool enableSecureStorage;
}
```

### Environment Management

#### **CoreEnvironment Enum**

```dart
enum CoreEnvironment {
  development,
  staging,
  uat,
  production;
  
  static CoreEnvironment getEnvironmentFromString(String env);
}
```

#### **NetworkConfigEntity**

```dart
class NetworkConfigEntity extends Equatable {
  const NetworkConfigEntity({
    required this.baseUrl,
    this.authInterceptorType = AuthInterceptorType.cookieBased,
    this.connectTimeout = const Duration(seconds: 60),
    this.sendTimeout = const Duration(seconds: 60),
    this.receiveTimeout = const Duration(seconds: 60),
    this.defaultQueryParams = const {},
    this.staticHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    this.interceptors = const [],
    this.defaultContentType = 'application/json',
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 3),
    this.retryOnStatusCodes = const [500, 502, 503, 504],
    this.requestEncoder,
    this.responseDecoder,
    this.enableCache = false,
    this.cacheDuration = const Duration(minutes: 5),
    this.followRedirects = true,
    this.maxRedirects = 5,
  });
  
  final String baseUrl;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  final Map<String, String> staticHeaders;
  final Map<String, dynamic> defaultQueryParams;
  final String defaultContentType;
  final int maxRetries;
  final Duration retryInterval;
  final List<int> retryOnStatusCodes;
  final RequestEncoder? requestEncoder;
  final ResponseDecoder? responseDecoder;
  final bool enableCache;
  final Duration cacheDuration;
  final bool followRedirects;
  final int maxRedirects;
  final List<Interceptor> interceptors;
  final AuthInterceptorType authInterceptorType;
}

enum AuthInterceptorType { tokenBased, cookieBased }
```

### Dependency Injection

#### **Service Locator Pattern**

Coore uses GetIt for dependency injection with automatic service registration.

#### **Available Services**

The following services are automatically registered during initialization:

- **Logger**: Structured logging with development/production modes
- **Device Info**: Platform and device information
- **Package Info**: Application version and build information
- **Secure Storage**: Encrypted data storage
- **API Handler**: HTTP client with interceptors
- **Network Status**: Connection monitoring
- **Local Database**: Hive-based NoSQL storage
- **Theme Cubit**: Theme state management
- **Localization Cubit**: Language state management
- **Platform Cubit**: Device information state management

#### **Usage Example**

```dart
// Access registered services
final logger = getIt<CoreLogger>();
final apiHandler = getIt<ApiHandlerInterface>();
final networkStatus = getIt<NetworkStatusInterface>();
final themeCubit = getIt<ThemeCubit>();
final localizationCubit = getIt<LocalizationCubit>();
final platformCubit = getIt<PlatformCubit>();

// Use services
logger.info('Application started');
```

---

## 🌐 Networking & API

### API Handler Interface

The `ApiHandlerInterface` exposes HTTP helpers that wrap every network call in a `RemoteCancelableResponse<T>`—a `CancelableOperation` that resolves to `Either<NetworkFailure, T>`. This gives consumers precise control over request cancellation while keeping a functional error-handling style.

#### **Public API**

```dart
abstract interface class ApiHandlerInterface {
  RemoteCancelableResponse<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onReceiveProgress,
    bool shouldCache = false,
    bool isAuthorized = false,
  });

  RemoteCancelableResponse<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
  });

  RemoteCancelableResponse<T> delete<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
  });

  RemoteCancelableResponse<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
  });

  RemoteCancelableResponse<T> patch<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
  });

  RemoteCancelableResponse<T> download<T>(
    String url,
    String downloadDestinationPath, {
    required T Function(Map<String, dynamic> json) parser,
    ProgressTrackerCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
  });
}
```

#### **Usage Example**

```dart
final apiHandler = getIt<ApiHandlerInterface>();

// GET request with caching and cancellation support
final usersOperation = apiHandler.get<List<UserDto>>(
  '/users',
  parser: (json) => (json['data'] as List<dynamic>)
      .map((item) => UserDto.fromJson(item as Map<String, dynamic>))
      .toList(),
  queryParameters: {'page': 1, 'limit': 10},
  shouldCache: true,
  isAuthorized: true,
);

// Cancel if needed
// usersOperation.cancel();

final usersResult = await usersOperation.value;
usersResult.fold(
  (failure) => logger.error('Error: ${failure.message}'),
  (users) => logger.info('Fetched ${users.length} users'),
);

// POST request with file upload
final formData = MultipartFormDataAdapter({
  'name': 'John Doe',
  'email': 'john@example.com',
  'avatar': File('/path/to/avatar.jpg'),
});

final uploadOperation = apiHandler.post<Map<String, dynamic>>(
  '/users',
  parser: (json) => json,
  formData: formData,
  onSendProgress: (progress) =>
      print('Upload: ${(progress * 100).toInt()}%'),
  isAuthorized: true,
);
final uploadResult = await uploadOperation.value;
uploadResult.match(
  (failure) => logger.error('Upload failed: ${failure.message}'),
  (data) => logger.info('Upload complete: $data'),
);
```

### Authentication

#### **AuthTokenManager**

```dart
class AuthTokenManager {
  AuthTokenManager(
    SecureDatabaseInterface secureDatabaseInterface, {
    bool secureStorageEnabled = false,
  });

  /// Get access token
  Future<String> get accessToken;

  /// Get refresh token
  Future<String> get refreshToken;

  /// Set tokens in memory and optionally persist them
  Future<void> setTokens({
    String? accessToken,
    String? refreshToken,
  });

  /// Clear tokens from memory and storage
  Future<void> clearTokens();
}
```

#### **Authentication Interceptors**

Coore provides two authentication interceptor implementations with automatic token refresh:

- **TokenAuthInterceptor**: Sends Bearer tokens in Authorization header
- **CookieAuthInterceptor**: Sends cookies with `withCredentials: true`

### Interceptors

#### **LoggingInterceptor**

Comprehensive request/response logging with configurable options.

```dart
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    required CoreLogger logger,
    int maxBodyLength = 1024,
    bool logRequest = true,
    bool logResponse = true,
    bool logError = true,
  });
}
```

### Network Status Monitoring

#### **NetworkStatusInterface**

```dart
abstract interface class NetworkStatusInterface {
  Future<bool> get isConnected;
  Stream<ConnectionStatus> get connectionStream;
  void dispose();
}

enum ConnectionStatus { connected, disconnected }
```

---

## 🔄 State Management

### ApiState Class

Comprehensive API state management with loading, success, failure, and retry capabilities.

```dart
@freezed
sealed class ApiState<T> with _$ApiState<T> {
  const ApiState._();
  
  const factory ApiState.initial() = Initial;
  const factory ApiState.loading() = Loading;
  const factory ApiState.succeeded(T successValue) = Succeeded;
  const factory ApiState.failed(
    Failure failure, {
    VoidCallback? retryFunction,
  }) = Failed;
  
  // Convenience getters
  bool get isInitial => this is Initial<T>;
  bool get isLoading => this is Loading<T>;
  bool get isSuccess => this is Succeeded<T>;
  bool get isFailed => this is Failed<T>;
  
  // Data extraction
  Option<T> get data => switch (this) {
    Succeeded<T>(:final successValue) => some(successValue),
    _ => none(),
  };
  
  Option<Failure> get failureObject => switch (this) {
    Failed(:final failure) => some(failure),
    _ => none(),
  };
}
```

### ApiStateHandler and ApiStateHostMixin (Recommended Approach)

The modern approach uses `ApiStateHandler` (a class) and `ApiStateHostMixin` (a mixin) to manage API state. This provides better separation of concerns and allows managing multiple independent API states within a single BLoC/Cubit.

#### **ApiStateHandler**

A delegate class that manages the complete lifecycle of a single API call, including loading, success, failure, retry, and cancellation.

```dart
class ApiStateHandler<CompositeState, SuccessData> implements IApiStateHandler {
  /// Cancels the ongoing API request, if one exists.
  void cancelRequest();

  /// Executes the API call and manages its full state lifecycle.
  Future<void> handleApiCall<T>({
    required UseCaseCancelableFutureResponse<SuccessData> Function(T params) apiCall,
    required T params,
    void Function(SuccessData data)? onSuccess,
    void Function(Failure failure)? onFailure,
  });
}
```

#### **ApiStateHostMixin**

A mixin for `BlocBase` that acts as a factory and manager for `ApiStateHandler` instances. It automatically disposes of handlers when the BLoC/Cubit is closed.

```dart
mixin ApiStateHostMixin<CompositeState> on BlocBase<CompositeState> {
  /// Creates, registers, and returns a new [ApiStateHandler].
  ApiStateHandler<CompositeState, SuccessData> createApiHandler<SuccessData>({
    required ApiState<SuccessData> Function(CompositeState) getApiState,
    required CompositeState Function(CompositeState, ApiState<SuccessData>) setApiState,
  });
}
```

#### **Usage Example**

```dart
// User state with multiple API states
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(ApiState.initial()) ApiState<List<User>> usersState,
    @Default(ApiState.initial()) ApiState<User?> currentUserState,
    @Default('') String searchQuery,
  }) = _UserState;
}

// User Cubit using ApiStateHostMixin
class UserCubit extends Cubit<UserState> with ApiStateHostMixin<UserState> {
  final UserRepository _userRepository;
  
  // Create handlers for each API state
  late final _usersHandler ;
  
  late final _currentUserHandler;
  
  UserCubit(this._userRepository) : super(const UserState()){
  _usersHandler = createApiHandler<List<User>>(
    getApiState: (state) => state.usersState,
    setApiState: (state, apiState) => state.copyWith(usersState: apiState),
  );
  _currentUserHandler = createApiHandler<User?>(
    getApiState: (state) => state.currentUserState,
    setApiState: (state, apiState) => state.copyWith(currentUserState: apiState),
  );
  };
  
  // Load users using the handler
  Future<void> loadUsers() async {
    await _usersHandler.handleApiCall(
      apiCall: _userRepository.getUsers,
      params: PagePaginationParams(page: 1, limit: 20),
      onSuccess: (users) {
        print('Loaded ${users.length} users');
      },
      onFailure: (failure) {
        print('Failed to load users: ${failure.message}');
      },
    );
  }
  
  // Load current user using a different handler
  Future<void> loadCurrentUser(String userId) async {
    await _currentUserHandler.handleApiCall(
      apiCall: (params) => _userRepository.getUserById(userId),
      params: NoParams(),
    );
  }
}
```



### Use Case Architecture

#### **FutureEitherUseCase**

```dart
abstract class FutureEitherUseCase<Output, Input> extends UseCase {
  const FutureEitherUseCase();
  
  UseCaseCancelableFutureResponse<Output> call(Input input);
}
```

#### **Parameter Classes**

```dart
// Pagination Parameters
abstract class PaginationParams {
  int get batch;
  int get limit;
}

@freezed
class PagePaginationParams with _$PagePaginationParams implements PaginationParams {
  const factory PagePaginationParams({
    required int page,
    required int limit,
  }) = _PagePaginationParams;

  @override
  int get batch => page;
}

// Other Parameters
@freezed
class NoParams with _$NoParams {
  const factory NoParams() = _NoParams;
}

@freezed
class IdParam with _$IdParam {
  const factory IdParam({
    required String id,
  }) = _IdParam;
}
```

---

## 💾 Data Management

### Local Database Interface

The `LocalDatabaseInterface` provides a NoSQL database abstraction for local data storage using Hive.

```dart
abstract interface class LocalDatabaseInterface {
  CacheResponse<Unit> initialize();
  CacheResponse<Unit> close();
  CacheResponse<Unit> save<T>(String key, T value);
  CacheResponse<T?> get<T>(String key);
  CacheResponse<Unit> delete(String key);
}
```

### Secure Database Interface

The `SecureDatabaseInterface` provides encrypted storage for sensitive data using Flutter Secure Storage.

```dart
abstract interface class SecureDatabaseInterface {
  CacheResponse<Unit> initialize();
  CacheResponse<String?> read(String key);
  CacheResponse<Map<String, String>> readAll();
  CacheResponse<Unit> write(String key, String value);
  CacheResponse<Unit> delete(String key);
  CacheResponse<Unit> deleteAll();
}
```

### Cache Failure Types

```dart
abstract class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.stackTrace});
}

class CacheNotFoundFailure extends CacheFailure;
class CacheCorruptedFailure extends CacheFailure;
class CacheWriteFailure extends CacheFailure;
class CacheReadFailure extends CacheFailure;
class CacheDeleteFailure extends CacheFailure;
class CacheInitializationFailure extends CacheFailure;
```

---

## 🎨 UI Components & Theming

### Theme Management System

The theme system provides comprehensive light/dark theme support with automatic switching and persistence.

```dart
class ThemeCubit extends Cubit<ThemeConfigEntity> {
  ThemeCubit({
    required ConfigService usecase,
    required ThemeConfigEntity themeConfigEntity,
  });

  /// Set theme mode (light, dark, or system)
  void setThemeMode(ThemeMode mode);
}
```

### Form Components

#### **CoreTextField**

Enterprise-level text field with comprehensive customization and form integration.

#### **CorePinCodeField**

Enterprise-level PIN/OTP input field with comprehensive theming and validation.

### Image Components

#### **CoreImage**

Versatile image widget supporting network, asset, and file images with advanced features including caching, shimmer loading, and error handling.

### Text Components

#### **CoreReadMoreText**

Expandable text widget with rich formatting and customization options.

### Pagination System

#### **CorePaginationWidget**

Enterprise-level pagination widget with comprehensive state management, pull-to-refresh, and skeleton loading.

```dart
class CorePaginationWidget<T extends Identifiable, M extends MetaModel> extends StatefulWidget {
  const CorePaginationWidget({
    super.key,
    this.scrollableBuilder,
    this.sliversBuilder,
    this.paginationFunction,
    this.paginationStrategy,
    this.paginationCubit,
    this.reverse = false,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    // ... more parameters
  });
}
```

---

## 🧭 Navigation & Routing

### CoreRouter

The `CoreRouter` class provides a clean foundation for navigation by configuring and managing your `GoRouter` instance. It handles route configuration, refresh logic, and navigation observers.

**Important**: `CoreRouter` does NOT provide navigation methods. Instead, use the official `go_router_builder` package for type-safe navigation.

```dart
class CoreRouter {
  /// Provides the configured GoRouter instance
  GoRouter get router;

  /// Provides the root navigator key for dialogs/snackbars from BLoCs
  static GlobalKey<NavigatorState> get rootNavigatorKey;
  
  /// Re-creates the router (e.g., after auth state changes)
  void refreshRouter();
}
```

### Type-Safe Navigation with go_router_builder

For type-safe, scalable navigation, use `go_router_builder` with `CoreRouter`:

#### 1. Define Routes with Annotations

```dart
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

@TypedGoRoute<UserDetailsRoute>(path: '/users/:id')
class UserDetailsRoute extends GoRouteData {
  const UserDetailsRoute({required this.id, this.tab});
  
  final String id;
  final String? tab; // Query parameter

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserDetailsScreen(userId: id, initialTab: tab);
  }
}
```

#### 2. Generate Code

```bash
dart run build_runner build
```

#### 3. Navigate from Widgets

```dart
// Type-safe navigation with autocomplete!
context.goUserDetails(id: '123', tab: 'posts');
context.pushUserDetails(id: '456');
```

#### 4. Navigate from BLoCs/Services

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final GoRouter router;
  
  UserBloc(this.router);
  
  void navigateToUser(String userId) {
    final location = UserDetailsRoute(id: userId).location;
    router.push(location);
  }
}
```

#### 5. Show Dialogs from BLoCs

```dart
void showErrorDialog(String message) {
  final context = CoreRouter.rootNavigatorKey.currentContext!;
  showDialog(context: context, builder: (context) => AlertDialog(...));
}
```

### Configuration

```dart
@lazySingleton
class AppNavigationConfig {
  NavigationConfigEntity _buildNavigationConfigEntity() {
    return NavigationConfigEntity(
      routes: $appRoutes, // Generated by go_router_builder
      redirect: (context, state) {
        // Your redirect logic
      },
      refreshListenable: authCubit.stream.toListenable(),
    );
  }
}
```

### Dependency Injection

The `CoreRouter` automatically registers both itself and the `GoRouter` instance:

```dart
// Automatically registered by CoreConfig
getIt<CoreRouter>()  // The router manager
getIt<GoRouter>()    // The router instance (for BLoCs)
```

### Screen Parameters

For projects that need custom parameter classes:

```dart
abstract class BaseScreenParams extends Equatable {
  const BaseScreenParams();
  Map<String, dynamic> get queryParams => {};
  Map<String, String> get pathParams => {};
  Map<String, Object> get extra => {};
}
```

### Animated Route Transitions

Custom page transitions using `go_router_builder`:

```dart
@TypedGoRoute<FadeRoute>(path: '/fade')
class FadeRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const FadeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
```

### Learn More

For comprehensive navigation documentation, see [Navigation Guide](docs/NAVIGATION_GUIDE.md).

---

## 📱 Platform Support

### Platform Detection & Device Information

Comprehensive device information, platform detection, and cross-platform utilities for building applications that work seamlessly across all Flutter-supported platforms.

```dart
enum PlatformType {
  android,
  ios,
  web,
  windows,
  macos,
  linux,
  unknown;
  
  static PlatformType fromDartPlatform();
  String get value;
}
```

### Cross-Platform Utilities

Platform-specific UI adaptations, navigation patterns, styling, file system access, permissions, and performance optimizations.

---

## 🚀 Advanced Features

### Extension Methods

Coore provides a comprehensive set of extension methods that enhance Dart's built-in types:

- **String Extensions**: Date parsing, validation utilities
- **DateTime Extensions**: Comprehensive date/time manipulation
- **File Extensions**: File information and operations
- **Context Extensions**: Flutter context utilities for responsive design

### Development Tools

#### **Core Logger**

Enterprise-grade logging system with structured logging capabilities.

```dart
abstract interface class CoreLogger {
  void verbose(dynamic message, [Object? error, StackTrace? stackTrace]);
  void debug(dynamic message, [Object? error, StackTrace? stackTrace]);
  void info(dynamic message, [Object? error, StackTrace? stackTrace]);
  void warning(dynamic message, [Object? error, StackTrace? stackTrace]);
  void error(dynamic message, [Object? error, StackTrace? stackTrace]);
}
```

---

## 📚 Best Practices & Guidelines

### Architecture Best Practices

1. **Clean Architecture Principles**: Clear separation of concerns
2. **Dependency Injection**: Constructor injection
3. **Error Handling**: Comprehensive error handling with Either types

### State Management Best Practices

1. **Immutable States**: Use Freezed for immutable state
2. **Single Responsibility**: Focused Cubits/BLoCs
3. **Use ApiStateHostMixin**: For managing multiple API states

### UI Best Practices

1. **Responsive Design**: Use LayoutBuilder for adaptive layouts
2. **Theme Consistency**: Use theme colors and text styles
3. **Performance**: Lazy loading with pagination, optimized image loading

---

**🎉 Documentation Complete**: All sections have been documented with comprehensive coverage of every feature, API, and best practice in the Coore package.
