---
type: Spec
title: Enterprise Multi-Package Pagination Suite Refactoring
---

## Problem

The current pagination implementation across `coore` / `strata` packages exhibits critical architectural, performance, and maintainability flaws:
1. **Concurrency & Race Conditions**: `StrataPaginationBloc` lacks explicit `isLoadingMore` tracking and concurrency guards, allowing rapid user scrolling to trigger parallel network calls, out-of-order data appends, and state corruption. [L1, L2, L5]
2. **Mutable Strategy**: `PaginationStrategy` maintains mutable internal state (`page++`, `skip += limit`), violating immutable BLoC state principles and time-travel debugging. [L1, L2]
3. **Duplicate State Engines**: `StrataPaginationWidget` in `strata_ui` implements duplicate `setState`-based fetching logic alongside `StrataPaginationBloc`, creating state duplication and maintenance drift. [L1, L2]
4. **Third-Party UI Dependency**: `strata_ui` depends on `easy_refresh`, adding unnecessary third-party package overhead instead of leveraging Flutter's native SDK components. [L3]
5. **Lack of Cursor Support & Rigid Parameters**: `PaginationParams` in `strata_network` is restricted to `batch`/`limit` offsets, preventing cursor-based pagination. [L1]
6. **Poor Page-N Error UX**: Errors occurring on page 2+ hide behind the existing list with no bottom retry mechanism. [L6]
7. **Missing Offline/Caching Support**: No standard cache policies or offline indicators exist for paginated views. [L8]

## Proposed Outcome

Deliver an enterprise production-grade, platform-adaptive pagination suite across `strata_core`, `strata_network`, `strata_state`, and `strata_ui` featuring:
- Pure, immutable `PaginationStrategy<P>` value types supporting Page/Offset, Skip/Limit, and Cursor/Keyset strategies.
- Generalized `PaginationParams` supporting opaque string cursors, dynamic query filters, and automatic `requestId` generation.
- A thread-safe `StrataPaginationBloc` with $O(N)$ item deduplication, request cancellation via `CancelRequestManagerInterface`, BLoC concurrency transformers (`restartable` / `droppable`), and explicit sealed state transitions.
- A decoupled, platform-adaptive `StrataPaginationWidget` utilizing native Flutter `RefreshIndicator.adaptive`, `NotificationListener<ScrollNotification>`, layout-agnostic builders (`scrollableBuilder`, `sliversBuilder`, `customBuilder`), and desktop/web scrollbar/shortcut support.
- Native `Skeletonizer` loading states (full-screen for initial load, bottom tile for load-more) and bottom inline retry footer for page-N failures.
- Native `PaginationCachePolicy` (`networkOnly`, `cacheFirst`, `cacheAndNetwork`) and offline UI indicators.
- 100% executable DartDoc documentation with `@example` code snippets, zero package boundary leaks, and comprehensive unit and widget tests.

## User Stories

1. As a mobile developer, I want to implement infinite scrolling lists using pure immutable strategies (Page, Skip, or Cursor) so that pagination state remains predictable and testable. [L1, L2]
2. As an app user on iOS or Android, I want a smooth, native pull-to-refresh and infinite scroll experience without list duplication or lag when scrolling fast. [L2, L3, L4]
3. As a desktop or web user, I want keyboard shortcuts (`Ctrl+R` / `Cmd+R`), mouse scrollbars, and window resize state preservation without accidental re-fetches. [L4]
4. As an app user with weak connectivity, I want to see previously loaded items when page 2 fails, with a clear bottom "Retry" button, and offline cache badges when viewing offline data. [L6, L8]
5. As a framework maintainer, I want strict multi-package boundary enforcement, 100% executable DartDoc documentation, and native Flutter widget tests verifying refresh and load-more behavior. [L7]

## Requirements

### 1. Domain Layer (`strata_core`)
- Define `abstract class PaginationStrategy<P extends PaginationParams>` where `P` is an immutable parameter model (`DefaultPaginationParams`, `SkipPaginationParams`, `CursorPaginationParams`). [L1]
- Ensure `PaginationStrategy` is completely immutable and state-free, defining `getInitialParams({required int limit})` and `getNextParams({required List<T> currentItems, M? meta, String? nextCursor, required int limit})` (returning `null` when max is reached) as pure functions. [L1, L2]
- Enhance `PaginationResponseModel<T, M>` to include optional `String? nextCursor` and total count metadata support in `M`. [L1]
- Introduce `enum PaginationCachePolicy { networkOnly, cacheFirst, cacheAndNetwork }`. [L8]

