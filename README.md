# 🎯 Strata Framework (formerly Coore)

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

**Strata** is an enterprise Melos monorepo modularized into 7 focused packages designed for maximum flexibility, zero unnecessary framework lock-in, functional error handling, and robust async dependency injection.

---

## 📦 Strata Monorepo Packages

| Package | Purpose | Dependencies |
| :--- | :--- | :--- |
| **`strata_core`** | Domain entities, failures, logger contracts, sensitive storage interfaces, `ApiState<T>`, and `UseCase` contracts. | Pure Dart (`equatable`, `fpdart`, `get_it`) |
| **`strata_network`** | Dio HTTP client wrapper, token lifecycle management, and request cancellation. | `strata_core`, `dio`, `mutex` |
| **`strata_storage`** | Secure persistence adapters (`FlutterSecureSensitiveStorage`) and database directory helpers. | `strata_core`, `flutter_secure_storage` |
| **`strata_state`** | BLoC state utilities, `ApiStateHostMixin`, `ApiStateHandler`, and `ApiStateBuilder`. | `strata_core`, `flutter_bloc` |
| **`strata_navigation`** | GoRouter configuration wrappers, route guards, and `NavigationServiceInterface`. | `strata_core`, `go_router` |
| **`strata_ui`** | Decoupled UI components (`CorePaginationWidget`, form fields, image widgets, context extensions). | `strata_core`, `flutter` |
| **`strata`** | Orchestrator meta-package exporting all 6 sub-packages and single-line setup via `StrataInitializer`. | All sub-packages |

---

## 🚀 Quick Start

Initialize all Strata sub-packages with `StrataInitializer`:

```dart
import 'package:strata/strata.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final strataConfig = StrataConfigEntity(
    networkConfig: const NetworkConfigEntity(
      baseUrl: 'https://api.example.com',
      excludedPaths: ['/login', '/register'],
      refreshTokenApiEndpoint: '/auth/refresh',
      accessTokenKey: 'access_token',
      refreshTokenKey: 'refresh_token',
    ),
    navigationConfig: NavigationConfigEntity(
      routes: $appRoutes,
      initialLocation: '/',
    ),
  );

  // Single-line framework initialization (awaits getIt.allReady())
  await StrataInitializer.initialize(strataConfig);

  runApp(const MyApp());
}
```

---

## 📚 Module Guide

### 🌐 Networking

Coore provides a type-safe API handler that wraps all network calls in `Either<Failure, T>`, enabling functional error handling with granular failure types.

#### Making API Requests

```dart
import 'package:coore/coore.dart';
import 'package:get_it/get_it.dart';

final apiHandler = getIt<ApiHandlerInterface>();

// GET request with cancellation support
final result = await apiHandler.get<List<User>>(
  '/users',
  parser: (json) => (json['data'] as List)
      .map((item) => User.fromJson(item as Map<String, dynamic>))
      .toList(),
  queryParameters: {'page': 1, 'limit': 20},
  shouldCache: true,
  isAuthorized: true,
  requestId: 'fetch-users', // Optional: for cancellation
);

// Handle the Either result with type-safe error handling
result.fold(
  (failure) {
    // Handle specific failure types
    if (failure is ConnectionFailure) {
      // Show offline message
      print('No internet: ${failure.message}');
    } else if (failure is ServerFailure) {
      // Show server error with status code
      print('Server error ${failure.statusCode}: ${failure.message}');
    } else if (failure is AuthFailure) {
      // Navigate to login
      print('Authentication required');
    } else {
      print('Error: ${failure.message}');
    }
  },
  (users) {
    // Handle success
    print('Fetched ${users.length} users');
  },
);
```

#### Request Cancellation

```dart
import 'package:coore/coore.dart';

final cancelManager = getIt<CancelRequestManager>();

// Start a request with a requestId
apiHandler.get('/users', requestId: 'fetch-users', ...);

// Cancel it later
cancelManager.cancelRequest('fetch-users');
```

#### Per-Request Retry Configuration

Coore supports both global retry settings (configured in `NetworkConfigEntity`) and per-request retry configuration. Per-request settings take precedence over global settings, allowing fine-grained control over retry behavior.

