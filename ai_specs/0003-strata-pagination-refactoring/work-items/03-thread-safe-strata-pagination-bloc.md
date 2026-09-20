---
type: Work Item
title: Thread-Safe StrataPaginationBloc, Concurrency & Sealed States
parent: ../spec.md
---

## What to build
Refactor state management in `strata_state` into `StrataPaginationBloc<T extends Identifiable, M extends MetaModel>` with sealed `StrataPaginationState` distinguishing initial loading/error (`PaginationLoading`, `PaginationFailed`) from page-N loading/error (`PaginationLoadingMore`, `PaginationPageFetchFailure`). Apply BLoC event concurrency transformers (`droppable` for load-more, `restartable` for initial/filter fetches). Implement $O(N)$ item deduplication by `T.id`, optimistic local mutations (`addFirst`, `addLast`, `update`, `delete`), and `PaginationCacheAdapterInterface` for pluggable offline persistence. Add 100% executable DartDoc and `bloc_test` unit tests.

## Required context
- `StrataPaginationState` sealed hierarchy: `PaginationInitial`, `PaginationLoading`, `PaginationSucceeded`, `PaginationRefreshing`, `PaginationLoadingMore`, `PaginationFailed`, `PaginationPageFetchFailure`.
- Event concurrency: `restartable()` for `StrataPaginationInitialFetched` and `StrataPaginationFilterUpdated` (cancels in-flight requests via `CancelRequestManagerInterface`), `droppable()` for `StrataPaginationMoreFetched` (prevents parallel requests during rapid scrolling).
- Deduplication: $O(N)$ lookup keys using `Set<String>` of `T.id`.
- Optimistic mutations: `addFirst`, `addLast`, `update`, `delete` operations maintain immutability and $O(N)$ lookup efficiency.

## Acceptance criteria
- [x] `StrataPaginationState` is a sealed class modeling initial vs page-N loading and failure states (`PaginationLoadingMore`, `PaginationPageFetchFailure`).
- [x] `StrataPaginationBloc` uses `droppable()` transformer for load-more and `restartable()` transformer for initial/filter fetch events.
- [x] Automatic item deduplication by `Identifiable.id` uses $O(N)$ set lookups during page appends.
- [x] In-flight requests are cancelled via `CancelRequestManagerInterface` when filter options or initial fetches trigger.
- [x] Optimistic mutations (`addFirst`, `addLast`, `update`, `delete`) update state efficiently without data corruption.
- [x] `PaginationCacheAdapterInterface` is defined for pluggable caching support (`isFromCache`, `isOffline`).
- [x] 100% executable DartDoc documentation with `@example` code snippets for all state layer public contracts.
- [x] Comprehensive `bloc_test` suite in `strata_state/test/` verifies all state transitions, concurrency dropping, cancellation, deduplication, and optimistic mutations.

## Covers
- User Stories: 1, 4, 5
- Requirements: 3, 5
- Testing Strategy: 2, 3
- Interview Ledger: L1, L2, L5, L6, L7, L8

## Blocked by
1, 2
