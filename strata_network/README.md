# strata_network

Dio HTTP client wrapper, token lifecycle management, and request cancellation manager for Strata framework.

## Features
- `ApiHandlerInterface` & `DioApiHandler`: Functional HTTP client returning `ResultFuture<T>`.
- `TokenRefreshInterceptorInterface`: Token refresh logic clearing tokens and emitting `onUnauthenticated` callback on 400/401 failure.
- `CancelRequestManagerInterface` & `DefaultCancelRequestManager`: Multi-token concurrent request cancellation tracking.
- `TokenManagerInterface` & `DefaultTokenManager`: Token persistence backed by `SensitiveStorageInterface`.
- `StrataNetworkDiExtension`: GetIt registration for `strata_network`.
