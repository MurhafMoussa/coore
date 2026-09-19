# strata_ui

Reusable UI components, custom form fields, and layout theme abstractions for the Strata framework.

## Overview

`strata_ui` provides decoupled, reusable Flutter widgets isolated from state management (`flutter_bloc`) and routing (`go_router`) engines. Navigation and state interactions are handled cleanly via standard Flutter callback closures.

## Architectural Rules & Boundaries

- **Decoupled Components**: Depends ONLY on `strata_core`, `flutter`, `easy_refresh`, `skeletonizer`, `pinput`, `readmore`, `shimmer`, `cached_network_image`, `carousel_slider`, `gap`, and `typed_form_fields`.
- **Zero Framework Binding**: MUST NOT depend on `flutter_bloc` or `go_router`.
- **Callback Pattern**: Actions and events are passed as callbacks (`onRefresh`, `onLoadMore`, `onChanged`, `onTap`).
- **Strict Boundary Enforcement**: Enforced via package dependency audit tests.

## Key Components

### 1. `CorePaginationWidget`
Infinite scrolling / pull-to-refresh list and grid widget wrapping `EasyRefresh` and `Skeletonizer` without requiring BLoC binding.

```dart
import 'package:strata_ui/strata_ui.dart';

CorePaginationWidget<UserItem, NoMetaModel>(
  items: userPaginatedModel,
  isLoading: isUserLoading,
  hasReachedMax: hasReachedMax,
  onRefresh: () async => fetchUsers(),
  onLoadMore: () async => fetchMoreUsers(),
  emptyEntity: UserItem.empty,
  scrollableBuilder: (context, items, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: items.data.length,
      itemBuilder: (context, index) => UserTile(user: items.data[index]),
    );
  },
);
```

### 2. Custom Form Fields (`CoreTextField`, `CorePinCodeField`)
Form field widgets powered by `typed_form_fields` 2.x providing type-safe reactive updates and customizable error indicators.

```dart
CoreTextField(
  name: 'email',
  labelText: 'Email Address',
  showRequiredStar: true,
  onChanged: (val) => print('Email: $val'),
);

CorePinCodeField(
  name: 'otp',
  length: 6,
  onCompleted: (pin) => verifyOtp(pin),
);
```

### 3. `CoreImage`
Universal image component handling asset, network, file, and SVG formats with shimmer placeholder loading and error fallbacks.

```dart
CoreImage.network(
  'https://example.com/avatar.jpg',
  width: 80,
  height: 80,
  borderRadius: BorderRadius.circular(40),
);
```

### 4. Layout & Theme Constants
Centralized spacing, padding, radius, and animation managers:
- `SpacingManager` (e.g. `SpacingManager.gap16`)
- `PaddingManager` (e.g. `PaddingManager.paddingAll16`)
- `BorderRadiusManager` (e.g. `BorderRadiusManager.radiusAll12`)
- `SizesManager` and `AnimationParamsManager`
- Responsive layout helper `getValueForScreenType(context, mobile: 16, tablet: 24, desktop: 32)`

## Running Tests & Audits

Run static analysis and tests inside the `strata_ui` directory:

```bash
cd strata_ui
flutter analyze
flutter test
```
