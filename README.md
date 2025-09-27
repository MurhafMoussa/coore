# 🎯 Coore - Enterprise Flutter Core Package

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

A comprehensive, enterprise-level Flutter package that provides a complete foundation for building scalable, maintainable Flutter applications. Coore offers a robust set of core utilities, state management, networking, localization, theming, and UI components designed for production-ready applications.

## 🚀 **Quick Start**

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

## 🏗️ **Architecture Overview**

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
│   ├── GoRouter Integration - Declarative routing
│   ├── Screen Parameters - Type-safe navigation
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

## 📋 **Core Features**

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
- **GoRouter Integration**: Declarative routing with deep linking
- **Type-safe Navigation**: Screen parameters with compile-time safety
- **Route Animations**: Custom page transitions

### 📱 **Platform Support**
- **Device Information**: Platform detection and device details
- **Platform Services**: Native platform integrations
- **Cross-platform APIs**: Platform-agnostic utilities

---

## 🔧 **Step 2: Core Infrastructure & Configuration**

### **CoreConfig Class**

The `CoreConfig` class is the central configuration manager that handles the initialization of all core dependencies and services.

#### **Public API**

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

#### **Usage Example**

```dart
// Basic initialization
await CoreConfig.initializeCoreDependencies(
  CoreConfigEntity(
    currentEnvironment: CoreEnvironment.development,
    networkConfigEntity: NetworkConfigEntity(
      baseUrl: 'https://api.example.com',
    ),
    localizationConfigEntity: LocalizationConfigEntity(
      defaultLocale: Locale('en'),
      supportedLocales: [Locale('en'), Locale('ar')],
      localizationsDelegates: [/* your delegates */],
    ),
    themeConfigEntity: ThemeConfigEntity.defaultConfig(),
    shouldLog: true,
    enableSecureStorage: true,
  ),
);

// Additional setup after project initialization
await CoreConfig.initializeCoreDependenciesAfterProjectSetup(
  CoreConfigAfterProjectSetupEntity(
    navigationConfigEntity: NavigationConfigEntity(
      routes: [/* your routes */],
      initialRoute: '/',
    ),
    shouldLog: true,
  ),
);
```

### **CoreConfigEntity**

Central configuration entity that defines all application settings.

#### **Public API**

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

### **Environment Management**

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

#### **EnvironmentConfig Class**

```dart
class EnvironmentConfig {
  /// Load environment variables from .env files
  Future<void> loadEnv(CoreEnvironment environment, {String? customPath});
  
  /// Get string value from environment
  String getString(String key, {String? fallback});
  
  /// Get integer value from environment
  int getInt(String key, {int fallback = -1});
  
  /// Get boolean value from environment
  bool getBool(String key, {bool fallback = false});
  
  /// Get double value from environment
  double getDouble(String key, {double fallback = -1});
  
  /// Get optional value from environment
  String? maybeGet(String key, {String? fallback});
}
```

#### **Usage Example**

```dart
final envConfig = EnvironmentConfig();

// Load environment-specific configuration
await envConfig.loadEnv(CoreEnvironment.development);

// Access environment variables
final apiUrl = envConfig.getString('API_URL');
final isDebug = envConfig.getBool('DEBUG_MODE');
final port = envConfig.getInt('PORT', fallback: 3000);
```

### **Network Configuration**

#### **NetworkConfigEntity**

Comprehensive network configuration with timeout, retry, and caching options.

#### **Public API**

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
  final bool enableCache;
  final Duration cacheDuration;
  final bool followRedirects;
  final int maxRedirects;
  final List<Interceptor> interceptors;
  final AuthInterceptorType authInterceptorType;
}

enum AuthInterceptorType { tokenBased, cookieBased }
```

#### **Usage Example**

```dart
final networkConfig = NetworkConfigEntity(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 30),
  sendTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
  staticHeaders: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-API-Key': 'your-api-key',
  },
  maxRetries: 3,
  retryInterval: Duration(seconds: 2),
  enableCache: true,
  cacheDuration: Duration(minutes: 10),
  authInterceptorType: AuthInterceptorType.tokenBased,
);
```

### **Localization Configuration**

#### **LocalizationConfigEntity**

```dart
class LocalizationConfigEntity extends Equatable {
  const LocalizationConfigEntity({
    required this.supportedLocales,
    required this.localizationsDelegates,
    required this.defaultLocale,
  });
  
  final List<Locale> supportedLocales;
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale defaultLocale;
}
```

#### **Usage Example**

```dart
final localizationConfig = LocalizationConfigEntity(
  supportedLocales: [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
    Locale('fr', 'FR'),
  ],
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  defaultLocale: Locale('en', 'US'),
);
```

### **Theme Configuration**

#### **ThemeConfigEntity**

```dart
class ThemeConfigEntity extends Equatable {
  const ThemeConfigEntity({
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
    required this.enableAutoSwitch,
  });
  
  factory ThemeConfigEntity.defaultConfig();
  
  final ThemeMode themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final bool enableAutoSwitch;
  
  ThemeConfigEntity copyWith({
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? enableAutoSwitch,
  });
}
```

#### **Usage Example**

```dart
final themeConfig = ThemeConfigEntity(
  themeMode: ThemeMode.system,
  lightTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
  enableAutoSwitch: true,
);
```

### **Navigation Configuration**

#### **NavigationConfigEntity**

```dart
class NavigationConfigEntity extends Equatable {
  const NavigationConfigEntity({
    required this.routes,
    required this.initialRoute,
    this.errorBuilder,
    this.redirect,
    this.navigationObservers = const [],
    this.refreshListenable,
  });
  
  final List<RouteBase> routes;
  final String initialRoute;
  final Widget Function(BuildContext, GoRouterState)? errorBuilder;
  final Future<String?> Function(BuildContext, GoRouterState)? redirect;
  final Listenable? refreshListenable;
  final List<NavigatorObserver> navigationObservers;
}
```

### **Error Handling System**

#### **Failure Classes**

Comprehensive error handling with specific failure types for different scenarios.

#### **Base Failure**

```dart
abstract class Failure extends Equatable implements Exception {
  const Failure(this.message, {this.stackTrace});
  final String message;
  final StackTrace? stackTrace;
}

class UnknownFailure extends Failure {
  const UnknownFailure({StackTrace? stackTrace});
}
```

#### **Network Failures**

```dart
abstract class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.stackTrace});
}

// HTTP Status Code Failures
class BadRequestFailure extends NetworkFailure;
class UnauthorizedRequestFailure extends NetworkFailure;
class ForbiddenFailure extends NetworkFailure;
class NotFoundFailure extends NetworkFailure;
class ValidationFailure extends NetworkFailure;
class TooManyRequestsFailure extends NetworkFailure;
class InternalServerErrorFailure extends NetworkFailure;
class ServiceUnavailableFailure extends NetworkFailure;

// Connection Failures
class RequestCancelledFailure extends NetworkFailure;
class RequestTimeoutFailure extends NetworkFailure;
class NoInternetConnectionFailure extends NetworkFailure;
class ConnectionErrorFailure extends NetworkFailure;
```

#### **Usage Example**

```dart
try {
  final result = await apiService.getData();
  return result;
} catch (e) {
  if (e is NetworkFailure) {
    switch (e.runtimeType) {
      case UnauthorizedRequestFailure:
        // Handle authentication error
        break;
      case NoInternetConnectionFailure:
        // Handle network connectivity
        break;
      case ValidationFailure:
        // Handle validation errors
        break;
      default:
        // Handle other network errors
        break;
    }
  }
  rethrow;
}
```

### **Dependency Injection**

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
final response = await apiHandler.get('/users');
```

---

## 🌐 **Step 3: Networking & API Management**

### **API Handler Interface**

The `ApiHandlerInterface` provides a comprehensive HTTP client with functional programming patterns using `TaskEither` for robust error handling.

#### **Public API**

```dart
abstract interface class ApiHandlerInterface {
  /// HTTP GET request
  ApiHandlerResponse get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelRequestAdapter? cancelRequestAdapter,
    bool shouldCache = false,
    bool isAuthorized = false,
  });

  /// HTTP POST request
  ApiHandlerResponse post(
    String path, {
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = false,
  });

  /// HTTP PUT request
  ApiHandlerResponse put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = false,
  });

  /// HTTP PATCH request
  ApiHandlerResponse patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = false,
  });

  /// HTTP DELETE request
  ApiHandlerResponse delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = false,
  });

  /// File download
  ApiHandlerResponse download(
    String url,
    String downloadDestinationPath, {
    ProgressTrackerCallback? onReceiveProgress,
    CancelRequestAdapter? cancelRequestAdapter,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
  });
}
```

#### **Usage Example**

```dart
final apiHandler = getIt<ApiHandlerInterface>();

// GET request with caching
final result = await apiHandler.get(
  '/users',
  queryParameters: {'page': 1, 'limit': 10},
  shouldCache: true,
  isAuthorized: true,
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (data) => print('Users: $data'),
);

// POST request with file upload
final formData = MultipartFormDataAdapter({
  'name': 'John Doe',
  'email': 'john@example.com',
  'avatar': File('/path/to/avatar.jpg'),
});

final uploadResult = await apiHandler.post(
  '/users',
  formData: formData,
  onSendProgress: (progress) => print('Upload: ${(progress * 100).toInt()}%'),
  isAuthorized: true,
);

// File download with progress tracking
final downloadResult = await apiHandler.download(
  'https://example.com/file.pdf',
  '/local/path/file.pdf',
  onReceiveProgress: (progress) => print('Download: ${(progress * 100).toInt()}%'),
  isAuthorized: true,
);
```

### **Authentication Token Manager**

The `AuthTokenManager` handles secure token storage and retrieval with optional encrypted storage.

#### **Public API**

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

#### **Usage Example**

```dart
final tokenManager = getIt<AuthTokenManager>();

// Set tokens after login
await tokenManager.setTokens(
  accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
);

// Get tokens for API calls
final accessToken = await tokenManager.accessToken;
final refreshToken = await tokenManager.refreshToken;

// Clear tokens on logout
await tokenManager.clearTokens();
```

### **Authentication Interceptors**

Coore provides two authentication interceptor implementations with automatic token refresh.

#### **TokenAuthInterceptor**

```dart
class TokenAuthInterceptor extends AuthInterceptor {
  TokenAuthInterceptor(AuthTokenManager tokenManager);
}
```

- Sends Bearer tokens in Authorization header
- Automatically refreshes tokens on 401 errors
- Queues pending requests during refresh
- Handles token refresh via `auth/refresh` endpoint

#### **CookieAuthInterceptor**

```dart
class CookieAuthInterceptor extends AuthInterceptor {
  CookieAuthInterceptor(AuthTokenManager tokenManager);
}
```

- Sends cookies with `withCredentials: true`
- Supports both cookie and Bearer token authentication
- Automatic token refresh with cookie-based sessions

#### **Usage Example**

```dart
// Token-based authentication
final tokenInterceptor = TokenAuthInterceptor(tokenManager);

// Cookie-based authentication
final cookieInterceptor = CookieAuthInterceptor(tokenManager);

// Add to Dio instance
dio.interceptors.add(tokenInterceptor);
```

### **Logging Interceptor**

Comprehensive request/response logging with configurable options.

#### **Public API**

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

#### **Features**

- **Request Logging**: Method, URL, headers, query parameters, body
- **Response Logging**: Status code, headers, response body
- **Error Logging**: Error type, message, status code, stack trace
- **FormData Support**: Special handling for multipart form data
- **Body Truncation**: Configurable maximum body length
- **Selective Logging**: Enable/disable request, response, or error logging

#### **Usage Example**

```dart
final loggingInterceptor = LoggingInterceptor(
  logger: getIt<CoreLogger>(),
  maxBodyLength: 2048,
  logRequest: true,
  logResponse: true,
  logError: true,
);

dio.interceptors.add(loggingInterceptor);
```

### **Network Status Monitoring**

#### **NetworkStatusInterface**

