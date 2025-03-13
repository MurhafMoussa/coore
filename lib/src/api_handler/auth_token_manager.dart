import 'package:coore/lib.dart';

class AuthTokenManager {
  AuthTokenManager(
    this._secureDatabaseInterface, {
    this.secureStorageEnabled = false,
  });

  final SecureDatabaseInterface _secureDatabaseInterface;
  String? _accessToken;
  String? _refreshToken;
  final bool secureStorageEnabled;

  /// Retrieves the access token.
  ///
  /// If secure storage is enabled, first checks if the token is already available
  /// in memory. If not, it reads the token from secure storage. In case of a failure
  /// (or an empty value), it returns an empty string.
  Future<String> get accessToken async {
    if (secureStorageEnabled) {
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        return _accessToken!;
      }
      final tokenFromStorage = await _secureDatabaseInterface.read(
        'accessToken',
      );
      return tokenFromStorage.fold(
        (failure) => '', // On failure, return an empty string.
        (token) {
          _accessToken = token;
          return token ?? '';
        },
      );
    }
    return _accessToken ?? '';
  }

  /// Retrieves the refresh token.
  ///
  /// If secure storage is enabled, first checks if the token is already available
  /// in memory. If not, it reads the token from secure storage. In case of a failure
  /// (or an empty value), it returns an empty string.
  Future<String> get refreshToken async {
    if (secureStorageEnabled) {
      if (_refreshToken != null && _refreshToken!.isNotEmpty) {
        return _refreshToken!;
      }
      final tokenFromStorage = await _secureDatabaseInterface.read(
        'refreshToken',
      );
      return tokenFromStorage.fold(
        (failure) => '', // On failure, return an empty string.
        (token) {
          _refreshToken = token;
          return token ?? '';
        },
      );
    }
    return _refreshToken ?? '';
  }

  /// Sets the tokens in memory and, if secure storage is enabled, persists them.
  Future<void> setTokens({String? accessToken, String? refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    if (secureStorageEnabled) {
      if (accessToken != null && accessToken.isNotEmpty) {
        // Persist the access token.
        await _secureDatabaseInterface.write('accessToken', accessToken);
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        // Persist the refresh token.
        await _secureDatabaseInterface.write('refreshToken', refreshToken);
      }
    }
  }

  /// Clears tokens from memory and secure storage (if enabled).
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;

    if (secureStorageEnabled) {
      // Remove tokens from secure storage.
      await _secureDatabaseInterface.delete('accessToken');
      await _secureDatabaseInterface.delete('refreshToken');
    }
  }
}
