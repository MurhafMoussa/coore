---
type: Interview Ledger
parent: spec.md
---

## Records

### L1

Status: current

Question: What should be the primary scope for elevating pagination to an enterprise production-grade standard across `strata_core`, `strata_state`, `strata_network`, and `strata_ui`?

Recommended Answer:
- **Domain Layer (`strata_core`)**: Refactor `PaginationStrategy` into pure, immutable value types supporting Page/Offset, Skip/Limit, and Cursor/Keyset strategies.
- **Network Layer (`strata_network`)**: Generalize `PaginationParams` to support string cursors and dynamic query parameters.
- **State Layer (`strata_state`)**: Refactor `StrataPaginationState` to explicitly model `isLoadingMore`, `isRefreshing`, and `pageFetchFailure`. Enforce concurrency protection via `StrataPaginationBloc` (using `droppable` / `restartable` event transformers) and deduplicate items automatically by `Identifiable.id`.
- **UI Layer (`strata_ui`)**: Deprecate internal widget state fetching (`onFetchPage`); require state to be driven strictly via `StrataPaginationState` / BLoC or a standard state adapter. Add a dedicated footer error/retry widget when loading additional pages fails.

Answer: act-create-spec

Decision: Perform a unified multi-package refactoring of pagination across `strata_core`, `strata_network`, `strata_state`, and `strata_ui`.

### L2

Status: current

Question: How do we strictly enforce Clean Code, Performance, and Code Documentation throughout the pagination design?

Answer:
- **Clean Code**: Enforce single source of truth (zero state duplication between widget and cubit), pure immutable strategy objects, and sub-package boundary isolation.
- **Performance**: Use $O(N)$ item deduplication via `Identifiable.id`, concurrency droppable/throttled event transformers to discard duplicate scroll requests, and fine-grained state rebuilds.
- **Code Documentation**: Mandate 100% executable DartDoc documentation with `@example` blocks for all public contracts across the 4 packages.

Decision: Primary quality pillars are clean architecture isolation, $O(N)$ performance with concurrency guards, and 100% executable DartDoc coverage.

### L3

Status: current

Question: How should `StrataPaginationWidget` implement pull-to-refresh and infinite load-more natively using standard Flutter SDK components (removing `easy_refresh`), and what native widget test patterns should we establish?

Recommended Answer:
- **Native Flutter Pull-to-Refresh & Infinite Scroll**:
  - Pull-to-Refresh: Wrap scrollable in `RefreshIndicator.adaptive` (or `CupertinoSliverRefreshControl`).
  - Infinite Load-More: Wrap scrollable in `NotificationListener<ScrollNotification>` triggering `onLoadMore` when reaching threshold.
  - Footer State Widget: Append bottom sliver rendering `isLoadingMore` spinner, `isMoreFailure` inline retry bar, or `hasReachedMax` end footer.
  - Remove Dependency: Remove `easy_refresh: ^3.4.0` from `strata_ui/pubspec.yaml`.
- **Widget Test Architecture**: Add deterministic keys (`strata_pagination_list`, `strata_pagination_refresh_indicator`, `strata_pagination_bottom_loader`, `strata_pagination_retry_button`) and write native Flutter `testWidgets` tests for pull-to-refresh, infinite scroll, and bottom retry.

Answer: great answer

Decision: Replace `easy_refresh` with native Flutter `RefreshIndicator.adaptive` and `NotificationListener<ScrollNotification>`, and add native Flutter widget tests for refresh, load-more, and retry states.

### L4

Status: current

Question: How should the pagination architecture support diverse layout formats (Lists, Grids, Slivers, Carousels) and multi-platform experiences (iOS, Android, Web, Desktop)?