```dart
abstract interface class NetworkStatusInterface {
  Future<bool> get isConnected;
  Stream<ConnectionStatus> get connectionStream;
  void dispose();
}

enum ConnectionStatus { connected, disconnected }
```

#### **NetworkStatusCubit**

```dart
class NetworkStatusCubit extends Cubit<ConnectionStatus> {
  NetworkStatusCubit({required NetworkStatusInterface networkStatus});
}
```

#### **Usage Example**

```dart
// Access network status
final networkStatus = getIt<NetworkStatusInterface>();
final networkCubit = getIt<NetworkStatusCubit>();

// Check connection status
final isConnected = await networkStatus.isConnected;

// Listen to connection changes
networkStatus.connectionStream.listen((status) {
  switch (status) {
    case ConnectionStatus.connected:
      print('Connected to internet');
      break;
    case ConnectionStatus.disconnected:
      print('No internet connection');
      break;
  }
});

// Use in widget
BlocBuilder<NetworkStatusCubit, ConnectionStatus>(
  builder: (context, status) {
    return status == ConnectionStatus.connected
        ? Icon(Icons.wifi, color: Colors.green)
        : Icon(Icons.wifi_off, color: Colors.red);
  },
)
```

### **Form Data Adapters**

#### **FormDataAdapter Interface**

```dart
abstract class FormDataAdapter {
  const FormDataAdapter(Map<String, dynamic> body);
  FormData create();
}
```

#### **DefaultFormDataAdapter**

```dart
class DefaultFormDataAdapter extends FormDataAdapter {
  const DefaultFormDataAdapter(Map<String, dynamic> body);
  FormData create();
}
```

#### **MultipartFormDataAdapter**

```dart
class MultipartFormDataAdapter extends FormDataAdapter {
  const MultipartFormDataAdapter(Map<String, dynamic> body);
  FormData create();
}
```

#### **Usage Example**

```dart
// Simple form data
final simpleForm = DefaultFormDataAdapter({
  'name': 'John Doe',
  'email': 'john@example.com',
});

// Multipart with files
final multipartForm = MultipartFormDataAdapter({
  'name': 'John Doe',
  'email': 'john@example.com',
  'avatar': File('/path/to/avatar.jpg'),
  'documents': [File('/path/doc1.pdf'), File('/path/doc2.pdf')],
});

// Use in API call
final result = await apiHandler.post(
  '/upload',
  formData: multipartForm,
  isAuthorized: true,
);
```

### **Type Definitions**

#### **Core TypeDefs**

```dart
typedef ApiHandlerResponse = Future<Either<NetworkFailure, Map<String, dynamic>>>;
typedef RemoteResponse<T> = Future<Either<NetworkFailure, T>>;
typedef CacheResponse<T> = Future<Either<CacheFailure, T>>;
typedef UseCaseFutureResponse<T> = Future<Either<Failure, T>>;
typedef UseCaseStreamResponse<T> = Stream<Either<Failure, T>>;
typedef ProgressTrackerCallback = void Function(double progress);
typedef Id = String;
```

### **Complete API Usage Example**

```dart
class UserRepository {
  final ApiHandlerInterface _apiHandler;
  final AuthTokenManager _tokenManager;

  UserRepository(this._apiHandler, this._tokenManager);

  Future<Either<NetworkFailure, List<User>>> getUsers({
    int page = 1,
    int limit = 10,
    bool useCache = false,
  }) async {
    final result = await _apiHandler.get(
      '/users',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      shouldCache: useCache,
      isAuthorized: true,
    );

    return result.fold(
      (failure) => left(failure),
      (data) {
        final users = (data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();
        return right(users);
      },
    );
  }

  Future<Either<NetworkFailure, User>> createUser({
    required String name,
    required String email,
    File? avatar,
  }) async {
    final formData = avatar != null
        ? MultipartFormDataAdapter({
            'name': name,
            'email': email,
            'avatar': avatar,
          })
        : null;

    final result = await _apiHandler.post(
      '/users',
      body: formData == null ? {'name': name, 'email': email} : null,
      formData: formData,
      isAuthorized: true,
    );

    return result.fold(
      (failure) => left(failure),
      (data) => right(User.fromJson(data['data'])),
    );
  }

  Future<Either<NetworkFailure, void>> deleteUser(String userId) async {
    final result = await _apiHandler.delete(
      '/users/$userId',
      isAuthorized: true,
    );

    return result.fold(
      (failure) => left(failure),
      (_) => right(null),
    );
  }
}
```

---

## 💾 **Step 4: Data Management & Storage**

### **Local Database Interface**

The `LocalDatabaseInterface` provides a NoSQL database abstraction for local data storage using Hive.

#### **Public API**

```dart
abstract interface class LocalDatabaseInterface {
  /// Initialize the database
  CacheResponse<Unit> initialize();

  /// Close the database connection
  CacheResponse<Unit> close();

  /// Save data with a key
  CacheResponse<Unit> save<T>(String key, T value);

  /// Retrieve data by key
  CacheResponse<T?> get<T>(String key);

  /// Delete data by key
  CacheResponse<Unit> delete(String key);
}
```

#### **HiveLocalDatabase Implementation**

```dart
class HiveLocalDatabase implements LocalDatabaseInterface {
  HiveLocalDatabase(String boxName);
}
```

#### **Usage Example**

```dart
final localDb = HiveLocalDatabase('user_preferences');

// Initialize database
final initResult = await localDb.initialize();
initResult.fold(
  (failure) => print('Failed to initialize: ${failure.message}'),
  (_) => print('Database initialized successfully'),
);

// Save data
final saveResult = await localDb.save('user_name', 'John Doe');
saveResult.fold(
  (failure) => print('Save failed: ${failure.message}'),
  (_) => print('Data saved successfully'),
);

// Retrieve data
final getResult = await localDb.get<String>('user_name');
getResult.fold(
  (failure) => print('Get failed: ${failure.message}'),
  (data) => print('User name: $data'),
);

// Delete data
final deleteResult = await localDb.delete('user_name');
deleteResult.fold(
  (failure) => print('Delete failed: ${failure.message}'),
  (_) => print('Data deleted successfully'),
);

// Close database
await localDb.close();
```

### **Secure Database Interface**

The `SecureDatabaseInterface` provides encrypted storage for sensitive data using Flutter Secure Storage.

#### **Public API**

```dart
abstract interface class SecureDatabaseInterface {
  /// Initialize the secure storage
  CacheResponse<Unit> initialize();

  /// Read a value by key
  CacheResponse<String?> read(String key);

  /// Read all stored values
  CacheResponse<Map<String, String>> readAll();

  /// Write a value with a key
  CacheResponse<Unit> write(String key, String value);

  /// Delete a value by key
  CacheResponse<Unit> delete(String key);

  /// Delete all stored values
  CacheResponse<Unit> deleteAll();
}
```

#### **SecureDatabaseImp Implementation**

```dart
class SecureDatabaseImp implements SecureDatabaseInterface {
  SecureDatabaseImp(FlutterSecureStorage flutterSecureStorage);
}
```

#### **Usage Example**

```dart
final secureDb = getIt<SecureDatabaseInterface>();

// Initialize secure storage
final initResult = await secureDb.initialize();
initResult.fold(
  (failure) => print('Failed to initialize: ${failure.message}'),
  (_) => print('Secure storage initialized'),
);

// Store sensitive data
final writeResult = await secureDb.write('api_token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
writeResult.fold(
  (failure) => print('Write failed: ${failure.message}'),
  (_) => print('Token stored securely'),
);

// Retrieve sensitive data
final readResult = await secureDb.read('api_token');
readResult.fold(
  (failure) => print('Read failed: ${failure.message}'),
  (token) => print('Token: $token'),
);

// Read all stored data
final readAllResult = await secureDb.readAll();
readAllResult.fold(
  (failure) => print('Read all failed: ${failure.message}'),
  (data) => print('All data: $data'),
);

// Delete specific data
final deleteResult = await secureDb.delete('api_token');
deleteResult.fold(
  (failure) => print('Delete failed: ${failure.message}'),
  (_) => print('Token deleted'),
);

// Clear all data
final deleteAllResult = await secureDb.deleteAll();
deleteAllResult.fold(
  (failure) => print('Delete all failed: ${failure.message}'),
  (_) => print('All data cleared'),
);
```

### **Cache Failure Types**

Comprehensive error handling for cache operations with specific failure types.

#### **Cache Failure Classes**

```dart
abstract class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.stackTrace});
}

/// Cache entry not found
class CacheNotFoundFailure extends CacheFailure;

/// Cache data is corrupted
class CacheCorruptedFailure extends CacheFailure;

/// Failed to write to cache
class CacheWriteFailure extends CacheFailure;

/// Failed to read from cache
class CacheReadFailure extends CacheFailure;

/// Failed to delete from cache
class CacheDeleteFailure extends CacheFailure;

/// Cache initialization failed
class CacheInitializationFailure extends CacheFailure;
```

#### **Usage Example**

```dart
final result = await localDb.get<String>('non_existent_key');
result.fold(
  (failure) {
    switch (failure.runtimeType) {
      case CacheNotFoundFailure:
        print('Key not found in cache');
        break;
      case CacheReadFailure:
        print('Failed to read from cache');
        break;
      case CacheCorruptedFailure:
        print('Cache data is corrupted');
        break;
      default:
        print('Cache error: ${failure.message}');
        break;
    }
  },
  (data) => print('Data retrieved: $data'),
);
```

### **Data Repository Pattern**

Complete repository implementation using both local and secure storage.

#### **User Preferences Repository**

```dart
class UserPreferencesRepository {
  final LocalDatabaseInterface _localDb;
  final SecureDatabaseInterface _secureDb;

  UserPreferencesRepository(this._localDb, this._secureDb);

  // Local storage operations
  Future<Either<CacheFailure, Unit>> saveTheme(String theme) async {
    return await _localDb.save('theme', theme);
  }

  Future<Either<CacheFailure, String?>> getTheme() async {
    return await _localDb.get<String>('theme');
  }

  Future<Either<CacheFailure, Unit>> saveLanguage(String language) async {
    return await _localDb.save('language', language);
  }

  Future<Either<CacheFailure, String?>> getLanguage() async {
    return await _localDb.get<String>('language');
  }

  // Secure storage operations
  Future<Either<CacheFailure, Unit>> saveAuthToken(String token) async {
    return await _secureDb.write('auth_token', token);
  }

  Future<Either<CacheFailure, String?>> getAuthToken() async {
    return await _secureDb.read('auth_token');
  }

  Future<Either<CacheFailure, Unit>> saveRefreshToken(String token) async {
    return await _secureDb.write('refresh_token', token);
  }

  Future<Either<CacheFailure, String?>> getRefreshToken() async {
    return await _secureDb.read('refresh_token');
  }

  // Clear all data
  Future<Either<CacheFailure, Unit>> clearAllData() async {
    final localResult = await _localDb.close();
    if (localResult.isLeft()) return localResult;

    return await _secureDb.deleteAll();
  }

  // Clear only secure data
  Future<Either<CacheFailure, Unit>> clearSecureData() async {
    return await _secureDb.deleteAll();
  }
}
```

### **Data Service Integration**

Integration with dependency injection and service locator pattern.

#### **Service Registration**

```dart
// In dependency injection setup
getIt.registerLazySingleton<LocalDatabaseInterface>(
  () => HiveLocalDatabase('app_data'),
);

getIt.registerLazySingleton<SecureDatabaseInterface>(
  () => SecureDatabaseImp(getIt<FlutterSecureStorage>()),
);

getIt.registerLazySingleton<UserPreferencesRepository>(
  () => UserPreferencesRepository(
    getIt<LocalDatabaseInterface>(),
    getIt<SecureDatabaseInterface>(),
  ),
);
```

#### **Service Usage**

