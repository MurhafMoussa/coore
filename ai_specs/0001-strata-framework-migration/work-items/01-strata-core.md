---
type: Work Item
title: Create strata_core pure Dart domain package
parent: ../spec.md
---

## What to build
Implement the zero-dependency `strata_core` sub-package containing domain entities, failure hierarchy (`StorageFailure`, `ServerFailure`, `UnauthorizedFailure`, `BusinessFailure`, `UnknownFailure`), `ResultFuture<T>` typedefs, `CoreLoggerInterface`, pure functional `ApiState<T>`, and `SensitiveStorageInterface`.

## Required context
- `SensitiveStorageInterface` must be defined in `strata_core/lib/src/storage/sensitive_storage_interface.dart`.
- Method signatures: `read(String key)`, `save(String key, String value)`, `delete(String key)`, `deleteAll()`, `containsKey(String key)` returning `ResultFuture<T>` types resolving to `StorageFailure` on error.
- Must NOT depend on `flutter`, `dio`, `hive`, `flutter_bloc`, or `go_router`.

## Acceptance criteria
- [x] `strata_core` sub-package is created with a clean `pubspec.yaml`.
- [x] Pure functional `ApiState<T>` (initial, loading, success, failure) is located in `strata_core`.
- [x] `SensitiveStorageInterface` is defined with type-safe `ResultFuture<T>` return types.
- [x] Domain failure hierarchy including `StorageFailure` is defined in `strata_core`.
- [x] Unit tests for `ApiState` and failure classes pass with 100% coverage.
- [x] Package dependency check confirms zero dependencies on `flutter`, `dio`, or UI packages.

## Covers
- User Stories: 1, 2
- Requirements: 1, 5, 7
- Testing Strategy: 1, 5
- Interview Ledger: L1, L2, L3, L4, L8

## Blocked by
None - ready to start
