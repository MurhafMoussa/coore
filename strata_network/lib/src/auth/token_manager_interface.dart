/// Abstract contract for managing access and refresh authentication tokens.
abstract class TokenManagerInterface {
  /// Asynchronously retrieves the access token.
  Future<String> get accessToken;

  /// Asynchronously retrieves the refresh token.
  Future<String> get refreshToken;

  /// Sets in-memory and persistent access and refresh tokens.
  Future<void> setTokens({String? accessToken, String? refreshToken});

  /// Clears stored access and refresh tokens.
  Future<void> clearTokens();

  /// Optional callback invoked when authentication token refresh fails.
  void Function()? onUnauthenticated;

  /// Emits the unauthenticated event.
  void notifyUnauthenticated();
}
