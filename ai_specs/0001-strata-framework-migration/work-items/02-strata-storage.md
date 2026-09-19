---
type: Work Item
title: Create strata_storage secure persistence package
parent: ../spec.md
---

## What to build
Implement `strata_storage` sub-package providing `FlutterSecureSensitiveStorage` implementing `SensitiveStorageInterface` using `flutter_secure_storage`, alongside security/encryption key utilities and engine initialization helpers (Hive/Drift path and box setup) without wrapping native database APIs behind generic CRUD abstractions.

## Required context
- Depends on `strata_core` and `flutter_secure_storage`.
- Must NOT expose `NoSqlDatabaseInterface` or wrap database CRUD operations. App features retain direct native database access.

## Acceptance criteria
- [x] `strata_storage` sub-package is created.
- [x] `FlutterSecureSensitiveStorage` implements `SensitiveStorageInterface` with error handling converting exceptions to `StorageFailure`.
- [x] Key rotation and path/box setup helpers are provided without hiding database drivers.
- [x] Unit and integration tests verify `FlutterSecureSensitiveStorage` read, save, delete, deleteAll, and containsKey behavior.

## Covers
- User Stories: 2
- Requirements: 1, 6, 7
- Testing Strategy: 1
- Interview Ledger: L1, L2, L3, L4

## Blocked by
01-strata-core.md