Recommended Answer:
- **Adaptive Scroll & Refresh Mechanics (`strata_ui`)**: Use platform-adaptive pull-to-refresh, mouse wheel overscroll protection, keyboard shortcut listeners (`Ctrl+R` / `F5` / `Cmd+R`), desktop `Scrollbar`, and preserve scroll offset / state during desktop window resize or orientation changes.
- **Layout Agnostic Builders (`strata_ui`)**: Support `scrollableBuilder` (lists/grids), `sliversBuilder` (sliver scroll views), and `customBuilder` (carousels/tabs).
- **Screen State Independence (`strata_state`)**: Keep `StrataPaginationBloc` completely decoupled from UI layout mechanics.

Answer: keep in mind that we are designing for multiple screens and multiple platforms / great answer

Decision: Provide layout-agnostic builders and platform-adaptive UI mechanics while keeping `StrataPaginationBloc` decoupled from rendering logic.

### L5

Status: current

Question: How should `StrataPaginationBloc` handle cancellation, state cleanup, and request prioritization when search query parameters or filter options change or when refresh is triggered while load-more is in flight?

Recommended Answer:
- **CancelToken Integration**: Integrate `CancelRequestManagerInterface` from `strata_network`. Cancel in-flight load-more requests when initial fetch or filter update occurs.
- **Event Concurrency Transformers**: Use `restartable()` for initial/filter fetches and `droppable()` for infinite scroll `fetchMoreData()`.
- **Optimistic Local Mutations**: Support `addLast`, `addFirst`, `update`, `delete` using immutable copies and $O(N)$ ID lookups.

Answer: great answer

Decision: Use request cancellation via `CancelRequestManagerInterface`, `restartable()` / `droppable()` BLoC transformers, and $O(N)$ optimistic local mutation lookups.

### L6

Status: current

Question: How should `strata_ui` and `strata_state` differentiate initial loading/error states from page-N loading/error states, and how should `Skeletonizer` be handled cleanly?

Recommended Answer:
- **Sealed State Error Separation (`strata_state`)**: Define `PaginationFailed` for initial fetch failure and `PaginationPageFetchFailure` for page-N failure (preserving previously loaded items and providing `onRetryMore`).
- **Granular Skeletonizer (`strata_ui`)**: Render full-screen `Skeletonizer` only on initial load (`isInitialLoading`). Render a subtle bottom skeleton tile or progress indicator on incremental page load (`isLoadingMore`).
- **Page-N Retry UX**: Render inline bottom retry bar on page-N error without losing scroll position or visible items.

Answer: great answer

Decision: Separate initial and page-N loading/error states in `StrataPaginationState`, using full-screen `Skeletonizer` for initial loading and bottom inline retry footer for page-N errors.

### L7

Status: current

Question: How should code documentation, package exports, and automated verification be enforced across the monorepo?

Recommended Answer:
- **100% Executable DartDoc Standard**: Document all public contracts across `strata_core`, `strata_network`, `strata_state`, `strata_ui` with `@example` code snippets.
- **Strict Export Boundaries**: Export clean public APIs through barrel files, maintaining zero layer leaks, verified by `package_dependency_test.dart`.
- **Verification Suite**: Unit tests (`strata_core` & `strata_network`), `bloc_test` for BLoC state transitions, and native Flutter widget tests for UI.

Answer: great answer

Decision: Enforce 100% executable DartDoc coverage, strict barrel file exports, package boundary audit tests, and native Flutter widget tests.

### L8

Status: current

Question: How should the pagination suite support offline access and response caching?

Recommended Answer:
- **Cache Policy Enum (`strata_core`)**: Define `PaginationCachePolicy` (`networkOnly`, `cacheFirst`, `cacheAndNetwork`).
- **Persistence Strategy (`strata_state`)**: Support `HydratedBloc` / `PaginationCacheAdapterInterface` keyed by query parameters.
- **Offline UI Indicators (`strata_ui`)**: Expose `isFromCache` and `isOffline` flags on state and render non-intrusive offline UI indicators.

Answer: great answer, also should we add the ability to enable caching ? / great answer

Decision: Add `PaginationCachePolicy` enum in `strata_core`, pluggable caching support in `strata_state`, and offline/cached state indicators in `strata_ui`.
