---
type: Work Item
title: Pure Immutable Domain Pagination Strategy & Cache Policy
parent: ../spec.md
---

## What to build
Refactor `PaginationStrategy<P>` in `strata_core` into pure, state-free value types supporting `PagePaginationStrategy`, `SkipPaginationStrategy`, and `CursorPaginationStrategy`. Extend `PaginationResponseModel<T, M>` to support `String? nextCursor` and total count metadata in `M`. Introduce `PaginationCachePolicy` (`networkOnly`, `cacheFirst`, `cacheAndNetwork`). Add 100% executable DartDoc `@example` snippets and comprehensive unit tests.

## Required context
- `PaginationStrategy<P extends PaginationParams>` must be state-free and define `getInitialParams({required int limit})` and `getNextParams({required List<T> currentItems, M? meta, String? nextCursor, required int limit})` (returning `null` when max is reached) as pure functions.
- `PaginationResponseModel<T, M>` should include `final String? nextCursor` with constructor, `copyWith`, and `fromJson` support.
- Zero Flutter/UI dependencies in `strata_core`.

## Acceptance criteria
- [x] `PaginationStrategy<P>` interface and `PagePaginationStrategy`, `SkipPaginationStrategy`, and `CursorPaginationStrategy` implementations are pure, state-free value types.
- [x] `PaginationResponseModel<T, M>` includes `nextCursor` field and supports cursor extraction in `fromJson` / `copyWith`.
- [x] `PaginationCachePolicy` enum (`networkOnly`, `cacheFirst`, `cacheAndNetwork`) is defined in `strata_core`.
- [x] 100% executable DartDoc documentation with `@example` code snippets is provided for all public pagination domain contracts.
- [x] Comprehensive unit tests in `strata_core/test/pagination/` cover strategy calculations, model copy/deserialization, and boundary compliance (`package_dependency_test.dart`).

## Covers
- User Stories: 1, 5
- Requirements: 1, 5
- Testing Strategy: 1, 3
- Interview Ledger: L1, L2, L7, L8

## Blocked by
None - ready to start