```dart
class UserService {
  final UserPreferencesRepository _preferencesRepo;
  final AuthTokenManager _tokenManager;

  UserService(this._preferencesRepo, this._tokenManager);

  Future<void> saveUserPreferences({
    required String theme,
    required String language,
  }) async {
    // Save theme preference
    final themeResult = await _preferencesRepo.saveTheme(theme);
    themeResult.fold(
      (failure) => print('Failed to save theme: ${failure.message}'),
      (_) => print('Theme saved successfully'),
    );

    // Save language preference
    final languageResult = await _preferencesRepo.saveLanguage(language);
    languageResult.fold(
      (failure) => print('Failed to save language: ${failure.message}'),
      (_) => print('Language saved successfully'),
    );
  }

  Future<void> loadUserPreferences() async {
    // Load theme
    final themeResult = await _preferencesRepo.getTheme();
    themeResult.fold(
      (failure) => print('Failed to load theme: ${failure.message}'),
      (theme) => print('Current theme: $theme'),
    );

    // Load language
    final languageResult = await _preferencesRepo.getLanguage();
    languageResult.fold(
      (failure) => print('Failed to load language: ${failure.message}'),
      (language) => print('Current language: $language'),
    );
  }

  Future<void> login(String accessToken, String refreshToken) async {
    // Save tokens securely
    final tokenResult = await _preferencesRepo.saveAuthToken(accessToken);
    final refreshResult = await _preferencesRepo.saveRefreshToken(refreshToken);

    // Also update token manager
    await _tokenManager.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    // Handle results
    tokenResult.fold(
      (failure) => print('Failed to save auth token: ${failure.message}'),
      (_) => print('Auth token saved securely'),
    );

    refreshResult.fold(
      (failure) => print('Failed to save refresh token: ${failure.message}'),
      (_) => print('Refresh token saved securely'),
    );
  }

  Future<void> logout() async {
    // Clear secure data
    final clearResult = await _preferencesRepo.clearSecureData();
    clearResult.fold(
      (failure) => print('Failed to clear secure data: ${failure.message}'),
      (_) => print('Secure data cleared'),
    );

    // Clear token manager
    await _tokenManager.clearTokens();
  }
}
```

### **Data Migration and Versioning**

Handling data migration and versioning for local storage.

#### **Migration Example**

```dart
class DataMigrationService {
  final LocalDatabaseInterface _localDb;

  DataMigrationService(this._localDb);

  Future<Either<CacheFailure, Unit>> migrateToV2() async {
    // Get current version
    final versionResult = await _localDb.get<String>('app_version');
    
    return versionResult.fold(
      (failure) => left(failure),
      (version) async {
        if (version == null || version != '2.0') {
          // Perform migration
          final migrationResult = await _performMigration();
          if (migrationResult.isLeft()) return migrationResult;

          // Update version
          return await _localDb.save('app_version', '2.0');
        }
        return right(unit);
      },
    );
  }

  Future<Either<CacheFailure, Unit>> _performMigration() async {
    // Example: Migrate old user data format
    final oldUserResult = await _localDb.get<Map<String, dynamic>>('user_data');
    
    return oldUserResult.fold(
      (failure) => left(failure),
      (oldUser) async {
        if (oldUser != null) {
          // Transform old format to new format
          final newUser = {
            'id': oldUser['userId'],
            'name': oldUser['userName'],
            'email': oldUser['userEmail'],
            'created_at': DateTime.now().toIso8601String(),
          };

          // Save new format
          final saveResult = await _localDb.save('user_data_v2', newUser);
          if (saveResult.isLeft()) return saveResult;

          // Remove old data
          return await _localDb.delete('user_data');
        }
        return right(unit);
      },
    );
  }
}
```

---

## 🎨 **Step 5: UI Components & Theming**

### **Theme Management System**

The theme system provides comprehensive light/dark theme support with automatic switching and persistence.

#### **ThemeCubit**

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

#### **ThemeWrapper Widget**

```dart
class ThemeWrapper extends StatelessWidget {
  const ThemeWrapper({
    super.key,
    required this.builder,
  });

  /// Builder function that receives theme configuration
  final Widget Function(BuildContext context, ThemeConfigEntity themeConfig) builder;
}
```

#### **Usage Example**

```dart
// Wrap your app with ThemeWrapper
ThemeWrapper(
  builder: (context, themeConfig) {
    return MaterialApp(
      theme: themeConfig.lightTheme,
      darkTheme: themeConfig.darkTheme,
      themeMode: themeConfig.themeMode,
      home: MyHomePage(),
    );
  },
)

// Access theme cubit
final themeCubit = getIt<ThemeCubit>();

// Change theme
themeCubit.setThemeMode(ThemeMode.dark);

// Listen to theme changes
BlocBuilder<ThemeCubit, ThemeConfigEntity>(
  builder: (context, themeConfig) {
    return IconButton(
      icon: Icon(themeConfig.themeMode == ThemeMode.dark 
          ? Icons.light_mode 
          : Icons.dark_mode),
      onPressed: () {
        final newMode = themeConfig.themeMode == ThemeMode.dark 
            ? ThemeMode.light 
            : ThemeMode.dark;
        themeCubit.setThemeMode(newMode);
      },
    );
  },
)
```

---

**📝 Note**: This completes Step 5 of the comprehensive documentation. The UI components and theming system provides enterprise-grade widgets with comprehensive customization, form integration, and consistent design patterns.

### **Form Components**

#### **CoreTextField**

Enterprise-level text field with comprehensive customization and form integration.

#### **Public API**

```dart
class CoreTextField extends StatefulWidget {
  const CoreTextField({
    super.key,
    required this.name,
    this.enabled = true,
    this.obscureText = false,
    this.expands = false,
    this.readOnly = false,
    this.enableClear = false,
    this.enableSuggestions = true,
    this.showCursor = true,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.autoFillHints,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.initialText,
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.customClearIcon,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.style,
    this.errorBuilder,
    this.showRequiredStar = false,
    this.requiredStarColor,
    this.requiredStarWidget,
    this.requiredIndicatorBuilder,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.prefixWidget,
    this.suffixWidget,
    this.debounceTime,
    this.transformValue,
    this.formatText,
    this.autofocus = false,
    this.visibilityToggleBuilder,
    this.visibilityIconBuilder,
    this.onVisibilityChanged,
  });
}
```

#### **Usage Example**

```dart
// Basic text field
CoreTextField(
  name: 'email',
  labelText: 'Email Address',
  hintText: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  prefixIcon: Icon(Icons.email),
  showRequiredStar: true,
)

// Password field with visibility toggle
CoreTextField(
  name: 'password',
  labelText: 'Password',
  hintText: 'Enter your password',
  obscureText: true,
  enableClear: true,
  textInputAction: TextInputAction.done,
  prefixIcon: Icon(Icons.lock),
  visibilityToggleBuilder: (context, isObscured, toggle, setObscured) {
    return IconButton(
      icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
      onPressed: toggle,
    );
  },
)

// Multi-line text field with character limit
CoreTextField(
  name: 'description',
  labelText: 'Description',
  hintText: 'Enter description',
  maxLines: 5,
  maxLength: 500,
  textInputAction: TextInputAction.newline,
  counterBuilder: (context, {required currentLength, required isFocused, required maxLength}) {
    return Text('$currentLength/$maxLength');
  },
)

// Search field with debouncing
CoreTextField(
  name: 'search',
  hintText: 'Search...',
  prefixIcon: Icon(Icons.search),
  enableClear: true,
  debounceTime: Duration(milliseconds: 300),
  onSubmitted: (value) {
    // Handle search
  },
)
```

#### **CorePinCodeField**

Enterprise-level PIN/OTP input field with comprehensive theming and validation.

#### **Public API**

```dart
class CorePinCodeField extends StatefulWidget {
  const CorePinCodeField({
    super.key,
    required this.name,
    this.length = 6,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.obscuringWidget,
    this.autofocus = false,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    this.onClipboardFound,
    this.onAppPrivateCommand,
    this.pinTheme,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.submittedPinTheme,
    this.followingPinTheme,
    this.disabledPinTheme,
    this.errorPinTheme,
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.closeKeyboardWhenCompleted = true,
    this.hapticFeedbackType = HapticFeedbackType.disabled,
    this.useNativeKeyboard = true,
    this.toolbarEnabled = true,
    this.enableSuggestions = true,
    this.enableIMEPersonalizedLearning = false,
    this.autofillHints,
    this.smsRetriever,
    this.textCapitalization = TextCapitalization.none,
    this.animationCurve = Curves.easeIn,
    this.animationDuration = const Duration(milliseconds: 200),
    this.pinAnimationType = PinAnimationType.scale,
    this.slideTransitionBeginOffset,
    this.showCursor = true,
    this.cursor,
    this.isCursorAnimationEnabled = true,
    this.separatorBuilder,
    this.preFilledWidget,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.pinContentAlignment = Alignment.center,
    this.scrollPadding = const EdgeInsets.all(20),
    this.errorBuilder,
    this.errorTextStyle,
    this.inputFormatters,
    this.selectionControls,
    this.restorationId,
    this.mouseCursor,
    this.keyboardAppearance,
    this.contextMenuBuilder,
    this.debounceTime,
    this.transformValue,
  });
}
```

#### **Usage Example**

```dart
// Basic PIN field
CorePinCodeField(
  name: 'otp',
  length: 6,
  autofocus: true,
  onCompleted: (pin) {
    // Handle OTP completion
    print('OTP entered: $pin');
  },
)

// Themed PIN field
CorePinCodeField(
  name: 'verification_code',
  length: 4,
  defaultPinTheme: PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  focusedPinTheme: PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  errorPinTheme: PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  hapticFeedbackType: HapticFeedbackType.lightImpact,
  pinAnimationType: PinAnimationType.fade,
  animationDuration: Duration(milliseconds: 300),
)

// PIN field with separators
CorePinCodeField(
  name: 'phone_verification',
  length: 5,
  separatorBuilder: (index) => SizedBox(width: 8),
  onCompleted: (pin) {
    // Verify phone number
  },
)
```

### **Image Components**

#### **CoreImage**

Versatile image widget supporting network, asset, and file images with advanced features.

#### **Public API**

```dart
class CoreImage extends StatelessWidget {
  /// Network image with caching
  const CoreImage.network(
    String imageUrl, {
    String? placeholderAssetImage,
    Widget Function(BuildContext context, String)? placeholderBuilder,
    Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder,
    Widget Function(BuildContext, String, dynamic)? errorBuilder,
    bool showError = false,
    bool showProgressIndicator = false,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    int? memCacheWidth,
    int? memCacheHeight,
    String? cacheKey,
    int? maxWidthDiskCache,
    int? maxHeightDiskCache,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    Color? placeholderForegroundColor,
    Map<String, String>? httpHeaders,
    Widget Function(BuildContext context, ImageProvider<Object>)? imageBuilder,
    Duration fadeOutDuration = const Duration(milliseconds: 1000),
    Curve fadeOutCurve = Curves.easeOut,
    Duration fadeInDuration = const Duration(milliseconds: 500),
    Curve fadeInCurve = Curves.easeIn,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    bool useOldImageOnUrlChange = false,
    Color? color,
    Color? progressBarColor,
    FilterQuality filterQuality = FilterQuality.low,
    BlendMode? colorBlendMode,
    Duration? placeholderFadeInDuration,
    BorderRadiusGeometry? borderRadius,
  });

  /// Asset image
  const CoreImage.asset(
    String imagePath, {
    double? scale,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  });

  /// File image
  CoreImage.file(
    String filePath, {
    double? scale,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  });
}
```

#### **Usage Example**

