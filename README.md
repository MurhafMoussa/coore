# 🎯 Strata Framework

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

**Strata** is an enterprise modular Flutter & Dart framework structured as a Melos monorepo. It is decomposed into 7 focused sub-packages designed for maximum flexibility, zero unnecessary framework lock-in, functional error handling via `fpdart`, and robust async dependency injection using `GetIt`.

---

## 📦 Strata Monorepo Packages

| Package | Purpose | Primary Dependencies |
| :--- | :--- | :--- |
| **`strata_core`** | Domain entities, failures, logger contracts, `SensitiveStorageInterface`, `ApiState<T>`, and `UseCase` contracts. | Pure Dart (`equatable`, `fpdart`, `get_it`) |
| **`strata_network`** | Dio HTTP client wrapper (`ApiHandlerInterface`), token lifecycle management (`TokenManagerInterface`), and request cancellation (`CancelRequestManagerInterface`). | `strata_core`, `dio`, `mutex`, `internet_connection_checker_plus` |
| **`strata_storage`** | Secure persistence adapters (`FlutterSecureSensitiveStorage`), encryption key rotation, and storage directory helpers. | `strata_core`, `flutter_secure_storage`, `path_provider` |
| **`strata_state`** | BLoC & state management, `ApiStateHostMixin`, `ApiStateHandler`, `ApiStateBuilder`, persistent Cubits (`ThemeCubit`, `LocalizationCubit`, `PlatformCubit`), and Value Selectors. | `strata_core`, `flutter_bloc`, `hydrated_bloc` |
| **`strata_navigation`** | GoRouter configuration wrappers (`CoreRouter`), route guards (`RouteGuardInterface`), and navigation service. | `strata_core`, `go_router` |
| **`strata_ui`** | Decoupled UI components (`CorePaginationWidget`, form fields, `CoreImage`, `CoreCarousel`), theme/spacing constants, and reactive wrappers. | `strata_core`, `flutter`, `easy_refresh`, `skeletonizer` |
| **`strata`** | Meta-package orchestrating `StrataInitializer` and exporting all sub-packages for single-line app setup. | All Strata sub-packages |

---

## 🚀 Quick Start

### 1. Add Dependency

Add the orchestrator meta-package `strata` (or specific sub-packages) to your application's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  strata:
    path: path/to/strata # or pub version when published
```

### 2. Framework Initialization

Initialize all Strata sub-packages in `main.dart` using `StrataInitializer.initialize()`:

```dart
import 'package:flutter/material.dart';
import 'package:strata/strata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final strataConfig = StrataConfigEntity(
    networkConfig: const NetworkConfigEntity(
      baseUrl: 'https://api.example.com',
      excludedPaths: ['/login', '/register'],
      refreshTokenApiEndpoint: '/auth/refresh',
      accessTokenKey: 'access_token',
      refreshTokenKey: 'refresh_token',
      enableRetry: true,
      maxRetryAttempts: 3,
      retryInterval: Duration(seconds: 2),
    ),
    navigationConfig: NavigationConfigEntity(
      routes: $appRoutes, // GoRouter routes
      initialLocation: '/',
    ),
  );

  // Single-line framework setup (registers GetIt singletons and awaits getIt.allReady())
  await StrataInitializer.initialize(strataConfig);

  runApp(const MyApp());
}
```

---

## 📖 Module Usage Guide

### 🌐 1. Networking (`strata_network`)

Strata provides a type-safe API handler (`ApiHandlerInterface`) wrapping all network requests in `Either<Failure, T>`, enabling functional error handling.

#### Making Requests (GET, POST, PUT, DELETE)

```dart
import 'package:get_it/get_it.dart';
import 'package:strata/strata.dart';

final apiHandler = GetIt.I<ApiHandlerInterface>();

// GET request returning Either<Failure, List<User>>
final result = await apiHandler.get<List<User>>(
  '/users',
  parser: (json) => (json['data'] as List)
      .map((item) => User.fromJson(item as Map<String, dynamic>))
      .toList(),
  queryParameters: {'page': 1, 'limit': 20},
  isAuthorized: true,
  requestId: 'fetch-users', // Optional ID for request cancellation
);

// Process functional result
result.fold(
  (failure) => print('Error [${failure.code}]: ${failure.message}'),
  (users) => print('Fetched ${users.length} users'),
);
```

#### Request Cancellation

Track and cancel pending network requests using `CancelRequestManagerInterface`:

```dart
final cancelManager = GetIt.I<CancelRequestManagerInterface>();

