---
type: Work Item
title: Decoupled Native StrataPaginationWidget & Multi-Platform UI
parent: ../spec.md
---

## What to build
Refactor `StrataPaginationWidget` in `strata_ui`, deprecating internal state fetching (`onFetchPage`) and removing the `easy_refresh` dependency from `pubspec.yaml`. Implement native pull-to-refresh using `RefreshIndicator.adaptive`, infinite scroll using `NotificationListener<ScrollNotification>` with configurable pixel threshold, and mutually exclusive layout builders (`scrollableBuilder`, `sliversBuilder`, `customBuilder`). Render full-screen `Skeletonizer` on initial load and bottom tile/spinner on load-more. Render inline bottom retry bar on `PaginationPageFetchFailure` without losing scroll position. Add desktop/web scrollbar, `Ctrl+R` / `Cmd+R` refresh shortcut listeners, offline data badges, 100% executable DartDoc, and native Flutter widget tests with deterministic keys.

## Required context
- Remove `easy_refresh` from `strata_ui/pubspec.yaml`.
- Deterministic keys required for widget testing: `Key('strata_pagination_list')`, `Key('strata_pagination_refresh_indicator')`, `Key('strata_pagination_bottom_loader')`, `Key('strata_pagination_retry_button')`.
- Mutual exclusivity assertion: exactly one of `scrollableBuilder`, `sliversBuilder`, or `customBuilder` must be provided.
- Platform support: adaptive refresh control, mouse wheel overscroll protection, desktop shortcut listeners (`Ctrl+R` / `Cmd+R`), desktop `Scrollbar`, and scroll offset preservation during window resize.

## Acceptance criteria
- [ ] `easy_refresh` package is completely removed from `strata_ui/pubspec.yaml` and code.
- [ ] Internal state fetching (`onFetchPage`) is deprecated/removed in favor of `StrataPaginationState` / BLoC driven UI.
- [ ] Native pull-to-refresh (`RefreshIndicator.adaptive`) and `NotificationListener<ScrollNotification>` infinite scroll threshold logic are implemented.
- [ ] Exactly one of `scrollableBuilder`, `sliversBuilder`, or `customBuilder` is enforced via constructor assertions.
- [ ] Full-screen `Skeletonizer` renders on initial load, and a bottom tile/spinner renders during load-more.
- [ ] Inline bottom retry bar renders on page-N fetch failure (`PaginationPageFetchFailure`) without resetting scroll offset.
- [ ] Desktop/web features (`Ctrl+R` / `Cmd+R` refresh shortcut, `Scrollbar`, resize state retention) are implemented.
- [ ] Offline/cached data banner/badge renders when `isFromCache` or `isOffline` is true.
- [ ] 100% executable DartDoc with `@example` snippets is provided for all public UI pagination classes.
- [ ] Native Flutter `testWidgets` tests in `strata_ui/test/` verify pull-to-refresh, infinite scroll, page-N retry, and key accessibility.

## Covers
- User Stories: 2, 3, 4, 5
- Requirements: 4, 5
- Testing Strategy: 3, 4
- Interview Ledger: L1, L2, L3, L4, L6, L7, L8

## Blocked by
1, 3
