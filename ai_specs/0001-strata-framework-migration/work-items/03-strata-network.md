---
type: Work Item
title: Create strata_network HTTP client and token lifecycle package
parent: ../spec.md
---

## What to build
Implement `strata_network` containing `ApiHandlerInterface`, `DioApiHandler`, `TokenRefreshInterceptorInterface` (with `BearerTokenRefreshInterceptor` and `CookieTokenRefreshInterceptor`), `TokenManagerInterface`, `DefaultTokenManager`, `CancelRequestManagerInterface`, and `DefaultCancelRequestManager`. Fix token refresh failure cleanup and concurrent request cancellation tracking.

## Required context
- `TokenRefreshInterceptorInterface` MUST explicitly call `_tokenManager.clearTokens()` on refresh failure and emit `onUnauthenticated` callback before rejecting queued requests.
- `DefaultCancelRequestManager` MUST track active cancel tokens in `Map<String, Set<CancelToken>>`:
  - `CancelToken registerRequest(String requestId)` (creates, stores, and returns distinct token)
  - `void cancelToken(CancelToken token, {String? reason})` (cancels specific token)
  - `void cancelRequest(String requestId, {String? reason})` (cancels all tokens for key)
  - `void unregisterToken(String requestId, CancelToken token)` (removes specific token)

## Acceptance criteria
- [ ] `strata_network` sub-package is created depending on `strata_core` and `dio`.
- [ ] `TokenRefreshInterceptorInterface` clears tokens and emits `onUnauthenticated` on 400/401 refresh failure.
- [ ] `DefaultCancelRequestManager` supports concurrent requests under identical `requestId` without overwriting active tokens.
- [ ] Unit tests for `TokenRefreshInterceptorInterface` pass for HTTP 400/401 refresh scenarios.
- [ ] Unit tests for `DefaultCancelRequestManager` confirm independent token registration, cancellation, and unregistration.

## Covers
- User Stories: 1, 3, 4
- Requirements: 1, 2, 3, 4, 8, 9
- Testing Strategy: 2
- Interview Ledger: L3, L5, L6

## Blocked by
01-strata-core.md