### 2. Network Layer (`strata_network`)
- Generalize `PaginationParams` into a sealed class / union supporting `DefaultPaginationParams(int page, int limit)`, `SkipPaginationParams(int skip, int limit)`, and `CursorPaginationParams(String cursor, int limit)`. Provide an automatic `String get requestId` getter on `PaginationParams` for request keying (e.g. `default_page_1_limit_20` or `cursor_abc_limit_20`). [L1]
- Integrate request cancellation via `CancelRequestManagerInterface` using the automatic `requestId` per paginated query. [L5]

### 3. State Layer (`strata_state`)
- Define a sealed class `StrataPaginationState<T extends Identifiable, M extends MetaModel>` with distinct states:
  - `PaginationInitial`
  - `PaginationLoading` (initial fetch)
  - `PaginationSucceeded` (contains `paginatedResponseModel`, `hasReachedMax`, `isFromCache`, `isOffline`)
  - `PaginationRefreshing` (pull-to-refresh in flight while preserving existing items)
  - `PaginationLoadingMore` (incremental page fetch in flight)
  - `PaginationFailed` (initial fetch failure with `Failure failure`)
  - `PaginationPageFetchFailure` (page-N failure with `Failure failure`, preserving `paginatedResponseModel`, and providing `onRetryMore`) [L1, L6, L8]
- Refactor state management into `StrataPaginationBloc<T extends Identifiable, M extends MetaModel>` accepting `ResultFuture<PaginationResponseModel<T, M>> Function(PaginationParams params, {String? requestId})` and optional `String Function(PaginationParams params)? requestIdGenerator`:
  - Register event handlers with BLoC concurrency transformers: `droppable()` for `StrataPaginationMoreFetched` (prevents parallel requests during fast scrolling) and `restartable()` for `StrataPaginationInitialFetched` / `StrataPaginationFilterUpdated` (cancels in-flight requests via `CancelRequestManagerInterface`). [L2, L5]
  - Automatically generate request keys using `params.requestId` or `requestIdGenerator(params)`. [L5]
  - Automatically deduplicate items by `T.id` using $O(N)$ lookup keys when appending new pages. [L2]
  - Support optimistic local mutations (`StrataPaginationItemAdded`, `StrataPaginationItemUpdated`, `StrataPaginationItemDeleted`) with $O(1)$ / $O(N)$ efficiency. [L5]
  - Support pluggable caching via `PaginationCacheAdapterInterface` or `HydratedBloc` serialization. [L8]

### 4. UI Layer (`strata_ui`)
- Deprecate internal widget state fetching (`onFetchPage` in `StrataPaginationWidget`); require state to be driven by `StrataPaginationState` / `StrataPaginationBloc`. [L1]
- Remove `easy_refresh` dependency from `strata_ui/pubspec.yaml`. [L3]
- Implement native pull-to-refresh using `RefreshIndicator.adaptive` (or `CupertinoSliverRefreshControl` on iOS). [L3, L4]
- Implement infinite load-more using `NotificationListener<ScrollNotification>` with a configurable pixel scroll threshold (default: 200px). [L3]
- Support exactly one of 3 layout builders: `scrollableBuilder` (ListView/GridView), `sliversBuilder` (CustomScrollView), or `customBuilder` (Carousels/Tabs), enforcing mutual exclusivity in constructor assertions. [L4]
- Render full-screen `Skeletonizer` on initial load (`PaginationLoading`) and a bottom tile/spinner on incremental load (`PaginationLoadingMore`). [L6]
- Render a bottom inline retry bar on `PaginationPageFetchFailure` without hiding previously loaded items or resetting scroll position. [L6]
- Support desktop/web features: mouse wheel overscroll protection, `Ctrl+R` / `Cmd+R` refresh shortcut listeners, desktop `Scrollbar`, and window resize state retention. [L4]
- Display an offline/cached data badge or banner when `isFromCache` or `isOffline` is true. [L8]

