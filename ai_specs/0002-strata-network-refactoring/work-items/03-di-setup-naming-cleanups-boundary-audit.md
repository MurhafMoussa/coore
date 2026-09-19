---
type: Work Item
title: Dependency Injection (registerStrataNetwork), Naming Cleanups, & Boundary Audit
parent: ../spec.md
---

## What to build
Refactor `registerStrataNetwork` in `strata_network_di.dart` to populate full `BaseOptions`, attach all interceptors (cookie manager when cookie auth active, logging interceptor resolving `CoreLoggerInterface`, retry, token refresh), require `ErrorModelParser errorParser`, and omit `customDio` and `onUnauthenticated`. Rename `NetworkStatusImp` to `InternetConnectionNetworkStatus` (and update test file). Audit `lib/strata_network.dart` for zero Dio re-exports, update `strata_network/README.md` documentation to reflect all new refactored APIs and DI setup, and run full package dependency boundary tests.

## Required context
- `registerStrataNetwork` signature: `void registerStrataNetwork({required NetworkConfigEntity config, required ErrorModelParser errorParser})`.
- `BaseOptions` configured with `baseUrl`, `connectTimeout`, `sendTimeout`, `receiveTimeout`, `headers` (staticHeaders), `queryParameters` (defaultQueryParams), `contentType` (defaultContentType), `followRedirects`, `maxRedirects`, `validateStatus: (status) => status != null && status >= 200 && status < 300`.
- Rename `lib/src/network_status/network_status_imp.dart` -> `internet_connection_network_status.dart`.
- Rename `test/network_status/network_status_imp_test.dart` -> `internet_connection_network_status_test.dart`.
- Update `strata_network/README.md` code examples for `ApiRequestOptions`, `NetworkFormData`, `unauthenticatedStream`, `InternetConnectionNetworkStatus`, and `registerStrataNetwork`.

## Acceptance criteria
- [ ] `registerStrataNetwork` populates all `BaseOptions` fields from `NetworkConfigEntity`.
- [ ] `registerStrataNetwork` registers `CookieJar` in `GetIt` and attaches `CookieManager` when `authInterceptorType == AuthInterceptorType.cookieBased`.
- [ ] `registerStrataNetwork` requires `errorParser` and omits `customDio` and `onUnauthenticated`.
- [ ] `NetworkStatusImp` is renamed to `InternetConnectionNetworkStatus` and exported cleanly.
- [ ] `lib/strata_network.dart` exports zero Dio types (`Dio`, `FormData`, `Options`, `CancelToken`, `DioException`, `Interceptor`).
- [ ] `strata_network/README.md` is updated with code examples reflecting `ApiRequestOptions`, `NetworkFormData`, `unauthenticatedStream`, and `registerStrataNetwork`.
- [ ] All unit tests (`dio_api_handler_test`, `retry_interceptor_test`, `default_token_manager_test`, `strata_network_di_test`, `internet_connection_network_status_test`) and `package_dependency_test.dart` pass.

## Covers
- User Stories: 4
- Requirements: 7, 8, 9, 11, 12, 13, 14
- Testing Strategy: 1, 2, 3, 4, 5
- Interview Ledger: L2, L3, L5

## Blocked by
- 01-core-data-models-handler-abstraction.md
- 02-auth-lifecycle-interceptors.md