```dart
// Network image with shimmer loading
CoreImage.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  borderRadius: BorderRadius.circular(12),
  placeholderAssetImage: 'assets/placeholder.png',
  shimmerBaseColor: Colors.grey[300],
  shimmerHighlightColor: Colors.grey[100],
)

// Network image with custom error handling
CoreImage.network(
  'https://example.com/profile.jpg',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(50),
  errorBuilder: (context, url, error) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[300],
      child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
    );
  },
  progressIndicatorBuilder: (context, url, progress) {
    return Center(
      child: CircularProgressIndicator(
        value: progress.downloaded / (progress.totalSize ?? 1),
      ),
    );
  },
)

// Asset image
CoreImage.asset(
  'assets/logo.png',
  width: 150,
  height: 50,
  fit: BoxFit.contain,
)

// File image
CoreImage.file(
  '/path/to/local/image.jpg',
  width: 300,
  height: 200,
  fit: BoxFit.cover,
)
```

### **Text Components**

#### **CoreReadMoreText**

Expandable text widget with rich formatting and customization options.

#### **Public API**

```dart
class CoreReadMoreText extends StatefulWidget {
  const CoreReadMoreText(
    this.data, {
    super.key,
    this.isCollapsed,
    this.preDataText,
    this.postDataText,
    this.preDataTextStyle,
    this.postDataTextStyle,
    this.trimExpandedText = 'show less',
    this.trimCollapsedText = 'read more',
    this.colorClickableText,
    this.trimLength = 100,
    this.trimLines = 2,
    this.trimMode = CoreTrimMode.line,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaler,
    this.semanticsLabel,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = '… ',
    this.delimiterStyle,
    this.isExpandable = true,
  });
}

enum CoreTrimMode { length, line }
```

#### **Usage Example**

```dart
// Basic read more text
CoreReadMoreText(
  'This is a very long text that will be truncated and can be expanded by clicking the read more button. The text continues here with more content that would normally be hidden.',
  trimLength: 50,
  trimMode: CoreTrimMode.length,
  moreStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  lessStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
)

// Read more with line-based truncation
CoreReadMoreText(
  'This is a long text that will be truncated after 3 lines and can be expanded. The text continues with more content that would be hidden initially.',
  trimLines: 3,
  trimMode: CoreTrimMode.line,
  colorClickableText: Colors.blue,
  delimiter: '... ',
  trimExpandedText: 'Show Less',
  trimCollapsedText: 'Read More',
)

// Read more with custom styling
CoreReadMoreText(
  'This text has custom styling and formatting options.',
  style: TextStyle(fontSize: 16, height: 1.5),
  moreStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  ),
  lessStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  ),
  delimiterStyle: TextStyle(color: Colors.grey),
)
```

### **UI Constants and Managers**

#### **SizesManager**

Centralized size constants for consistent UI scaling.

```dart
abstract final class SizesManager {
  static const double iconSize12 = 12;
  static const double iconSize14 = 14;
  static const double iconSize15 = 15;
  static const double iconSize16 = 16;
  static const double iconSize18 = 18;
  static const double iconSize20 = 20;
  static const double iconSize24 = 24;
  static const double iconSize26 = 26;
  static const double iconSize30 = 32;
  static const double iconSize32 = 32;
  static const double iconSize36 = 36;
  static const double imageSize80 = 80;
  static const double imageSize70 = 70;
  static const double imageSize132 = 132;
}
```

#### **Usage Example**

```dart
// Use consistent icon sizes
Icon(
  Icons.home,
  size: SizesManager.iconSize24,
)

// Use consistent image sizes
CoreImage.network(
  'https://example.com/avatar.jpg',
  width: SizesManager.imageSize80,
  height: SizesManager.imageSize80,
  borderRadius: BorderRadius.circular(SizesManager.imageSize80 / 2),
)
```

---

### **Pagination System**

#### **CorePaginationWidget**

Enterprise-level pagination widget with comprehensive state management, pull-to-refresh, and skeleton loading.

#### **Public API**

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
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.showRefreshIndicator = true,
    this.headerBuilder,
    this.footerBuilder,
    this.skeletonItemCount,
    this.emptyEntity,
    this.enableScrollToTop = true,
  });
}
```

#### **CorePaginationCubit**

State management for pagination with comprehensive data manipulation methods.

```dart
class CorePaginationCubit<T extends Identifiable, M extends MetaModel> extends Cubit<CorePaginationState<T, M>> {
  CorePaginationCubit({
    required UseCaseFutureResponse<PaginationResponseModel<T, M>> Function(int, int) paginationFunction,
    required PaginationStrategy paginationStrategy,
    this.reverse = false,
  });

  /// Fetch initial data
  Future<void> fetchInitialData();

  /// Fetch more data
  Future<void> fetchMoreData();

  /// Add item to end of list
  void addLast(T item);

  /// Add item to beginning of list
  void addFirst(T item);

  /// Update existing item
  void update(T item);

  /// Delete item by ID
  void delete(String id);

  /// Bulk operations
  void bulkAdd(List<T> items);
  void bulkUpdate(List<T> items);
  void bulkDelete(List<String> ids);

  /// Utility methods
  T? findById(String id);
  bool contains(T item);
  bool containsAll(List<T> items);
}
```

#### **Pagination Strategies**

```dart
abstract class PaginationStrategy {
  final int limit;
  int get nextBatch;
  void reset();
  void increment();
  void decrement();
  bool get isFirst;
}

// Page-based pagination (1, 2, 3...)
class PagePaginationStrategy extends PaginationStrategy {
  PagePaginationStrategy({super.limit = 20});
}

// Skip-based pagination (0, 20, 40...)
class SkipPaginationStrategy extends PaginationStrategy {
  SkipPaginationStrategy({super.limit = 20});
}
```

#### **Usage Example**

```dart
// Basic pagination with ListView
CorePaginationWidget<User, UserMeta>(
  paginationFunction: (batch, limit) async {
    return await userRepository.getUsers(page: batch, limit: limit);
  },
  paginationStrategy: PagePaginationStrategy(limit: 20),
  scrollableBuilder: (context, items, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: items.data.length,
      itemBuilder: (context, index) {
        final user = items.data[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
        );
      },
    );
  },
)

// Pagination with GridView
CorePaginationWidget<Product, ProductMeta>(
  paginationFunction: (batch, limit) async {
    return await productRepository.getProducts(skip: batch, limit: limit);
  },
  paginationStrategy: SkipPaginationStrategy(limit: 12),
  scrollableBuilder: (context, items, controller) {
    return GridView.builder(
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.data.length,
      itemBuilder: (context, index) {
        final product = items.data[index];
        return ProductCard(product: product);
      },
    );
  },
)

// Pagination with Slivers
CorePaginationWidget<Post, PostMeta>(
  paginationFunction: (batch, limit) async {
    return await postRepository.getPosts(page: batch, limit: limit);
  },
  paginationStrategy: PagePaginationStrategy(limit: 15),
  sliversBuilder: (context, items, controller) {
    return [
      SliverAppBar(
        title: Text('Posts'),
        floating: true,
        snap: true,
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final post = items.data[index];
            return PostCard(post: post);
          },
          childCount: items.data.length,
        ),
      ),
    ];
  },
)

// Custom loading and error states
CorePaginationWidget<Comment, CommentMeta>(
  paginationFunction: (batch, limit) async {
    return await commentRepository.getComments(postId: postId, page: batch, limit: limit);
  },
  paginationStrategy: PagePaginationStrategy(limit: 10),
  loadingBuilder: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading comments...'),
      ],
    ),
  ),
  errorBuilder: (context, failure, retry, existingItems) {
    return Column(
      children: [
        if (existingItems.data.isNotEmpty) 
          Expanded(child: existingItems),
        Center(
          child: Column(
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Failed to load comments'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: retry,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  },
  emptyBuilder: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.comment_outlined, size: 64),
        SizedBox(height: 16),
        Text('No comments yet'),
        SizedBox(height: 8),
        Text('Be the first to comment!'),
      ],
    ),
  ),
  scrollableBuilder: (context, items, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: items.data.length,
      itemBuilder: (context, index) {
        final comment = items.data[index];
        return CommentCard(comment: comment);
      },
    );
  },
)

// Chat-like reverse pagination
CorePaginationWidget<Message, MessageMeta>(
  paginationFunction: (batch, limit) async {
    return await messageRepository.getMessages(chatId: chatId, skip: batch, limit: limit);
  },
  paginationStrategy: SkipPaginationStrategy(limit: 20),
  reverse: true, // For chat timelines
  scrollableBuilder: (context, items, controller) {
    return ListView.builder(
      controller: controller,
      reverse: true,
      itemCount: items.data.length,
      itemBuilder: (context, index) {
        final message = items.data[index];
        return MessageBubble(message: message);
      },
    );
  },
)
```

---

**📝 Note**: This completes Step 5 of the comprehensive documentation. The UI components and theming system provides enterprise-grade widgets with comprehensive customization, form integration, consistent design patterns, and advanced pagination capabilities.

---

## 🧭 **Step 6: Navigation & Routing**

### **Core Navigator**

The `CoreNavigator` provides a comprehensive navigation system built on top of GoRouter with advanced features like parameter handling, error management, and navigation logging.

#### **Public API**

```dart
class CoreNavigator {
  CoreNavigator({
    required CoreLogger logger,
    required NavigationConfigEntity navigationConfigEntity,
    required this.shouldLog,
  });

  /// Get the GoRouter instance
  GoRouter get router;

  /// Get the navigation key
  GlobalKey<NavigatorState> get routeNavigationKey;

  /// Get application context
  static BuildContext get appContext;

  /// Refresh the router configuration
  GoRouter refreshRouter();

  /// Navigate using a named route, replacing the current route
  static void toNamed(
    String routeName, {
    BaseScreenParams? arguments,
    BuildContext? context,
  });

  /// Navigate using a path, replacing the current route
  static void toPath(
    String path, {
    BaseScreenParams? arguments,
    BuildContext? context,
  });

  /// Push a named route onto the navigation stack
  static void pushNamed(
    String routeName, {
    BaseScreenParams? arguments,
    BuildContext? context,
  });

  /// Push a route onto the navigation stack using its path
  static void pushPath(
    String path, {
    BaseScreenParams? arguments,
    BuildContext? context,
  });

  /// Get current location
  static String getCurrentLocation({BuildContext? context});

  /// Pop the current route
  static void pop<T extends Object?>(BuildContext? context, [T? result]);
}
```

#### **Usage Example**

```dart
// Initialize navigator
final navigator = CoreNavigator(
  logger: getIt<CoreLogger>(),
  navigationConfigEntity: navigationConfig,
  shouldLog: true,
);

// Navigate to named route
CoreNavigator.toNamed(
  'user_profile',
  arguments: UserProfileParams(userId: '123'),
);

// Navigate to path
CoreNavigator.toPath(
  '/users/:userId',
  arguments: UserProfileParams(
    pathParams: {'userId': '123'},
    queryParams: {'tab': 'settings'},
  ),
);

// Push route
CoreNavigator.pushNamed(
  'edit_profile',
  arguments: EditProfileParams(userId: '123'),
);

// Get current location
final currentLocation = CoreNavigator.getCurrentLocation();

// Pop route
CoreNavigator.pop(context, 'result_data');
```

### **Screen Parameters**

#### **BaseScreenParams**

Abstract base class for screen parameters with support for path parameters, query parameters, and extra data.

```dart
abstract class BaseScreenParams extends Equatable {
  const BaseScreenParams();

  /// Query parameters for the route
  Map<String, dynamic> get queryParams => {};

  /// Path parameters for the route
  Map<String, String> get pathParams => {};

  /// Extra data to pass to the route
  Map<String, Object> get extra => {};
}
```

#### **NoScreenParams**

Simple implementation for routes that don't require parameters.

```dart
class NoScreenParams extends BaseScreenParams {
  const NoScreenParams();
}
```

#### **Custom Screen Parameters**

```dart
class UserProfileParams extends BaseScreenParams {
  const UserProfileParams({
    required this.userId,
    this.tab,
    this.userData,
  });

  final String userId;
  final String? tab;
  final User? userData;

  @override
  Map<String, String> get pathParams => {'userId': userId};

  @override
  Map<String, dynamic> get queryParams => {
    if (tab != null) 'tab': tab!,
  };

  @override
  Map<String, Object> get extra => {
    if (userData != null) 'userData': userData!,
  };