### 5. Quality & Documentation Standard
- Provide 100% executable DartDoc documentation with `@example` code snippets for all public APIs across `strata_core`, `strata_network`, `strata_state`, and `strata_ui`. [L2, L7]
- Ensure zero sub-package boundary violations (verified by `package_dependency_test.dart`). [L7]

## Technical Decisions

1. **Sub-Package Distribution**:
   - `strata_core`: `PaginationStrategy`, `PaginationResponseModel`, `PaginationCachePolicy`. Pure Dart. No Flutter dependencies. [L1]
   - `strata_network`: `PaginationParams`, `CursorPaginationParams`, `CancelRequestManagerInterface` integration. [L1, L5]
   - `strata_state`: `StrataPaginationBloc`, `StrataPaginationEvent`, `StrataPaginationState`, `PaginationCacheAdapterInterface`. Depends on `strata_core`, `flutter_bloc`. [L1, L5]
   - `strata_ui`: `StrataPaginationWidget`, `StrataPaginationConfig`, native refresh & load-more mechanics. Depends on `strata_core`, `flutter`, `skeletonizer`. Zero dependency on `easy_refresh`. [L1, L3]
2. **Concurrency & Thread Safety**: BLoC event transformers (`restartable` for initial/filter, `droppable` for load-more) combined with Dio `CancelToken` cancellation and automatic `params.requestId` generation ensure zero race conditions or duplicate network calls. [L2, L5]
3. **$O(N)$ Deduplication**: Merging current and newly fetched pages uses `Set<String>` of `Identifiable.id` values, ensuring fast performance even with lists containing thousands of items. [L2]
4. **Native SDK Choice**: Dropping `easy_refresh` reduces binary size, eliminates third-party lifecycle bugs, and uses Flutter's maintained core `RefreshIndicator` and `ScrollNotification` listeners. [L3]

## Testing Strategy

1. **Unit Tests (`strata_core` & `strata_network`)**:
   - Test immutable parameter calculation for `PagePaginationStrategy`, `SkipPaginationStrategy`, and `CursorPaginationStrategy`.
   - Test serialization and JSON conversion for `PaginationParams` and automatic `requestId` getters.
2. **State & BLoC Tests (`strata_state`)**:
   - Use `bloc_test` to verify event-driven state transitions (`StrataPaginationInitialFetched` -> `loading` -> `succeeded` -> `StrataPaginationMoreFetched` -> `succeeded`).
   - Test concurrency protection: verify fast scroll `StrataPaginationMoreFetched` events are dropped while a fetch is in flight.
   - Test request cancellation on filter update (`StrataPaginationFilterUpdated`).
   - Test $O(N)$ item deduplication and optimistic mutations (`StrataPaginationItemAdded`, `StrataPaginationItemUpdated`, `StrataPaginationItemDeleted`).
3. **Package Boundary Verification**:
   - Run `package_dependency_test.dart` in `strata_core`, `strata_network`, `strata_state`, and `strata_ui` to ensure no illegal cross-package imports exist.
4. **Widget Tests (`strata_ui`)**:
   - Add deterministic keys: `Key('strata_pagination_list')`, `Key('strata_pagination_refresh_indicator')`, `Key('strata_pagination_bottom_loader')`, `Key('strata_pagination_retry_button')`.
   - Write native Flutter widget tests using `testWidgets` in `strata_ui`:
     - Test native pull-to-refresh trigger using `tester.fling` / `tester.drag`.
     - Test infinite scroll load-more trigger using `tester.scrollUntilVisible` / scroll notification.
     - Test page-N failure state rendering and tapping `strata_pagination_retry_button`.

## Out of Scope

- Wrapping or altering backend API schemas beyond standard Page/Skip/Cursor structures.
- Direct implementation of third-party offline databases (caching interface is provided; database implementations belong to host application or infrastructure packages).

## Follow-Ups

- After Spec approval, decompose into sub-package Work Items using `act-create-issues`.
- Implement `strata_core`, `strata_network`, `strata_state`, and `strata_ui` sequentially following sub-package boundary rules.

## Notes

- All changes must strictly follow the monorepo rules defined in `AGENTS.md` and domain terminology in `GLOSSARY.md`.
