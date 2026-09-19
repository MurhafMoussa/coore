---
type: Work Item
title: Core Data Models & Handler Abstraction (ApiRequestOptions, NetworkFormData, DioApiHandler)
parent: ../spec.md
---

## What to build
Create immutable data models `ApiRequestOptions`, `NetworkFormData`, and `NetworkFile`. Deprecate `FormDataAdapter`. Refactor `ApiHandlerInterface` method signatures (`get`, `post`, `put`, `patch`, `delete`, `download`) to accept `ApiRequestOptions? options`. Refactor `DioApiHandler` to convert `NetworkFormData` to Dio `FormData` internally and eliminate runtime `GetIt` calls for `CancelRequestManagerInterface`.

## Required context
- `ApiRequestOptions` fields: `isAuthorized`, `shouldCache`, `enableRetry`, `maxRetryAttempts`, `retryDelay`, `requestId`, `headers`, `onSendProgress`, `onReceiveProgress`, `extra`.
- `NetworkFormData` fields: `Map<String, dynamic> fields`, `List<NetworkFile> files`.
- `NetworkFile` fields: `fieldName`, `filePath`, optional `filename`, `contentType`.
- `DioApiHandler` constructor MUST require `Dio`, `NetworkExceptionMapperInterface`, and `CancelRequestManagerInterface`, removing `GetIt.instance` fallbacks.

## Acceptance criteria
- [x] `ApiRequestOptions` model is implemented as an immutable value class with default values (`isAuthorized: false`, `shouldCache: false`, `enableRetry: true`).
- [x] `NetworkFormData` and `NetworkFile` models encapsulate form data fields and file attachments.
- [x] `FormDataAdapter` is replaced by `NetworkFormData` in `ApiHandlerInterface` and `DioApiHandler`.
- [x] `ApiHandlerInterface` methods (`get`, `post`, `put`, `patch`, `delete`, `download`) accept `ApiRequestOptions? options`.
- [x] `DioApiHandler` converts `NetworkFormData` to Dio `FormData` without leaking Dio types.
- [x] `DioApiHandler` requires `CancelRequestManagerInterface` in its constructor and contains zero runtime `GetIt` calls.
- [x] Unit tests for `DioApiHandler` pass, verifying request option application and form data conversion.

## Covers
- User Stories: 1, 2, 4
- Requirements: 1, 2, 3, 4, 5, 6, 7, 8, 10
- Testing Strategy: 1, 5
- Interview Ledger: L1, L2, L5

## Blocked by
None - ready to start