// Trigger network call with a requestId
apiHandler.get('/heavy-report', requestId: 'report-job', parser: (j) => j);

// Cancel specific request by ID when user navigates away
cancelManager.cancelRequest('report-job', reason: 'User navigated away');
```

#### Per-Request Retry Configuration

Override global retry behavior on specific API endpoints:

```dart
// Custom retry configuration for critical request
final result = await apiHandler.post<Map<String, dynamic>>(
  '/transactions',
  parser: (json) => json,
  body: {'amount': 100},
  enableRetry: true,
  maxRetryAttempts: 5,
  retryDelay: const Duration(seconds: 3),
);

// Disable retry for non-idempotent or one-off operations
final uploadResult = await apiHandler.post<Unit>(
  '/upload',
  parser: (_) => unit,
  enableRetry: false,
);
```

#### Network Status Monitoring

Check network connectivity or listen to live changes:

```dart
final networkStatus = GetIt.I<NetworkStatusInterface>();

// Check current status
bool online = await networkStatus.isConnected;

// Listen to network status stream
networkStatus.connectionStream.listen((status) {
  if (status == ConnectionStatus.disconnected) {
    print('Network connection lost');
  }
});
```

---

### 🔑 2. Secure Storage (`strata_storage`)

Strata provides encrypted key-value persistence through `SensitiveStorageInterface` implemented by `FlutterSecureSensitiveStorage`.

> **Database Neutrality Notice:** Strata does NOT impose generic key-value database wrappers (`NoSqlDatabaseInterface`). Feature repositories interact directly with native database engines (Drift, Isar, Hive) while using `SensitiveStorageInterface` for secure credentials and encryption keys.

#### Storing & Retrieving Credentials

```dart
final secureStorage = GetIt.I<SensitiveStorageInterface>();

// Save sensitive item
final saveResult = await secureStorage.save('api_token', 'secret_jwt_token');

// Read sensitive item
final readResult = await secureStorage.read('api_token');
readResult.fold(
  (failure) => print('Storage read error: ${failure.message}'),
  (token) => print('Read token: $token'),
);

// Delete item or clear all
await secureStorage.delete('api_token');
await secureStorage.deleteAll();
```

#### Storage Encryption Key Rotation & Helpers

```dart
// Generate or retrieve encryption keys for database engines (e.g. Hive/Drift)
final keyBytes = await StorageEncryptionKeyHelper.getOrCreateEncryptionKey(
  storage: secureStorage,
  keyName: 'db_encryption_key',
);

// Resolve application storage directory for database engines
final dbDir = await StorageDirectoryHelper.getDatabaseDirectory(
  subDirectory: 'user_data',
);
```

---

### 🔄 3. State Management (`strata_state`)

Strata decouples pure `ApiState<T>` from BLoC, allowing lightweight state modeling with `ApiStateHostMixin`, `ApiStateHandler`, and `ApiStateBuilder`.

#### Pure `ApiState<T>` Representation

```dart
// ApiState<T> variants: Initial, Loading, Success, Failure
const state = ApiState<String>.loading();

state.when(
  initial: () => print('Initial'),
  loading: () => print('Loading...'),
  success: (data) => print('Data: $data'),
  failure: (failure, retry) => print('Error: ${failure.message}'),
);
```

#### Building Cubits with `ApiStateHostMixin`

`ApiStateHostMixin` provides streamlined API handling with state safety and automatic Cubit disposal cleanup:

```dart
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(ApiState.initial()) ApiState<List<User>> usersState,
  }) = _UserState;
}

class UserCubit extends Cubit<UserState> with ApiStateHostMixin<UserState> {
  final UserRepositoryInterface _repository;

  late final _usersHandler = createApiHandler<List<User>>(
    getApiState: (state) => state.usersState,
    setApiState: (state, apiState) => state.copyWith(usersState: apiState),
  );

  UserCubit(this._repository) : super(const UserState());

