# strata_state

BLoC state utilities and `ApiStateHandler` lifecycle management for the Strata framework.

## Overview

`strata_state` provides BLoC/Cubit state handling delegates and UI builder widgets for managing `ApiState<T>` transitions. It includes `ApiStateHostMixin` for managing multiple API lifecycles inside a single Cubit/BLoC state, `DisposableApiStateHandlerInterface`, `ApiStateHandler` with force re-execution override and diagnostic warnings for skipped loading calls, and `ApiStateBuilder` for UI rendering.

## Architectural Rules & Boundaries

- **BLoC Decoupling**: Depends ONLY on `strata_core`, `flutter`, `flutter_bloc`, `get_it`, and `skeletonizer`.
- **Zero Heavy Framework Lock-in**: Has ZERO dependencies on `strata_network`, `strata_storage`, `go_router`, or Dio.
- **Strict Boundary Enforcement**: Enforced via package dependency tests.

## Key Components

### 1. `DisposableApiStateHandlerInterface` & `ApiStateHandler`
A delegate class managed by `ApiStateHostMixin` that encapsulates loading, success, failure, retry, and cancellation for a specific `ApiState` field within a composite BLoC state.

```dart
import 'package:strata_state/strata_state.dart';

// Force execution during loading state
await apiHandler.handleApiCall(
  apiCall: fetchUserDataUseCase,
  params: userId,
  force: true,
);

// Default behavior (force: false) logs a diagnostic warning via CoreLoggerInterface if state is already loading
await apiHandler.handleApiCall(
  apiCall: fetchUserDataUseCase,
  params: userId,
  force: false,
);
```

### 2. `ApiStateHostMixin`
Mixin for `BlocBase` (Cubit/BLoC) that automatically creates and disposes `ApiStateHandler` instances on `close()`.

```dart
class UserCubit extends Cubit<UserState> with ApiStateHostMixin<UserState> {
  UserCubit() : super(UserState.initial()) {
    _profileHandler = createApiHandler(
      getApiState: (state) => state.profileState,
      setApiState: (state, apiState) => state.copyWith(profileState: apiState),
    );
  }

  late final ApiStateHandler<UserState, User> _profileHandler;

  Future<void> fetchProfile(String userId) async {
    await _profileHandler.handleApiCall(
      apiCall: getUserUseCase,
      params: userId,
    );
  }
}
```

### 3. `ApiStateBuilder`
Flutter widget that listens to a specific `ApiState` on a BLoC/Cubit and renders pattern-matched UI states (`initial`, `loading`, `success`, `failure`).

```dart
ApiStateBuilder<UserState, User>(
  bloc: userCubit,
  getApiState: (state) => state.profileState,
  emptyEntity: User.empty(),
  successBuilder: (context, user) => UserProfileWidget(user: user),
);
```

## Running Tests & Audits

Run static analysis and unit tests inside the `strata_state` directory:

```bash
cd strata_state
flutter analyze
flutter test
```
