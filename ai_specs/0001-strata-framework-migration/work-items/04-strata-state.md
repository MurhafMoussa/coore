---
type: Work Item
title: Create strata_state BLoC lifecycle management package
parent: ../spec.md
---

## What to build
Implement `strata_state` containing `ApiStateHostMixin`, `DisposableApiStateHandlerInterface`, `ApiStateHandler`, and `ApiStateBuilder`. Enhance `ApiStateHandler.handleApiCall` with `force: bool = false` override to allow execution during loading states and log diagnostic warnings via `CoreLoggerInterface` when duplicate requests are skipped.

## Required context
- Depends on `strata_core` and `flutter_bloc`.
- Replaces legacy `IApiStateHandler` with `DisposableApiStateHandlerInterface` adhering to naming rules (no `I*` prefix).
- `handleApiCall(force: true)` executes API call even if `currentState.isLoading` is true.
- `handleApiCall(force: false)` when `currentState.isLoading` is true logs diagnostic warning via `CoreLoggerInterface`.

## Acceptance criteria
- [x] `strata_state` sub-package is created depending on `strata_core` and `flutter_bloc`.
- [x] `DisposableApiStateHandlerInterface` replaces legacy `IApiStateHandler`.
- [x] `handleApiCall` accepts `force: bool = false`.
- [x] `force: true` executes API calls during `isLoading` state.
- [x] `force: false` logs diagnostic warning during `isLoading` state instead of silently swallowing calls.
- [x] Unit tests for `handleApiCall(force: true)` and `handleApiCall(force: false)` pass with 100% coverage.

## Covers
- User Stories: 1, 5
- Requirements: 1, 2, 4, 13, 14, 15
- Testing Strategy: 3
- Interview Ledger: L8, L11

## Blocked by
01-strata-core.md
03-strata-network.md