  @override
  List<Object?> get props => [userId, tab, userData];
}

class ProductListParams extends BaseScreenParams {
  const ProductListParams({
    this.category,
    this.sortBy,
    this.page = 1,
    this.filters,
  });

  final String? category;
  final String? sortBy;
  final int page;
  final Map<String, dynamic>? filters;

  @override
  Map<String, dynamic> get queryParams => {
    if (category != null) 'category': category!,
    if (sortBy != null) 'sortBy': sortBy!,
    'page': page.toString(),
    if (filters != null) ...filters!,
  };

  @override
  List<Object?> get props => [category, sortBy, page, filters];
}
```

### **Navigation Configuration**

#### **NavigationConfigEntity**

Configuration entity for setting up the navigation system.

```dart
class NavigationConfigEntity extends Equatable {
  const NavigationConfigEntity({
    required this.routes,
    required this.initialRoute,
    this.errorBuilder,
    this.redirect,
    this.navigationObservers = const [],
    this.refreshListenable,
  });

  final List<RouteBase> routes;
  final String initialRoute;
  final Widget Function(BuildContext, GoRouterState)? errorBuilder;
  final Future<String?> Function(BuildContext, GoRouterState)? redirect;
  final Listenable? refreshListenable;
  final List<NavigatorObserver> navigationObservers;
}
```

#### **Route Configuration Example**

```dart
final navigationConfig = NavigationConfigEntity(
  initialRoute: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) {
        return FadePage(
          key: state.pageKey,
          child: HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/users/:userId',
      name: 'user_profile',
      pageBuilder: (context, state) {
        final userId = state.pathParameters['userId']!;
        final tab = state.uri.queryParameters['tab'];
        final userData = state.extra as User?;
        
        return SlideRightToLeftPage(
          key: state.pageKey,
          child: UserProfilePage(
            userId: userId,
            initialTab: tab,
            userData: userData,
          ),
        );
      },
    ),
    GoRoute(
      path: '/products',
      name: 'product_list',
      pageBuilder: (context, state) {
        final category = state.uri.queryParameters['category'];
        final sortBy = state.uri.queryParameters['sortBy'];
        final page = int.tryParse(state.uri.queryParameters['page'] ?? '1') ?? 1;
        
        return ScaleUpPage(
          key: state.pageKey,
          child: ProductListPage(
            category: category,
            sortBy: sortBy,
            page: page,
          ),
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) {
        return BouncePage(
          key: state.pageKey,
          child: SettingsPage(),
        );
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Page not found: ${state.location}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => CoreNavigator.toNamed('home'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
  redirect: (context, state) async {
    // Authentication redirect logic
    final isAuthenticated = await authService.isAuthenticated();
    if (!isAuthenticated && state.location != '/login') {
      return '/login';
    }
    if (isAuthenticated && state.location == '/login') {
      return '/home';
    }
    return null;
  },
  refreshListenable: authStateNotifier,
);
```

### **Animated Route Transitions**

The navigation system provides a comprehensive set of animated page transitions.

#### **Available Transitions**

```dart
// Fade transition
class FadePage extends AnimatedPage

// Slide transitions
class SlideRightToLeftPage extends AnimatedPage
class SlideLeftToRightPage extends AnimatedPage
class SlideBottomToTopPage extends AnimatedPage
class SlideTopToBottomPage extends AnimatedPage

// Scale transitions
class ScaleUpPage extends AnimatedPage
class ScaleDownPage extends AnimatedPage

// Zoom transitions
class ZoomInPage extends AnimatedPage
class ZoomOutPage extends AnimatedPage

// Flip transitions
class FlipHorizontalPage extends AnimatedPage
class FlipVerticalPage extends AnimatedPage

// Rotation transition
class RotatePage extends AnimatedPage

// Bounce transition
class BouncePage extends AnimatedPage

// Elastic transition
class ElasticPage extends AnimatedPage

// Crossfade transition
class CrossfadePage extends AnimatedPage
```

#### **Usage Example**

```dart
GoRoute(
  path: '/profile',
  name: 'profile',
  pageBuilder: (context, state) {
    return SlideRightToLeftPage(
      key: state.pageKey,
      child: ProfilePage(),
      transitionDuration: Duration(milliseconds: 300),
    );
  },
),

GoRoute(
  path: '/modal',
  name: 'modal',
  pageBuilder: (context, state) {
    return SlideBottomToTopPage(
      key: state.pageKey,
      child: ModalPage(),
      transitionDuration: Duration(milliseconds: 250),
    );
  },
),

GoRoute(
  path: '/settings',
  name: 'settings',
  pageBuilder: (context, state) {
    return BouncePage(
      key: state.pageKey,
      child: SettingsPage(),
      transitionDuration: Duration(milliseconds: 500),
    );
  },
),
```

### **Navigation Observers**

#### **CoreNavigationObserver**

Built-in navigation observer for logging and tracking navigation events.

```dart
class CoreNavigationObserver extends NavigatorObserver {
  CoreNavigationObserver(this._logger);
  final CoreLogger _logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logAndTrack('PUSH', route, previousRoute);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logAndTrack('POP', route, previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logAndTrack('REPLACE', newRoute, oldRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logAndTrack('REMOVE', route, previousRoute);
    super.didRemove(route, previousRoute);
  }
}
```

#### **Custom Navigation Observer**

```dart
class AnalyticsNavigationObserver extends NavigatorObserver {
  final AnalyticsService _analytics;

  AnalyticsNavigationObserver(this._analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _analytics.trackScreenView(route.settings.name ?? 'Unknown');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _analytics.trackScreenExit(route.settings.name ?? 'Unknown');
    super.didPop(route, previousRoute);
  }
}

// Add to navigation config
final navigationConfig = NavigationConfigEntity(
  // ... other config
  navigationObservers: [
    AnalyticsNavigationObserver(getIt<AnalyticsService>()),
  ],
);
```

### **Complete Navigation Setup**

#### **App Integration**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (context, themeConfig) {
        return MaterialApp.router(
          title: 'My App',
          theme: themeConfig.lightTheme,
          darkTheme: themeConfig.darkTheme,
          themeMode: themeConfig.themeMode,
          routerConfig: getIt<CoreNavigator>().router,
        );
      },
    );
  }
}
```

#### **Dependency Injection Setup**

```dart
// Register navigation dependencies
getIt.registerLazySingleton<NavigationConfigEntity>(
  () => NavigationConfigEntity(
    initialRoute: '/home',
    routes: _buildRoutes(),
    errorBuilder: _buildErrorPage,
    redirect: _handleRedirect,
    refreshListenable: getIt<AuthStateNotifier>(),
    navigationObservers: [
      AnalyticsNavigationObserver(getIt<AnalyticsService>()),
    ],
  ),
);

getIt.registerLazySingleton<CoreNavigator>(
  () => CoreNavigator(
    logger: getIt<CoreLogger>(),
    navigationConfigEntity: getIt<NavigationConfigEntity>(),
    shouldLog: kDebugMode,
  ),
);
```

#### **Route Usage in Widgets**

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              CoreNavigator.toNamed(
                'user_profile',
                arguments: UserProfileParams(
                  userId: '123',
                  tab: 'posts',
                ),
              );
            },
            child: Text('View Profile'),
          ),
          ElevatedButton(
            onPressed: () {
              CoreNavigator.pushNamed(
                'product_list',
                arguments: ProductListParams(
                  category: 'electronics',
                  sortBy: 'price',
                  page: 1,
                ),
              );
            },
            child: Text('Browse Products'),
          ),
          ElevatedButton(
            onPressed: () {
              CoreNavigator.toPath(
                '/settings',
                arguments: NoScreenParams(),
              );
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final String userId;
  final String? initialTab;
  final User? userData;

  const UserProfilePage({
    Key? key,
    required this.userId,
    this.initialTab,
    this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              CoreNavigator.pushNamed(
                'edit_profile',
                arguments: EditProfileParams(userId: userId),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('User ID: $userId'),
          if (initialTab != null) Text('Tab: $initialTab'),
          if (userData != null) Text('User: ${userData!.name}'),
          ElevatedButton(
            onPressed: () => CoreNavigator.pop(context, 'profile_updated'),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
```

---

**📝 Note**: This completes Step 6 of the comprehensive documentation. The navigation and routing system provides enterprise-grade navigation with comprehensive parameter handling, animated transitions, and advanced features.

---

## 📱 **Step 7: Platform Support & Utilities**

### **Platform Detection & Device Information**

The platform support system provides comprehensive device information, platform detection, and cross-platform utilities for building applications that work seamlessly across all Flutter-supported platforms.

#### **PlatformType Enum**

Comprehensive platform detection with support for all Flutter platforms.

```dart
enum PlatformType {
  android,
  ios,
  web,
  windows,
  macos,
  linux,
  unknown;
  
  /// Get platform from dart:io Platform
  static PlatformType fromDartPlatform();
  
  /// Get platform from string
  static PlatformType fromString(String value);
  
  /// Get string value
  String get value;
}
```

#### **DeviceInfoEntity**

Comprehensive device information entity with platform-specific details.

```dart
@freezed
abstract class DeviceInfoEntity with _$DeviceInfoEntity {
  const factory DeviceInfoEntity({
    /// Device ID (unique identifier)
    required String deviceId,
    
    /// Device build number
    required String buildNumber,
    
    /// Device version number
    required String versionNumber,
    
    /// Current platform
    required PlatformType platform,
  }) = _DeviceInfoEntity;
  
  factory DeviceInfoEntity.fromJson(Map<String, dynamic> json);
}
```

#### **PlatformServiceInterface**

Service interface for accessing platform and device information.

```dart
abstract class PlatformServiceInterface {
  /// Get comprehensive device information
  DeviceInfoEntity getDeviceInfo();
}
```

#### **Usage Example**

```dart
// Access platform service
final platformService = getIt<PlatformServiceInterface>();

// Get device information
final deviceInfo = platformService.getDeviceInfo();

// Platform detection
final currentPlatform = PlatformType.fromDartPlatform();

// Platform-specific logic
switch (currentPlatform) {
  case PlatformType.android:
    // Android-specific code
    break;
  case PlatformType.ios:
    // iOS-specific code
    break;
  case PlatformType.web:
    // Web-specific code
    break;
  case PlatformType.windows:
    // Windows-specific code
    break;
  case PlatformType.macos:
    // macOS-specific code
    break;
  case PlatformType.linux:
    // Linux-specific code
    break;
  case PlatformType.unknown:
    // Fallback code
    break;
}

// Use device information
print('Device ID: ${deviceInfo.deviceId}');
print('Platform: ${deviceInfo.platform.value}');
print('Version: ${deviceInfo.versionNumber}');
print('Build: ${deviceInfo.buildNumber}');
```

### **Platform Cubit**

State management for platform information with reactive updates.

```dart
class PlatformCubit extends Cubit<DeviceInfoEntity> {
  PlatformCubit({required PlatformServiceInterface platformService});
  
  /// Refresh device information
  void refreshDeviceInfo();
  
  /// Get current platform type
  PlatformType get currentPlatform;
  
  /// Check if running on mobile platform
  bool get isMobile;
  
  /// Check if running on desktop platform
  bool get isDesktop;
  
  /// Check if running on web platform
  bool get isWeb;
}
```

#### **Usage Example**

```dart
// Access platform cubit
final platformCubit = getIt<PlatformCubit>();

// Listen to platform changes
BlocBuilder<PlatformCubit, DeviceInfoEntity>(
  builder: (context, deviceInfo) {
    return Column(
      children: [
        Text('Platform: ${deviceInfo.platform.value}'),
        Text('Version: ${deviceInfo.versionNumber}'),
        Text('Build: ${deviceInfo.buildNumber}'),
        if (platformCubit.isMobile)
          Text('Mobile Platform'),
        if (platformCubit.isDesktop)
          Text('Desktop Platform'),
        if (platformCubit.isWeb)
          Text('Web Platform'),
      ],
    );
  },
)

// Refresh device information
platformCubit.refreshDeviceInfo();
```

### **Cross-Platform Utilities**

#### **Platform-Specific UI Adaptations**

```dart
class PlatformAdaptiveWidget extends StatelessWidget {
  const PlatformAdaptiveWidget({
    super.key,
    required this.mobile,
    required this.desktop,
    this.web,
  });
  
  final Widget mobile;
  final Widget desktop;
  final Widget? web;
  
  @override
  Widget build(BuildContext context) {
    final platformCubit = getIt<PlatformCubit>();
    
    return BlocBuilder<PlatformCubit, DeviceInfoEntity>(
      builder: (context, deviceInfo) {
        switch (deviceInfo.platform) {
          case PlatformType.android:
          case PlatformType.ios:
            return mobile;
          case PlatformType.windows:
          case PlatformType.macos:
          case PlatformType.linux:
            return desktop;
          case PlatformType.web:
            return web ?? mobile;
          case PlatformType.unknown:
            return mobile; // Default fallback
        }
      },
    );
  }
}
```

#### **Platform-Specific Navigation**

```dart
class PlatformNavigation {
  static void navigateToSettings(BuildContext context) {
    final platformCubit = getIt<PlatformCubit>();
    
    switch (platformCubit.currentPlatform) {
      case PlatformType.android:
      case PlatformType.ios:
        // Use bottom sheet for mobile
        showModalBottomSheet(
          context: context,
          builder: (context) => SettingsBottomSheet(),
        );
        break;
      case PlatformType.web:
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        // Use dialog for desktop
        showDialog(
          context: context,
          builder: (context) => SettingsDialog(),
        );
        break;
      case PlatformType.unknown:
        // Default navigation
        CoreNavigator.pushNamed('settings');
        break;
    }
  }
}
```

### **Platform-Specific Styling**

#### **Adaptive Theme Configuration**

```dart
class PlatformThemeConfig {
  static ThemeData getAdaptiveTheme(PlatformType platform) {
    switch (platform) {
      case PlatformType.android:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        );
      case PlatformType.ios:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: false,
        );
      case PlatformType.web:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        );
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        );
      case PlatformType.unknown:
        return ThemeData.light();
    }
  }
}
```

### **Platform-Specific Features**

#### **File System Access**

```dart
class PlatformFileManager {
  static Future<String> getAppDocumentsPath() async {
    final platformCubit = getIt<PlatformCubit>();
    
    switch (platformCubit.currentPlatform) {
      case PlatformType.android:
      case PlatformType.ios:
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        final directory = await getApplicationSupportDirectory();
        return directory.path;
      case PlatformType.web:
        // Web doesn't have traditional file system
        return '/web_storage';
      case PlatformType.unknown:
        return '/unknown_platform';
    }
  }
  
  static Future<bool> isFileSystemAccessible() async {
    final platformCubit = getIt<PlatformCubit>();
    
    switch (platformCubit.currentPlatform) {
      case PlatformType.web:
        return false; // Limited file system access
      case PlatformType.android:
      case PlatformType.ios:
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        return true;
      case PlatformType.unknown:
        return false;
    }
  }
}
```

### **Platform-Specific Permissions**

```dart
class PlatformPermissions {
  static Future<bool> requestCameraPermission() async {
    final platformCubit = getIt<PlatformCubit>();
    
    switch (platformCubit.currentPlatform) {
      case PlatformType.android:
      case PlatformType.ios:
        // Use permission_handler for mobile
        return await Permission.camera.request().isGranted;
      case PlatformType.web:
        // Web camera access
        return await _requestWebCameraPermission();
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        // Desktop platforms typically don't need explicit permissions
        return true;
      case PlatformType.unknown:
        return false;
    }
  }
  
  static Future<bool> _requestWebCameraPermission() async {
    try {
      final stream = await navigator.mediaDevices.getUserMedia({
        'video': true,
      });
      stream.getTracks().forEach((track) => track.stop());
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

### **Platform-Specific Performance Optimizations**

```dart
class PlatformPerformance {
  static int getOptimalImageCacheSize() {
    final platformCubit = getIt<PlatformCubit>();
    
    switch (platformCubit.currentPlatform) {
      case PlatformType.web:
        return 50; // Smaller cache for web
      case PlatformType.android:
      case PlatformType.ios:
        return 100; // Standard mobile cache
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        return 200; // Larger cache for desktop
      case PlatformType.unknown:
        return 50;
    }
  }
  
  static Duration getAnimationDuration() {
    final platformCubit = getIt<PlatformCubit>();
    
    switch (platformCubit.currentPlatform) {
      case PlatformType.web:
        return Duration(milliseconds: 200); // Faster for web
      case PlatformType.android:
      case PlatformType.ios:
        return Duration(milliseconds: 300); // Standard mobile
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        return Duration(milliseconds: 250); // Slightly faster for desktop
      case PlatformType.unknown:
        return Duration(milliseconds: 300);
    }
  }
}
```

### **Complete Platform Integration Example**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlatformCubit, DeviceInfoEntity>(
      builder: (context, deviceInfo) {
        return MaterialApp(
          title: 'My App',
          theme: PlatformThemeConfig.getAdaptiveTheme(deviceInfo.platform),
          home: PlatformAdaptiveWidget(
            mobile: MobileHomePage(),
            desktop: DesktopHomePage(),
            web: WebHomePage(),
          ),
          builder: (context, child) {
            return PlatformAdaptiveScaffold(
              platform: deviceInfo.platform,
              child: child!,
            );
          },
        );
      },
    );
  }
}

class PlatformAdaptiveScaffold extends StatelessWidget {
  final PlatformType platform;
  final Widget child;
  
  const PlatformAdaptiveScaffold({
    super.key,
    required this.platform,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    switch (platform) {
      case PlatformType.android:
      case PlatformType.ios:
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      case PlatformType.web:
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                destinations: [
                  NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        );
      case PlatformType.unknown:
        return Scaffold(body: child);
    }
  }
}
```

---

**📝 Note**: This completes Step 7 of the comprehensive documentation. The platform support system provides enterprise-grade cross-platform utilities with comprehensive device information, platform detection, and adaptive UI components.

---

## 🔄 **Step 8: State Management & Use Cases**

### **State Management Architecture**

Coore provides a comprehensive state management system built on the BLoC pattern with functional programming principles, offering robust API state handling, use case architecture, and reactive state updates.

#### **Core Type Definitions**

The foundation of the state management system with functional programming patterns.

```dart
// Core type definitions for state management
typedef ApiHandlerResponse = Future<Either<NetworkFailure, Map<String, dynamic>>>;
typedef RemoteResponse<T> = Future<Either<NetworkFailure, T>>;
typedef CacheResponse<T> = Future<Either<CacheFailure, T>>;
typedef UseCaseFutureResponse<T> = Future<Either<Failure, T>>;
typedef UseCaseStreamResponse<T> = Stream<Either<Failure, T>>;
typedef ProgressTrackerCallback = void Function(double progress);
typedef Id = String;
```

### **API State Management**

#### **ApiState Class**

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

#### **Usage Example**

```dart
// API state handling
final apiState = ApiState.loading();

// Check state
if (apiState.isLoading) {
  print('Loading...');
}

// Extract data safely
apiState.data.fold(
  () => print('No data available'),
  (data) => print('Data: $data'),
);

// Handle failure with retry
if (apiState.isFailed) {
  apiState.failureObject.fold(
    () => print('Unknown error'),
    (failure) {
      print('Error: ${failure.message}');
      // Retry if available
      final retryFunction = apiState.failureObject.fold(
        () => null,
        (failure) => failure.retryFunction,
      );
      retryFunction?.call();
    },
  );
}
```

### **ApiStateMixin**

Powerful mixin for BLoCs and Cubits that provides comprehensive API call lifecycle management.

#### **Public API**

```dart
mixin ApiStateMixin<CompositeState, SuccessData> on BlocBase<CompositeState> {
  /// Adapter instance used to cancel an ongoing API request
  CancelRequestAdapter? cancelRequestAdapter;
  
  /// Cancels an ongoing API request, if one exists
  void cancelRequest();
  
  /// Retrieves the current API state from the composite state
  ApiState<SuccessData> getApiState(CompositeState state);
  
  /// Updates the composite state with a new API state
  CompositeState setApiState(
    CompositeState state,
    ApiState<SuccessData> apiState,
  );
  
  /// Executes an API call and manages its state lifecycle
  Future<void> handleApiCall<T extends Cancelable>({
    required UseCaseFutureResponse<SuccessData> Function(T params) apiCall,
    required T params,
    void Function(SuccessData data)? onSuccess,
    void Function(Failure failure)? onFailure,
  });
}
```

#### **Usage Example**

```dart
// User state with API state
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(ApiState.initial()) ApiState<List<User>> usersState,
    @Default(ApiState.initial()) ApiState<User?> currentUserState,
    @Default('') String searchQuery,
  }) = _UserState;
}

// User Cubit with API state management
class UserCubit extends CoreCubit<UserState, List<User>> {
  final UserRepository _userRepository;
  
  UserCubit(this._userRepository) : super(const UserState());
  
  @override
  ApiState<List<User>> getApiState(UserState state) => state.usersState;
  
  @override
  UserState setApiState(UserState state, ApiState<List<User>> apiState) {
    return state.copyWith(usersState: apiState);
  }
  
  // Load users with automatic state management
  Future<void> loadUsers() async {
    await handleApiCall(
      apiCall: _userRepository.getUsers,
      params: NoParams(),
      onSuccess: (users) {
        print('Loaded ${users.length} users');
      },
      onFailure: (failure) {
        print('Failed to load users: ${failure.message}');
      },
    );
  }
  
  // Search users with pagination
  Future<void> searchUsers(String query) async {
    await handleApiCall(
      apiCall: _userRepository.searchUsers,
      params: SearchParams(
        query: query,
        limit: 20,
      ),
      onSuccess: (users) {
        emit(state.copyWith(searchQuery: query));
      },
    );
  }
  
  // Load more users with pagination
  Future<void> loadMoreUsers() async {
    final currentUsers = state.usersState.data.getOrElse(() => []);
    final nextPage = (currentUsers.length / 20).ceil() + 1;
    
    await handleApiCall(
      apiCall: _userRepository.getUsers,
      params: PagePaginationParams(
        page: nextPage,
        limit: 20,
      ),
      onSuccess: (newUsers) {
        final allUsers = [...currentUsers, ...newUsers];
        emit(state.copyWith(
          usersState: ApiState.succeeded(allUsers),
        ));
      },
    );
  }
}
```

### **Core BLoC and Cubit Classes**

#### **CoreBloc**

Abstract base class for BLoCs with API state management capabilities.

```dart
abstract class CoreBloc<EventType, CompositeState, SuccessData>
    extends Bloc<EventType, CompositeState>
    with ApiStateMixin<CompositeState, SuccessData> {
  CoreBloc(super.initialState);
  
  @override
  Future<void> close() {
    cancelRequest();
    return super.close();
  }
}
```

#### **CoreCubit**

Abstract base class for Cubits with API state management capabilities.

```dart
abstract class CoreCubit<CompositeState, SuccessData>
    extends Cubit<CompositeState>
    with ApiStateMixin<CompositeState, SuccessData> {
  CoreCubit(super.initialState);
  
  @override
  Future<void> close() {
    cancelRequest();
    return super.close();
  }
}
```

#### **Usage Example**

```dart
// User BLoC with events
abstract class UserEvent extends Equatable {
  const UserEvent();
}

class LoadUsersEvent extends UserEvent {
  const LoadUsersEvent();
  
  @override
  List<Object?> get props => [];
}

class SearchUsersEvent extends UserEvent {
  const SearchUsersEvent(this.query);
  
  final String query;
  
  @override
  List<Object?> get props => [query];
}

class LoadMoreUsersEvent extends UserEvent {
  const LoadMoreUsersEvent();
  
  @override
  List<Object?> get props => [];
}

// User BLoC implementation
class UserBloc extends CoreBloc<UserEvent, UserState, List<User>> {
  final UserRepository _userRepository;
  
  UserBloc(this._userRepository) : super(const UserState()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<SearchUsersEvent>(_onSearchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
  }
  
  @override
  ApiState<List<User>> getApiState(UserState state) => state.usersState;
  
  @override
  UserState setApiState(UserState state, ApiState<List<User>> apiState) {
    return state.copyWith(usersState: apiState);
  }
  
  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    await handleApiCall(
      apiCall: _userRepository.getUsers,
      params: NoParams(),
    );
  }
  
  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    await handleApiCall(
      apiCall: _userRepository.searchUsers,
      params: SearchParams(
        query: event.query,
        limit: 20,
      ),
      onSuccess: (users) {
        emit(state.copyWith(searchQuery: event.query));
      },
    );
  }
  
  Future<void> _onLoadMoreUsers(
    LoadMoreUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentUsers = state.usersState.data.getOrElse(() => []);
    final nextPage = (currentUsers.length / 20).ceil() + 1;
    
    await handleApiCall(
      apiCall: _userRepository.getUsers,
      params: PagePaginationParams(
        page: nextPage,
        limit: 20,
      ),
      onSuccess: (newUsers) {
        final allUsers = [...currentUsers, ...newUsers];
        emit(state.copyWith(
          usersState: ApiState.succeeded(allUsers),
        ));
      },
    );
  }
}
```

### **ApiStateBuilder Widget**

Comprehensive widget for handling API states with customizable loading, error, and success states.

#### **Public API**

```dart
class ApiStateBuilder<CompositeState, SuccessData> extends StatelessWidget {
  const ApiStateBuilder({
    super.key,
    required this.cubit,
    this.initialBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    required this.successBuilder,
    required this.emptyEntity,
  });
  
  final CoreCubit<CompositeState, SuccessData> cubit;
  final Widget Function(BuildContext context)? initialBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
  )? errorBuilder;
  final Widget Function(BuildContext context, CompositeState data) successBuilder;
  final SuccessData emptyEntity;
}
```

#### **Usage Example**

```dart
// User list with API state handling
class UserListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ApiStateBuilder<UserState, List<User>>(
      cubit: getIt<UserCubit>(),
      emptyEntity: const <User>[],
      initialBuilder: (context) => Center(
        child: Text('No users loaded yet'),
      ),
      loadingBuilder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading users...'),
          ],
        ),
      ),
      errorBuilder: (context, failure, retry) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Failed to load users'),
            SizedBox(height: 8),
            Text(failure.message),
            SizedBox(height: 16),
            if (retry != null)
              ElevatedButton(
                onPressed: retry,
                child: Text('Retry'),
              ),
          ],
        ),
      ),
      successBuilder: (context, state) {
        final users = state.usersState.data.getOrElse(() => []);
        
        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64),
                SizedBox(height: 16),
                Text('No users found'),
                if (state.searchQuery.isNotEmpty)
                  Text('Try a different search term'),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              onTap: () {
                // Navigate to user details
                CoreNavigator.pushNamed(
                  'user_details',
                  arguments: UserDetailsParams(userId: user.id),
                );
              },
            );
          },
        );
      },
    );
  }
}
```

### **Use Case Architecture**

#### **Base UseCase**

Foundation for all use cases with clean architecture principles.

```dart
abstract class UseCase {
  const UseCase();
}
```

#### **FutureEitherUseCase**

Use case for operations that return a Future with Either result.

```dart
abstract class FutureEitherUseCase<Output, Input> extends UseCase {
  const FutureEitherUseCase();
  
