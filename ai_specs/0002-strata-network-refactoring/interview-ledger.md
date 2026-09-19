---
type: Interview Ledger
parent: spec.md
---

## Records

### L1

Status: current

Question: How should we structure the `ApiRequestOptions` object and decouple multipart/form-data from Dio in `ApiHandlerInterface`?

Recommended Answer:
- Introduce an immutable `ApiRequestOptions` class containing `isAuthorized`, `shouldCache`, `enableRetry`, `maxRetryAttempts`, `retryDelay`, `requestId`, `headers`, `onSendProgress`, `onReceiveProgress`, `extra`.
- Refactor all `ApiHandlerInterface` methods (`get`, `post`, `put`, `patch`, `delete`, `download`) to accept `ApiRequestOptions? options`.
- Replace `FormDataAdapter` with framework-agnostic `NetworkFormData` and `NetworkFile` models, mapped internally to Dio `FormData` inside `DioApiHandler`.

Answer: yes sure but i also want to introduce optional headers in case i want to add custom headers like idempotency key or something to a single request

Decision: Simplify `ApiHandlerInterface` using `ApiRequestOptions` (including per-request `headers`) and `NetworkFormData`, fully encapsulating Dio types within `strata_network`.

### L2

Status: current

Question: Regarding the Clean Code and SOLID principles audit across all files in `strata_network`, are there any specific refactoring priorities or breaking changes you want included besides constructor syntax standardization and Dio encapsulation?

Recommended Answer:
- Standardize Dart primary constructors across `DioApiHandler`, `DefaultTokenManager`, and `DioExceptionMapper`.
- Verify contract interface naming conventions (`*Interface`) and audit exports in `lib/strata_network.dart` to ensure zero Dio type leaks.
- Extract multipart conversion and response parsing helpers in `DioApiHandler`.

Answer: yes i approve for all of the previous and also check this implementation from core...

Decision: Audit and refactor all files in `strata_network` for Clean Code, SOLID compliance, primary constructor standardization, and zero Dio package exports in `lib/strata_network.dart`.

### L3

Status: current

Question: How should we structure the complete Dio setup in `strata_network_di.dart` for all `NetworkConfigEntity` options and logging/auth dependencies?

Recommended Answer:
- Configure full `BaseOptions` with all `NetworkConfigEntity` properties (`baseUrl`, `connectTimeout`, `sendTimeout`, `receiveTimeout`, `staticHeaders`, `defaultQueryParams`, `defaultContentType`, `followRedirects`, `maxRedirects`, status validation).
- Attach complete interceptor pipeline: `LoggingInterceptor` (using `CoreLoggerInterface`), `RetryInterceptor`, custom interceptors, and auth interceptors (token-based or cookie-based).

Answer: yes great answer, and remove the custom dio from di no need for it, and make the error model parser required not optional, also for the onUnauthenticated function i don't think we need it here cause the app will initialize the strata framework before the run app function so i can't do anything right ? what do you think ?

Decision: Configure complete `BaseOptions` and interceptor pipeline in `registerStrataNetwork`, requiring `errorParser`, removing `customDio`, and removing `onUnauthenticated` from initial DI registration.

### L4

Status: current

Question: How should unauthenticated events (e.g. HTTP 401 when refresh token expires) be reported to the host application at runtime?

Recommended Answer:
- Expose `Stream<void> get unauthenticatedStream` on `TokenManagerInterface` for reactive runtime handling across Clean Architecture layers (`AuthRepository`, `WatchSessionExpirationUseCase`, `AuthBloc`).

Answer: that's great but what if i am using clean architecture ? how would this work?

Decision: Use a reactive `unauthenticatedStream` on `TokenManagerInterface` so `AuthRepository` (Data) can expose a domain event for `WatchSessionExpirationUseCase` (Domain) and `AuthBloc` (Presentation) to handle runtime redirects cleanly.

### L5

Status: current

Question: To bring `strata_network` up to full production-grade status, which of these additional refactorings should we include in the refactoring Spec?

Recommended Answer:
- Eliminate `GetIt` service locator calls inside `RetryInterceptor`, `TokenRefreshInterceptorInterface`, and `DioApiHandler`.
- Rename `NetworkStatusImp` to `InternetConnectionNetworkStatus` per `GLOSSARY.md`.
- Exponential backoff & jitter in `RetryInterceptor`.
- Cookie management integration via `dio_cookie_manager` & `cookie_jar`.
- Clean stream-based session expiration handling.

Answer: yes

Decision: Include all 5 production-grade refactoring items in the `strata_network` Spec.
