# Strata Storage (`strata_storage`)

Infrastructure adapters, secure sensitive key-value storage (`FlutterSecureSensitiveStorage`), encryption key generation & rotation utilities, and database setup helpers for the Strata framework.

## Features

- **`FlutterSecureSensitiveStorage`**: Implements `SensitiveStorageInterface` from `strata_core` wrapping `FlutterSecureStorage` with type-safe `ResultFuture<T>` error handling.
- **`StorageEncryptionKeyHelper`**: Manages secure encryption key generation, retrieval, and key rotation stored in sensitive storage.
- **`StorageDirectoryHelper`**: Helps resolve cross-platform storage directories for native database engines (Drift, Hive, Isar).
- **`StrataStorageDiExtension`**: GetIt extension (`registerStrataStorage()`) for dependency injection.

## Dependency Boundaries

Depends ONLY on:
- `strata_core`
- `flutter`
- `flutter_secure_storage`
- `path_provider`
- `get_it`
- `fpdart`

Does NOT depend on `flutter_bloc`, `go_router`, or `dio`.
Does NOT wrap native database APIs behind generic CRUD abstractions.
