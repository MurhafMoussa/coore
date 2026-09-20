---
type: Work Item
title: Generalized Sealed PaginationParams & Cancellation Integration
parent: ../spec.md
---

## What to build
Generalize `PaginationParams` in `strata_network` into a sealed class / union supporting `DefaultPaginationParams(int page, int limit)`, `SkipPaginationParams(int skip, int limit)`, and `CursorPaginationParams(String cursor, int limit)`. Provide an automatic `String get requestId` getter on `PaginationParams` for request keying (e.g. `default_page_1_limit_20` or `cursor_abc_limit_20`). Integrate request cancellation via `CancelRequestManagerInterface` using automatic `requestId` per paginated query. Add 100% executable DartDoc and unit tests.

## Required context
- `PaginationParams` should be a sealed class hierarchy or equatable value objects supporting JSON serialization (`toJson`, `fromJson`).
- Automatic `requestId` getter format: `default_page_<page>_limit_<limit>`, `skip_<skip>_limit_<limit>`, `cursor_<cursor>_limit_<limit>`.
- Request cancellation uses `CancelRequestManagerInterface` with `params.requestId`.

## Acceptance criteria
- [ ] `PaginationParams` is refactored into a sealed hierarchy (`DefaultPaginationParams`, `SkipPaginationParams`, `CursorPaginationParams`).
- [ ] Every `PaginationParams` instance provides an automatic `requestId` string getter.
- [ ] `CancelRequestManagerInterface` integration handles request cancellation keying using `requestId`.
- [ ] 100% executable DartDoc documentation with `@example` code snippets is provided for all public network pagination classes.
- [ ] Unit tests in `strata_network/test/` verify serialization, `requestId` generation, and cancellation manager behavior.

## Covers
- User Stories: 1, 5
- Requirements: 2, 5
- Testing Strategy: 1, 3
- Interview Ledger: L1, L2, L5, L7

## Blocked by
1