  Future<void> fetchUsers({bool force = false}) async {
    await _usersHandler.handleApiCall(
      apiCall: (params) => _repository.getUsers(params),
      params: const PagePaginationParams(page: 1, limit: 20),
      force: force, // Force re-execution even if currently loading
    );
  }
}
```

#### Rendering State in UI with `ApiStateBuilder`

```dart
ApiStateBuilder<UserState, List<User>>(
  bloc: context.read<UserCubit>(),
  getApiState: (state) => state.usersState,
  loadingBuilder: (context) => const CircularProgressIndicator(),
  successBuilder: (context, users) => ListView.builder(
    itemCount: users.length,
    itemBuilder: (context, index) => Text(users[index].name),
  ),
  errorBuilder: (context, failure, onRetry) => ElevatedButton(
    onPressed: onRetry,
    child: Text('Retry (${failure.message})'),
  ),
)
```

#### Hydrated Cubits (`ThemeCubit`, `LocalizationCubit`, `PlatformCubit`)

Strata includes pre-built persisted Cubits using `HydratedBloc`:

```dart
// Theme Management
context.read<ThemeCubit>().setThemeMode(ThemeMode.dark);

// Locale / Language Management
context.read<LocalizationCubit>().changeLanguage(const Locale('ar'));

// Access Platform & Device Information
final deviceInfo = context.read<PlatformCubit>().state.deviceInfo;
print('Device Model: ${deviceInfo?.model}, OS: ${deviceInfo?.osVersion}');
```

---

### 🧭 4. Navigation (`strata_navigation`)

`strata_navigation` configures `GoRouter` with route guards and cross-layer navigation service abstractions.

#### Navigating from BLoCs/Services via `NavigationServiceInterface`

```dart
final navService = GetIt.I<NavigationServiceInterface>();

// Navigate to location without context dependency
navService.go('/dashboard');

// Push sub-route with parameters
navService.push('/details', extra: {'id': '123'});

// Pop current route
navService.pop();
```

#### Defining Custom Route Guards

```dart
class AuthRouteGuard implements RouteGuardInterface {
  final AuthTokenManagerInterface _tokenManager;

  AuthRouteGuard(this._tokenManager);

  @override
  Future<String?> evaluate(BuildContext context, GoRouterState state) async {
    final isAuthenticated = await _tokenManager.hasValidToken();
    if (!isAuthenticated) {
      return '/login'; // Redirect path
    }
    return null; // Proceed to requested path
  }
}
```

---

### 🎨 5. UI Components (`strata_ui`)

`strata_ui` contains decoupled, responsive UI components isolated from BLoC and router dependencies.

#### High-Performance Paginated List (`CorePaginationWidget`)

`CorePaginationWidget` integrates **EasyRefresh v3** with pull-to-refresh, infinite load-more, skeleton loading (`Skeletonizer`), and error retry handling:

```dart
CorePaginationWidget<Product, PageMeta>(
  paginationFunction: (batch, limit, {requestId}) async {
    return await productRepository.getProducts(
      PagePaginationParams(page: batch, limit: limit),
    );
  },
  paginationStrategy: const PagePaginationStrategy(limit: 20),
  scrollableBuilder: (context, response, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: response.data.length,
      itemBuilder: (context, index) {
        final product = response.data[index];
        return ListTile(title: Text(product.name));
      },
    );
  },
  emptyEntity: const Product(id: '', name: '', price: 0),
  emptyBuilder: (context) => const Center(child: Text('No products found')),
)
```

#### Form Input Widgets

```dart
// Text Field with Label and Validation
CoreTextField(
  label: 'Email Address',
  validator: (val) => val == null || val.isEmpty ? 'Email is required' : null,
)

// PIN / OTP Code Input Field
CorePinCodeField(
  length: 6,
  onCompleted: (pin) => print('Entered PIN: $pin'),
)
```

#### Image & Display Components

```dart
CoreImage.network(
  'https://example.com/avatar.jpg',
  width: 100,
  height: 100,
  borderRadius: BorderRadiusManager.circular12,
)
```

#### Reactive Application Wrappers

Wrap your root app widget with reactive framework builders:

```dart
ThemeWrapper(
  builder: (context, themeMode) => LocalizationWrapper(
    builder: (context, locale) => MaterialApp.router(
      themeMode: themeMode,
      locale: locale,
      routerConfig: GetIt.I<GoRouter>(),
    ),
  ),
)
```

---

## 🛠️ Monorepo Commands (Melos)

When working inside the Strata monorepo root, execute workspace commands using **Melos**:

```bash
# Bootstrap all package dependencies
melos bootstrap

# Run Dart analysis across all 7 packages
melos run analyze

# Run unit & widget tests across all sub-packages
melos run test
```

---

## 🤝 Contributing

Contributions are welcome! Please follow the sub-package dependency boundary rules specified in `AGENTS.md` and `GLOSSARY.md`.

**Built with ❤️ for scalable Flutter development**
