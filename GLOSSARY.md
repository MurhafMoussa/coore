# Strata Framework Terminology

Canonical domain terminology for the Strata Flutter monorepo architecture.

## Terminology

**Strata**:
The modular, multi-package Flutter/Dart framework suite replacing the monolithic coore package.
_Avoid_: coore v2, coore_monorepo

**Strata Storage**:
The infrastructure package (`strata_storage`) responsible for token persistence contracts, secure key management, and database setup helpers without wrapping native database APIs.
_Avoid_: NoSqlDatabaseInterface, LocalDatabaseWrapper

**SensitiveStorageInterface**:
The focused key-value abstract interface in `strata_core` specifically designed for reading, saving, deleting, and clearing encrypted string data (auth tokens, API keys).
_Avoid_: SensitiveStorageContract, SecureDatabaseInterface, LocalStorageContract

**Interface Naming Convention**:
All abstract contracts/interfaces use the `Interface` suffix (e.g. `SensitiveStorageInterface`). Concrete implementations prepend the technology/driver name as a prefix before the base name (e.g. `FlutterSecureSensitiveStorage` or `DioApiHandler`).
_Avoid_: `*Contract`, `*Impl` suffix, `I*` prefix

**CancelRequestManagerInterface**:
The network management interface in `strata_network` that tracks and manages Dio `CancelToken` instances for concurrent and cancellable HTTP requests.
_Avoid_: CancelRequestManagerImpl

**TokenManagerInterface**:
The token lifecycle interface in `strata_network` responsible for storing, retrieving, refreshing, and clearing authentication tokens across network requests.
_Avoid_: AuthTokenManager

**ApiState**:
The pure functional union state representation in `strata_core` representing `initial`, `loading`, `success(T data)`, and `failure(Failure failure)` independent of any state management library.
_Avoid_: CoreState, BlocApiState

**ApiStateHandler**:
The composite delegate in `strata_state` managing loading/success/failure/retry lifecycles for an `ApiState` field within a BLoC/Cubit state.
_Avoid_: ApiStateController

**DisposableApiStateHandlerInterface**:
The contract in `strata_state` implemented by `ApiStateHandler` for managing disposable state delegates within BLoC/Cubit state hosts without using the legacy `IApiStateHandler` name.
_Avoid_: IApiStateHandler, ApiStateHandlerInterface

**ApiRequestOptions**:
The immutable configuration class in `strata_network` passed to `ApiHandlerInterface` containing per-request headers, retry options, authorization flags, and progress callbacks.
_Avoid_: RequestOptions, DioOptions, NetworkRequestOptions

**NetworkFormData**:
The framework-agnostic multipart data structure in `strata_network` encapsulating form fields and `NetworkFile` instances without leaking Dio types to host applications.
_Avoid_: FormDataAdapter, DioFormData