```dart
// Disable retry for a specific request
final result = await apiHandler.get<List<User>>(
  '/users',
  parser: (json) => [...],
  enableRetry: false, // This request won't retry even if global retry is enabled
);

// Custom retry settings for a specific request
final result = await apiHandler.post<Map<String, dynamic>>(
  '/data',
  parser: (json) => json,
  body: {'key': 'value'},
  enableRetry: true,
  maxRetryAttempts: 2, // Only 2 retries instead of global default
  retryDelay: Duration(seconds: 5), // 5 second delay instead of global default
);

// Use global retry settings (default behavior)
final result = await apiHandler.get<User>(
  '/users/123',
  parser: User.fromJson,
  // enableRetry defaults to true, uses global maxRetryAttempts and retryDelay
);
```

**Retry Parameters:**
- `enableRetry` (default: `true`) - Whether to enable retry for this request. If `false`, the request won't retry even if global retry is enabled.
- `maxRetryAttempts` (default: `null`) - Maximum number of retry attempts. If `null`, uses the global setting from `NetworkConfigEntity`.
- `retryDelay` (default: `null`) - Delay between retry attempts. If `null`, uses the global `retryInterval` from `NetworkConfigEntity`.

**When Requests Are Retried:**
- Connection timeout, send timeout, or receive timeout
- Network connectivity issues (`SocketException`)
- Server errors (status codes configured in `NetworkConfigEntity.retryOnStatusCodes`, typically 5xx)

#### POST Request with Form Data

```dart
final formData = MultipartFormDataAdapter({
  'name': 'John Doe',
  'email': 'john@example.com',
  'avatar': File('/path/to/avatar.jpg'),
});

final result = await apiHandler.post<Map<String, dynamic>>(
  '/users',
  parser: (json) => json,
  formData: formData,
  onSendProgress: (progress) => print('Upload: ${(progress * 100).toInt()}%'),
  isAuthorized: true,
);
```

---

### ⚠️ Error Handling & Failures

Coore provides a comprehensive failure hierarchy for enterprise-grade error handling. All API calls return `Either<Failure, T>`, where `Failure` is a base class with specific subtypes for different error scenarios.

#### Failure Types

```dart
// Base Failure class with observability support
abstract class Failure extends Equatable implements Exception {
  final String message;              // User-friendly message
  final String? code;                 // Analytics code (e.g., 'AUTH_001')
  final StackTrace? stackTrace;      // For Crashlytics/Sentry
  final Object? originalException;   // Original exception for debugging
}
```

**Available Failure Types:**

- **`ConnectionFailure`** - Network-level issues (timeouts, DNS, SSL, no internet)
  - `code: 'TIMEOUT'` - Request timeout
  - `code: 'NO_INTERNET'` - No internet connection
  - `code: 'SSL_ERR'` - SSL certificate error

- **`ServerFailure`** - HTTP 4xx/5xx errors from backend
  - `statusCode` - HTTP status code (e.g., 404, 500)
  - `requestId` - Backend trace ID for log correlation

- **`AuthFailure`** - Authentication issues (401)
  - Triggers auto-logout or token refresh flows

- **`UnauthorizedFailure`** - Authorization issues (403)
  - User is logged in but lacks required permissions

- **`ValidationFailure`** - Data validation errors (422)
  - `errors: Map<String, String>` - Field-specific errors
  - `firstError` - Helper to get first error message
  - `getErrorFor(String fieldName)` - Get error for specific field

- **`BusinessFailure`** - Business rule violations (200 OK but business error)
  - Example: "Insufficient funds", "Duplicate transaction"

- **`FormatFailure`** - Data parsing issues (malformed JSON, type mismatch)

- **`CacheFailure`** - Local storage issues (database, secure storage, filesystem)

- **`OperationCancelledFailure`** - User cancelled operation

- **`UnknownFailure`** - Unexpected errors (unhandled exceptions)

#### Error Handling Example

