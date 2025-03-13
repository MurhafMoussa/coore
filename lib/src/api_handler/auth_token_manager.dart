class AuthTokenManager {
  AuthTokenManager();

  String? _accessToken;
  String? _refreshToken;

  String get accessToken => _accessToken ?? '';
  String get refreshToken => _refreshToken ?? '';

  Future<void> setTokens({String? accessToken, String? refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }
}