  UseCaseFutureResponse<Output> call(Input input);
}
```

#### **StreamEitherUseCase**

Use case for operations that return a Stream with Either result.

```dart
abstract class StreamEitherUseCase<Output, Input> extends UseCase {
  const StreamEitherUseCase();
  
  UseCaseStreamResponse<Output> call(Input input);
}
```

#### **UnawaitedUseCase**

Use case for synchronous operations that don't return a Future.

```dart
abstract class UnawaitedUseCase<Output, Input> extends UseCase {
  const UnawaitedUseCase();
  
  Output call(Input input);
}
```

#### **Usage Example**

```dart
// Get users use case
class GetUsersUseCase extends FutureEitherUseCase<List<User>, PaginationParams> {
  final UserRepository _userRepository;
  
  const GetUsersUseCase(this._userRepository);
  
  @override
  UseCaseFutureResponse<List<User>> call(PaginationParams params) async {
    return await _userRepository.getUsers(params);
  }
}

// Search users use case
class SearchUsersUseCase extends FutureEitherUseCase<List<User>, SearchParams> {
  final UserRepository _userRepository;
  
  const SearchUsersUseCase(this._userRepository);
  
  @override
  UseCaseFutureResponse<List<User>> call(SearchParams params) async {
    return await _userRepository.searchUsers(params);
  }
}