```dart
final result = await apiHandler.get<User>('/users/123', ...);

result.fold(
  (failure) {
    // Pattern matching on failure types
    switch (failure.runtimeType) {
      case ConnectionFailure:
        // Show offline UI
        showSnackBar('No internet connection');
        break;
        
      case AuthFailure:
        // Navigate to login
        router.push('/login');
        break;
        
      case ValidationFailure:
        final validationFailure = failure as ValidationFailure;
        // Show field-specific errors
        if (validationFailure.errors.containsKey('email')) {
          showFieldError('email', validationFailure.getErrorFor('email'));
        }
        break;
        
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        // Log with request ID for backend correlation
        logger.error(
          'Server error ${serverFailure.statusCode}',
          error: serverFailure,
          stackTrace: serverFailure.stackTrace,
          extra: {'requestId': serverFailure.requestId},
        );
        showSnackBar(serverFailure.message);
        break;
        
      default:
        // Handle unknown errors
        showSnackBar(failure.message);
    }
  },
  (user) {
    // Success handling
    displayUser(user);
  },
);
```

#### Exception Mapping

Coore automatically maps Dio exceptions to appropriate failure types:

- `DioExceptionType.connectionTimeout` → `ConnectionFailure(code: 'TIMEOUT')`
- `DioExceptionType.connectionError` → `ConnectionFailure(code: 'NO_INTERNET')`
- `DioExceptionType.badResponse` (401) → `AuthFailure`
- `DioExceptionType.badResponse` (403) → `UnauthorizedFailure`
- `DioExceptionType.badResponse` (422) → `ValidationFailure`
- `DioExceptionType.badResponse` (4xx/5xx) → `ServerFailure`
- Generic `Exception` → `UnknownFailure`

---

### 🔄 State Management

Coore simplifies API state management with `ApiStateHostMixin` and `ApiStateHandler`, eliminating boilerplate in your Cubits.

#### ApiState

`ApiState<T>` is a sealed class with four variants:

```dart
@freezed
sealed class ApiState<T> with _$ApiState<T> {
  const factory ApiState.initial() = Initial;
  const factory ApiState.loading() = Loading;
  const factory ApiState.success(T data) = Success;
  const factory ApiState.failure(Failure failure, {VoidCallback? retryFunction}) = Failure;
}
```

#### Using ApiStateHostMixin

```dart
import 'package:coore/coore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(ApiState.initial()) ApiState<List<User>> usersState,
    @Default(ApiState.initial()) ApiState<User?> currentUserState,
  }) = _UserState;
}

class UserCubit extends Cubit<UserState> with ApiStateHostMixin<UserState> {
  final UserRepository _repository;
  
  // Create handlers for each API state
  late final _usersHandler = createApiHandler<List<User>>(
    getApiState: (state) => state.usersState,
    setApiState: (state, apiState) => state.copyWith(usersState: apiState),
  );
  
  late final _currentUserHandler = createApiHandler<User?>(
    getApiState: (state) => state.currentUserState,
    setApiState: (state, apiState) => state.copyWith(currentUserState: apiState),
  );
  
  UserCubit(this._repository) : super(const UserState());
  
  Future<void> loadUsers() async {
    await _usersHandler.handleApiCall(
      apiCall: _repository.getUsers,
      params: PagePaginationParams(page: 1, limit: 20),
      onSuccess: (users) {
        print('Loaded ${users.length} users');
      },
      onFailure: (failure) {
        print('Failed: ${failure.message}');
      },
    );
  }
  
  Future<void> loadCurrentUser(String userId) async {
    await _currentUserHandler.handleApiCall(
      apiCall: (params) => _repository.getUserById(userId),
      params: NoParams(),
    );
  }
}
```

**Benefits:**
- ✅ Automatic loading/success/failure state management
- ✅ Built-in request cancellation with static request IDs
- ✅ Per-request retry configuration (disable or customize retry per request)
- ✅ Automatic cleanup on Cubit disposal

---

### 🎨 UI Components

#### Pagination Widget

`CorePaginationWidget` provides a complete pagination solution powered by **EasyRefresh v3** with pull-to-refresh, load-more, skeleton loading, and error handling. **Highly optimized for performance** with minimal rebuilds and efficient memory usage.

**Key Features:**
- 🔄 Pull-to-refresh with customizable headers (`MaterialHeader`, `ClassicHeader`, or custom)
- ⬇️ Load-more with customizable footers (`MaterialFooter`, `ClassicFooter`, or custom)
- 💀 Skeleton loading with `Skeletonizer` integration
- ⚠️ Error handling with retry functionality
- 🎯 Scroll-to-top FAB (optional)
- 📊 Supports both `ScrollView` and `Sliver` modes

**Basic Usage:**

