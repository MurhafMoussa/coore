---
type: Work Item
title: Auth Lifecycle & Interceptors (Session Stream, Exponential Backoff Retry, Cookie Manager)
parent: ../spec.md
---

## What to build
Add `dio_cookie_manager` and `cookie_jar` to `pubspec.yaml`. Expose `Stream<void> get unauthenticatedStream` and `void notifyUnauthenticated()` on `TokenManagerInterface` and `DefaultTokenManager`. Pass optional `CookieJar` to `DefaultTokenManager` so `clearTokens()` clears session cookies. Upgrade `RetryInterceptor` with exponential backoff calculation (`retryInterval * 2^attempt`) and jitter. Pass `Dio` explicitly into `RetryInterceptor` and `TokenRefreshInterceptorInterface` constructors, removing `GetIt.instance` calls. Update `LoggingInterceptor` to log via `CoreLoggerInterface`.

## Required context
- `RetryInterceptor` backoff formula: delay = `retryInterval * 2^attempt` + randomized jitter.
- `TokenRefreshInterceptorInterface` constructor receives `Dio dio` directly to execute refresh HTTP requests and retry queued requests without `GetIt.instance`.
- `DefaultTokenManager` uses a broadcast `StreamController<void>` for `unauthenticatedStream`.

## Acceptance criteria
- [ ] `pubspec.yaml` includes `dio_cookie_manager` and `cookie_jar`.
- [ ] `TokenManagerInterface` exposes `unauthenticatedStream` and `notifyUnauthenticated()`.
- [ ] `DefaultTokenManager` implements `unauthenticatedStream` and clears `CookieJar` when present in `clearTokens()`.
- [ ] `RetryInterceptor` uses exponential backoff with jitter and receives `Dio` via constructor parameter without calling `GetIt`.
- [ ] `TokenRefreshInterceptorInterface` receives `Dio` via constructor parameter and executes refresh requests without calling `GetIt`.
- [ ] `LoggingInterceptor` receives `CoreLoggerInterface` in constructor.
- [ ] Unit tests for `RetryInterceptor` and `DefaultTokenManager` pass.

## Covers
- User Stories: 3, 4, 5
- Requirements: 8, 10, 13, 14, 15, 16, 17
- Testing Strategy: 2, 3
- Interview Ledger: L3, L4, L5

## Blocked by
None - ready to start