// Stream users use case (for real-time updates)
class StreamUsersUseCase extends StreamEitherUseCase<List<User>, NoParams> {
  final UserRepository _userRepository;
  
  const StreamUsersUseCase(this._userRepository);
  
  @override
  UseCaseStreamResponse<List<User>> call(NoParams params) {
    return _userRepository.streamUsers();
  }
}

// Validate user use case (synchronous)
class ValidateUserUseCase extends UnawaitedUseCase<bool, User> {
  const ValidateUserUseCase();
  
  @override
  bool call(User user) {
    return user.email.isNotEmpty && 
           user.name.isNotEmpty && 
           user.email.contains('@');
  }
}
```

### **Parameter Classes**

#### **Cancelable Interface**

Base interface for all parameters that support request cancellation.

```dart
abstract interface class Cancelable {
  CancelRequestAdapter? get cancelRequestAdapter;
  
  /// Return a copy of `this` with a different [cancelTokenAdapter]
  Cancelable copyWithCancelRequest(CancelRequestAdapter cancelTokenAdapter);
}
```

#### **Pagination Parameters**

Comprehensive pagination support with different strategies.

```dart
// Base pagination interface
abstract class PaginationParams implements Cancelable {
  int get batch;
  int get limit;
}

// Skip-based pagination (0, 20, 40...)
@freezed
abstract class SkipPagingStrategyParams
    with _$SkipPagingStrategyParams
    implements PaginationParams, Cancelable {
  const factory SkipPagingStrategyParams({
    required int take,
    required int skip,
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _SkipPagingStrategyParams;
  
  @override
  int get batch => skip;
  
  @override
  int get limit => take;
}

// Page-based pagination (1, 2, 3...)
@freezed
abstract class PagePaginationParams
    with _$PagePaginationParams
    implements PaginationParams, Cancelable {
  const factory PagePaginationParams({
    required int page,
    required int limit,
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _PagePaginationParams;
  
  @override
  int get batch => page;
}
```

#### **Other Parameter Types**

```dart
// No parameters
@freezed
class NoParams with _$NoParams implements Cancelable {
  const factory NoParams({
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _NoParams;
}

// ID parameter
@freezed
class IdParam with _$IdParam implements Cancelable {
  const factory IdParam({
    required String id,
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _IdParam;
}

// Search parameters
@freezed
class SearchParams with _$SearchParams implements Cancelable {
  const factory SearchParams({
    required String query,
    int limit = 20,
    int offset = 0,
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _SearchParams;
}
```

### **Complete State Management Example**

#### **Repository Implementation**

```dart
class UserRepository {
  final ApiHandlerInterface _apiHandler;
  
  UserRepository(this._apiHandler);
  
  Future<Either<NetworkFailure, List<User>>> getUsers(
    PaginationParams params,
  ) async {
    final result = await _apiHandler.get(
      '/users',
      queryParameters: {
        'page': params.batch,
        'limit': params.limit,
      },
      cancelRequestAdapter: params.cancelRequestAdapter,
      isAuthorized: true,
    );
    
    return result.fold(
      (failure) => left(failure),
      (data) {
        final users = (data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();
        return right(users);
      },
    );
  }
  
  Future<Either<NetworkFailure, List<User>>> searchUsers(
    SearchParams params,
  ) async {
    final result = await _apiHandler.get(
      '/users/search',
      queryParameters: {
        'q': params.query,
        'limit': params.limit,
        'offset': params.offset,
      },
      cancelRequestAdapter: params.cancelRequestAdapter,
      isAuthorized: true,
    );
    
    return result.fold(
      (failure) => left(failure),
      (data) {
        final users = (data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();
        return right(users);
      },
    );
  }
  
  Stream<Either<NetworkFailure, List<User>>> streamUsers() {
    return Stream.periodic(Duration(seconds: 30))
        .asyncMap((_) async => await getUsers(NoParams()));
  }
}
```

#### **Complete App Integration**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) => getIt<UserCubit>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => getIt<UserBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'My App',
        home: UserListPage(),
      ),
    );
  }
}

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<UserCubit>().loadUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (query) {
                context.read<UserCubit>().searchUsers(query);
              },
            ),
          ),
          // User list
          Expanded(
            child: UserListWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserCubit>().loadMoreUsers();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

**📝 Note**: This completes Step 8 of the comprehensive documentation. The state management system provides enterprise-grade BLoC/Cubit patterns with comprehensive API state handling, use case architecture, and reactive state updates.

---

## 🚀 **Step 9: Advanced Features & Best Practices**

### **Extension Methods**

Coore provides a comprehensive set of extension methods that enhance Dart's built-in types with powerful utilities for common operations, making your code more expressive and maintainable.

#### **String Extensions**

Powerful string manipulation and validation utilities.

```dart
extension StringExtensions on String {
  /// Tries to parse the string into a [DateTime] by testing multiple date formats
  DateTime parseDate();
  
  /// Returns `true` if all characters are equal
  bool get isOneAKind;
  
  /// Validates passport format (6-9 alphanumeric characters)
  bool get isPassport;
  
  /// Checks if string is numeric
  bool get isNum;
  
  /// Checks if string contains only numeric characters
  bool get isNumericOnly;
  
  /// Checks if string contains only alphabetic characters
  bool get isAlphabetOnly;
  
  /// Checks if string has at least one capital letter
  bool get hasCapitalLetter;
  
  /// Checks if string represents a boolean value
  bool get isBool;
}
```

#### **Usage Example**

```dart
// Date parsing
final dateString = '2023-08-29';
final date = dateString.parseDate();
print(date); // Output: 2023-08-29 00:00:00.000

// String validation
final passport = 'A1234567';
print(passport.isPassport); // Output: true

final email = 'user@example.com';
print(email.hasCapitalLetter); // Output: false

final numericString = '12345';
print(numericString.isNumericOnly); // Output: true

// Boolean parsing
final boolString = 'true';
print(boolString.isBool); // Output: true
```

#### **DateTime Extensions**

Comprehensive date and time manipulation utilities.

```dart
extension DateTimeX on DateTime {
  // Formatting methods
  String formatMonthYear(); // 'August 2023'
  String formatDay(); // '29'
  String formatMonthDay(); // 'Aug 29'
  String formatFullDate(); // 'Tue Aug 29, 2023'
  String formatApiDate(); // Smart API format
  String formatShortApiDate(); // '23.08.29'
  String formatRelative(); // '2 hours ago'
  
  // Date calculations
  DateTime get firstDayOfMonth;
  DateTime get lastDayOfMonth;
  DateTime get firstDayOfWeek;
  DateTime get lastDayOfWeek;
  DateTime get nextDay;
  DateTime get previousWeek;
  DateTime get nextWeek;
  DateTime get previousMonth;
  DateTime get nextMonth;
  
  // Business day calculations
  DateTime get nextBusinessDay;
  DateTime get previousBusinessDay;
  DateTime addBusinessDays(int businessDays);
  
  // Time period checks
  bool get isFirstDayOfMonth;
  bool get isLastDayOfMonth;
  bool get isToday;
  bool get isYesterday;
  bool get isTomorrow;
  bool get isWeekend;
  bool get isWeekday;
  bool get isLeapYear;
  
  // Advanced calculations
  int get weekOfYear;
  int get quarter;
  int get dayOfYear;
  int get weekNumber;
  DateTime get firstDayOfQuarter;
  DateTime get lastDayOfQuarter;
  
  // Utility methods
  DateTime addMonths(int months);
  DateTime addYears(int years);
  DateTime get startOfDay;
  DateTime get endOfDay;
  Iterable<DateTime> daysUntil(DateTime end);
  List<DateTime> get daysInWeek;
  bool isSameWeek(DateTime other);
  bool isExtraDay(DateTime currentMonth);
}
```

#### **Usage Example**

```dart
final now = DateTime.now();

// Formatting
print(now.formatMonthYear()); // 'December 2023'
print(now.formatRelative()); // 'just now' or '2 hours ago'

// Date calculations
final firstDay = now.firstDayOfMonth;
final lastDay = now.lastDayOfMonth;
print('Month range: $firstDay to $lastDay');

// Business days
final nextBusinessDay = now.nextBusinessDay;
final inFiveBusinessDays = now.addBusinessDays(5);
print('Next business day: $nextBusinessDay');

// Time period checks
if (now.isToday) {
  print('Today!');
}

if (now.isWeekend) {
  print('Weekend!');
}

// Week calculations
print('Week of year: ${now.weekOfYear}');
print('Quarter: ${now.quarter}');

// Generate date ranges
final startDate = DateTime(2023, 8, 1);
final endDate = DateTime(2023, 8, 7);
for (final day in startDate.daysUntil(endDate)) {
  print(day.formatMonthDay());
}
```

#### **File Extensions**

Comprehensive file manipulation and information utilities.

```dart
extension FileExtension on File {
  // File information
  String get fileName;
  String get fileNameWithoutExtension;
  String get fileExtension;
  String get parentPath;
  Directory get parentDirectory;
  int get sizeSync;
  Future<int> get size;
  Future<String> get humanReadableSize;
  
  // File type checks
  bool get isImage;
  bool get isVideo;
  bool get isText;
  bool get isDocument;
  
  // File operations
  Future<File> copyTo(Directory destination, {String? newName});
  Future<void> ensureParentExists();
  String? get contentType;
  String relativePath(String from);
}
```

#### **Context Extensions**

Flutter context utilities for responsive design and theming.

```dart
extension ContextExtensions on BuildContext {
  // Media query shortcuts
  MediaQueryData get mediaQuery;
  Size get size;
  double get width;
  double get height;
  double get pixelRatio;
  Brightness get platformBrightness;
  EdgeInsets get screenPadding;
  double get statusBarHeight;
  double get navigationBarHeight;
  Orientation get orientation;
  bool get isLandscape;
  bool get isPortrait;
  
  // Theme shortcuts
  ThemeData get theme;
  ColorScheme get colorScheme;
  TextTheme get textTheme;
  DefaultTextStyle get defaultTextStyle;
  Color get primaryColor;
  Color get scaffoldBackgroundColor;
  bool get isDarkMode;
  
  // Navigation shortcuts
  ScaffoldState get scaffoldState;
  ScaffoldMessengerState get scaffoldMessenger;
  OverlayState? get overlayState;
  
  // Utility methods
  void requestFocus(FocusNode focus);
  void hideKeyboard();
  void openDrawer();
  void openEndDrawer();
}
```

#### **Usage Example**

```dart
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Responsive design
        if (context.isLandscape)
          Row(
            children: [
              Expanded(child: _buildContent()),
              Expanded(child: _buildSidebar()),
            ],
          )
        else
          Column(
            children: [
              _buildContent(),
              _buildSidebar(),
            ],
          ),
        
        // Theme-aware styling
        Container(
          color: context.isDarkMode 
            ? context.colorScheme.surface 
            : context.colorScheme.primary,
          child: Text(
            'Responsive Text',
            style: context.textTheme.headlineMedium,
          ),
        ),
        
        // Screen information
        Text('Screen size: ${context.width}x${context.height}'),
        Text('Pixel ratio: ${context.pixelRatio}'),
        
        // Utility methods
        ElevatedButton(
          onPressed: () => context.hideKeyboard(),
          child: Text('Hide Keyboard'),
        ),
      ],
    );
  }
}
```

### **Development Tools**

#### **Core Logger**

Enterprise-grade logging system with structured logging capabilities.

```dart
abstract interface class CoreLogger {
  /// Log verbose message for detailed diagnostics
  void verbose(dynamic message, [Object? error, StackTrace? stackTrace]);
  
  /// Log debug information for development-time analysis
  void debug(dynamic message, [Object? error, StackTrace? stackTrace]);
  
  /// Log informational messages about application operation
  void info(dynamic message, [Object? error, StackTrace? stackTrace]);
  
  /// Log non-critical issues that might require attention
  void warning(dynamic message, [Object? error, StackTrace? stackTrace]);
  
  /// Log critical errors that need immediate investigation
  void error(dynamic message, [Object? error, StackTrace? stackTrace]);
}
```

#### **Core BLoC Observer**

Comprehensive BLoC state monitoring and logging.

```dart
class CoreBlocObserver extends BlocObserver {
  CoreBlocObserver(this.logger);
  
  final CoreLogger logger;
  
  @override
  void onEvent(Bloc bloc, Object? event);
  
  @override
  void onChange(BlocBase bloc, Change change);
  
  @override
  void onTransition(Bloc bloc, Transition transition);
  
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace);
  
  @override
  void onCreate(BlocBase bloc);
  
  @override
  void onClose(BlocBase bloc);
}
```

#### **Usage Example**

```dart
final logger = getIt<CoreLogger>();

// Different log levels
logger.verbose('Detailed diagnostic information');
logger.debug('Debug information for development');
logger.info('Application started successfully');
logger.warning('Non-critical issue detected');
logger.error('Critical error occurred', error, stackTrace);

// Setup BLoC observer
Bloc.observer = CoreBlocObserver(getIt<CoreLogger>());
```

### **Utility Classes**

#### **Value Tester**

Comprehensive value validation and testing utilities.

```dart
abstract final class ValueTester {
  /// Checks if the given object is null
  static bool isNull(dynamic value);
  
  /// Checks if a String, Iterable, or Map is null or "blank"
  static bool isNullOrBlank(dynamic value);
  
  /// Checks if a String, Iterable, or Map is blank
  static bool isBlank(dynamic value);
  
  /// Returns the length of the value if applicable
  static int? dynamicLength(dynamic value);
  
  /// Length comparison methods
  static bool isLengthGreaterThan(dynamic value, int maxLength);
  static bool isLengthGreaterOrEqual(dynamic value, int maxLength);
  static bool isLengthLessThan(dynamic value, int maxLength);
  static bool isLengthLessOrEqual(dynamic value, int maxLength);
  static bool isLengthEqualTo(dynamic value, int otherLength);
  static bool isLengthBetween(dynamic value, int minLength, int maxLength);
}
```

### **Best Practices & Guidelines**

#### **Architecture Best Practices**

1. **Clean Architecture Principles**
   ```dart
   // ✅ Good: Clear separation of concerns
   class UserRepository {
     final ApiHandlerInterface _apiHandler;
     final LocalDatabaseInterface _localDb;
     
     UserRepository(this._apiHandler, this._localDb);
     
     Future<Either<NetworkFailure, List<User>>> getUsers() async {
       // Implementation
     }
   }
   ```

2. **Dependency Injection**
   ```dart
   // ✅ Good: Constructor injection
   class UserCubit extends CoreCubit<UserState, List<User>> {
     final UserRepository _userRepository;
     
     UserCubit(this._userRepository) : super(const UserState());
   }
   ```

3. **Error Handling**
   ```dart
   // ✅ Good: Comprehensive error handling
   Future<Either<NetworkFailure, User>> getUser(String id) async {
     try {
       final result = await _apiHandler.get('/users/$id');
       return result.fold(
         (failure) => left(failure),
         (data) => right(User.fromJson(data)),
       );
     } catch (e, stackTrace) {
       logger.error('Failed to get user', e, stackTrace);
       return left(UnknownFailure());
     }
   }
   ```

#### **State Management Best Practices**

1. **Immutable States**
   ```dart
   // ✅ Good: Immutable state with Freezed
   @freezed
   class UserState with _$UserState {
     const factory UserState({
       @Default(ApiState.initial()) ApiState<List<User>> usersState,
       @Default('') String searchQuery,
       @Default(false) bool isRefreshing,
     }) = _UserState;
   }
   ```

2. **Single Responsibility**
   ```dart
   // ✅ Good: Focused Cubit
   class UserCubit extends CoreCubit<UserState, List<User>> {
     // Only handles user-related operations
     Future<void> loadUsers() async { /* ... */ }
     Future<void> searchUsers(String query) async { /* ... */ }
   }
   ```

#### **UI Best Practices**

1. **Responsive Design**
   ```dart
   // ✅ Good: Responsive layout
   class ResponsiveLayout extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return LayoutBuilder(
         builder: (context, constraints) {
           if (constraints.maxWidth > 600) {
             return DesktopLayout();
           } else {
             return MobileLayout();
           }
         },
       );
     }
   }
   ```

2. **Theme Consistency**
   ```dart
   // ✅ Good: Using theme colors
   Container(
     color: Theme.of(context).colorScheme.primary,
     child: Text(
       'Hello',
       style: Theme.of(context).textTheme.headlineMedium,
     ),
   )
   ```

#### **Performance Best Practices**

1. **Lazy Loading**
   ```dart
   // ✅ Good: Lazy loading with pagination
   CorePaginationWidget<User, UserMeta>(
     paginationFunction: (batch, limit) => _userRepository.getUsers(
       PagePaginationParams(page: batch, limit: limit),
     ),
     paginationStrategy: PagePaginationStrategy(limit: 20),
   )
   ```

2. **Image Optimization**
   ```dart
   // ✅ Good: Optimized image loading
   CoreImage.network(
     imageUrl,
     memCacheWidth: 200,
     memCacheHeight: 200,
     maxWidthDiskCache: 400,
     maxHeightDiskCache: 400,
   )
   ```

### **Complete Integration Example**

```dart
// main.dart - Complete app setup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core dependencies
  await CoreConfig.initializeCoreDependencies(
    CoreConfigEntity(
      currentEnvironment: CoreEnvironment.development,
      networkConfigEntity: NetworkConfigEntity(
        baseUrl: 'https://api.example.com',
      ),
      localizationConfigEntity: LocalizationConfigEntity(
        defaultLocale: Locale('en'),
        supportedLocales: [Locale('en'), Locale('ar')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
      themeConfigEntity: ThemeConfigEntity.defaultConfig(),
      shouldLog: true,
      enableSecureStorage: true,
    ),
  );
  
  // Setup BLoC observer
  Bloc.observer = CoreBlocObserver(getIt<CoreLogger>());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => getIt<ThemeCubit>(),
        ),
        BlocProvider<LocalizationCubit>(
          create: (_) => getIt<LocalizationCubit>(),
        ),
        BlocProvider<PlatformCubit>(
          create: (_) => getIt<PlatformCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => getIt<UserCubit>(),
        ),
      ],
      child: ThemeWrapper(
        builder: (context, themeConfig) {
          return MaterialApp.router(
            title: 'My App',
            theme: themeConfig.lightTheme,
            darkTheme: themeConfig.darkTheme,
            themeMode: themeConfig.themeMode,
            routerConfig: getIt<CoreNavigator>().router,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('ar'),
            ],
          );
        },
      ),
    );
  }
}
```

---

**📝 Note**: This completes the comprehensive documentation for the Coore Flutter package. The advanced features and best practices provide enterprise-grade utilities, extensions, development tools, and comprehensive guidelines for building scalable, maintainable Flutter applications.

**🎉 Documentation Complete**: All 9 steps have been documented with comprehensive coverage of every feature, API, and best practice in the Coore package.