```dart
CorePaginationWidget<User, PageMeta>(
  paginationFunction: (batch, limit, {requestId}) async {
    return await userRepository.getUsers(
      PagePaginationParams(page: batch, limit: limit),
    );
  },
  paginationStrategy: PagePaginationStrategy(limit: 20),
  scrollableBuilder: (context, response, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: response.data.length,
      itemBuilder: (context, index) {
        final user = response.data[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  },
  // Required if loadingBuilder is not provided (for skeleton loading)
  emptyEntity: const User(id: '', name: '', email: ''),
  emptyBuilder: (context) => const Center(
    child: Text('No users found'),
  ),
)
```

**Advanced Usage with Custom Headers/Footers:**

```dart
CorePaginationWidget<Product, PageMeta>(
  paginationFunction: (batch, limit, {requestId}) async {
    return await productRepository.getProducts(
      PagePaginationParams(page: batch, limit: limit),
    );
  },
  paginationStrategy: PagePaginationStrategy(limit: 20),
  scrollableBuilder: (context, response, controller) {
    return GridView.builder(
      controller: controller,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: response.data.length,
      itemBuilder: (context, index) => ProductCard(
        product: response.data[index],
      ),
    );
  },
  emptyEntity: const Product(id: '', name: '', price: 0),
  // Custom refresh header
  headerBuilder: (context) => ClassicHeader(
    dragText: 'Pull to refresh',
    armedText: 'Release to refresh',
    readyText: 'Refreshing...',
    processingText: 'Refreshing...',
    processedText: 'Refreshed',
    noMoreText: 'No more',
  ),
  // Custom load-more footer
  footerBuilder: (context) => ClassicFooter(
    dragText: 'Pull to load',
    armedText: 'Release to load',
    readyText: 'Loading...',
    processingText: 'Loading...',
    processedText: 'Loaded',
    noMoreText: 'No more data',
  ),
  // Custom error builder
  errorBuilder: (context, failure, retry, alreadyFetchedItemsWidget) {
    return Column(
      children: [
        if (alreadyFetchedItemsWidget != null) 
          Expanded(child: alreadyFetchedItemsWidget),
        Center(
          child: Column(
            children: [
              Text('Error: ${failure.message}'),
              ElevatedButton(
                onPressed: retry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  },
)
```

**Using with Existing Cubit:**

```dart
// Create cubit elsewhere
final paginationCubit = CorePaginationCubit<Product, PageMeta>(
  paginationFunction: (batch, limit, {requestId}) async {
    return await productRepository.getProducts(
      PagePaginationParams(page: batch, limit: limit),
    );
  },
  paginationStrategy: PagePaginationStrategy(limit: 20),
);

// Use in widget
CorePaginationWidget<Product, PageMeta>(
  paginationCubit: paginationCubit,
  scrollableBuilder: (context, response, controller) {
    // Your list implementation
  },
  emptyEntity: const Product(id: '', name: '', price: 0),
)
```

**Performance Optimizations:**
- ✅ **BlocSelector optimization** - Only rebuilds `EasyRefresh` when `hasReachedMax` changes
- ✅ **Cached skeleton placeholders** - Instance-level caching prevents regeneration on theme changes
- ✅ **Lazy error widget evaluation** - `alreadyFetchedItemsWidget` only built when error builder uses it
- ✅ **Efficient list concatenation** - Uses `List.from()..addAll()` for better performance with large datasets
- ✅ **Widget extraction** - `_PaginationBody` isolates state listening to prevent unnecessary rebuilds

#### Form Fields

```dart
// Text field with validation
CoreTextField(
  label: 'Email',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
  keyboardType: TextInputType.emailAddress,
)

// PIN/OTP field
CorePinCodeField(
  length: 6,
  onCompleted: (pin) => print('PIN: $pin'),
)
```

#### Image Widget

```dart
CoreImage.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

---

### 🧭 Navigation

Coore integrates with `go_router` and is designed to work seamlessly with `go_router_builder` for type-safe navigation.

```dart
// After initialization, access the router
final router = getIt<GoRouter>();

// Navigate from BLoCs/Services
router.push('/users/123');

// Show dialogs from BLoCs
final context = CoreRouter.rootNavigatorKey.currentContext!;
showDialog(context: context, builder: (context) => AlertDialog(...));
```

For type-safe navigation with `go_router_builder`, see the [Navigation Guide](docs/NAVIGATION_GUIDE.md).

---

### 💾 Storage

#### Local Database (Hive)

```dart
// Get an instance with a named box name parameter
final localDb = getIt<NoSqlDatabaseInterface>(param1: 'userData');

// Initialize the Hive box
final initResult = await localDb.initialize();
initResult.fold(
  (failure) => print('Initialization failed: ${failure.message}'),
  (_) => print('Database initialized'),
);

// Save data
final saveResult = await localDb.save<String>('username', 'john_doe');
saveResult.fold(
  (failure) => print('Save failed: ${failure.message}'),
  (_) => print('Data saved'),
);

// Read data
final username = await localDb.get<String>('username');
username.fold(
  (failure) => print('Error: ${failure.message}'),
  (value) => print('Username: $value'),
);

// Close when done
await localDb.close();
```

#### Secure Storage

```dart
final secureDb = getIt<SecureDatabaseInterface>();

// Initialize
await secureDb.initialize();

// Write sensitive data
await secureDb.write('token', 'secret_token');

// Read
final token = await secureDb.read('token');
```

---

## 🏗️ Architecture & Strata Sub-Packages

The framework is organized into decoupled, single-responsibility sub-packages under the `strata` umbrella:

* **`strata_core`**: Pure Dart contracts, failures, extensions (`DateTimeX`, `StringExtensions`, `FileExtension`, `IntExtensions`, `OneAKindList`), logger interface, pagination models, and `ValueTester`.
* **`strata_network`**: Dio HTTP client, token management, cancellation tracking, and network connectivity service (`NetworkStatusImp`).
* **`strata_state`**: BLoC & state management, `ApiStateHandler`, `ApiStateBuilder`, persistent Cubits using **HydratedBloc** (`ThemeCubit`, `LocalizationCubit`, `PlatformCubit`), `NetworkStatusCubit`, `CorePaginationCubit`, and Value Selectors (`SingleSelectorCubit`, `MultiSelectorCubit`).
* **`strata_ui`**: Reusable UI components, form fields (`CoreTextField`, `CorePinCodeField`), widgets (`CoreImage`, `CoreCarousel`, `CoreDefaultErrorWidget`), UI wrappers (`ThemeWrapper`, `LocalizationWrapper`, `NetworkStatusWrapper`), and responsive layout utilities.
* **`strata_storage`**: Encrypted and secure storage integrations (`FlutterSecureSensitiveStorage`).
* **`strata_navigation`**: `go_router` abstractions, route guards, and navigation services.
* **`strata`**: Meta-package orchestrating `StrataInitializer` and exporting all sub-packages.

---

## 🔧 Available Services & Components

After initializing via `StrataInitializer.initialize()`, the following components and services are available:

* **Hydrated State Management (`strata_state`)**:
  * `ThemeCubit` - Persisted theme management (`ThemeMode.light` / `ThemeMode.dark`)
  * `LocalizationCubit` - Persisted locale management (`Locale`)
  * `PlatformCubit` - Persisted device/platform information (`DeviceInfoEntity`)
  * `NetworkStatusCubit` - Real-time connectivity state
  * `CorePaginationCubit` - Generic paginated data fetching and lifecycle management
  * `SingleSelectorCubit` / `MultiSelectorCubit` - Selection management
* **Networking & Connectivity (`strata_network`)**:
  * `ApiHandlerInterface` - HTTP client
  * `NetworkStatusImp` - Network connectivity monitoring (`NetworkStatusInterface`)
  * `CancelRequestManagerInterface` - Request cancellation tracking
* **UI Wrappers & Widgets (`strata_ui` & `strata_state`)**:
  * `ThemeWrapper` - Reactive theme builder
  * `LocalizationWrapper` - Reactive locale builder
  * `NetworkStatusWrapper` - Network status change listener & banner builder
* **Platform Service (`strata_state` / `strata_core`)**:
  * `PlatformServiceImpl` - Platform and device info collector (`PlatformServiceInterface`)
  * `DeviceInfoEntity` - Cross-platform device metadata model

---

## 📖 Additional Resources

- [Navigation Guide](docs/NAVIGATION_GUIDE.md) - Comprehensive navigation documentation


---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---


**Built with ❤️ for the Flutter community**

