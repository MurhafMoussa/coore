import 'package:strata_core/strata_core.dart';
import 'token_manager_interface.dart';

/// Default implementation of [TokenManagerInterface] backed by optional [SensitiveStorageInterface].
class DefaultTokenManager implements TokenManagerInterface {
  DefaultTokenManager({
    SensitiveStorageInterface? sensitiveStorage,
    this.secureStorageEnabled = false,
    this.onUnauthenticated,
  }) : _sensitiveStorage = sensitiveStorage;

  final SensitiveStorageInterface? _sensitiveStorage;
  final bool secureStorageEnabled;
  String? _accessToken;
  String? _refreshToken;

  @override
  void Function()? onUnauthenticated;

  @override
  void notifyUnauthenticated() {
    onUnauthenticated?.call();
  }

  @override
  Future<String> get accessToken async {
    final storage = _sensitiveStorage;
    if (secureStorageEnabled && storage != null) {
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        return _accessToken!;
      }
      final result = await storage.read('accessToken');
      return result.fold(
        (failure) => '',
        (String? token) {
          _accessToken = token;
          return token ?? '';
        },
      );
    }
    return _accessToken ?? '';
  }

  @override
  Future<String> get refreshToken async {
    final storage = _sensitiveStorage;
    if (secureStorageEnabled && storage != null) {
      if (_refreshToken != null && _refreshToken!.isNotEmpty) {
        return _refreshToken!;
      }
      final result = await storage.read('refreshToken');
      return result.fold(
        (failure) => '',
        (String? token) {
          _refreshToken = token;
          return token ?? '';
        },
      );
    }
    return _refreshToken ?? '';
  }

  @override
  Future<void> setTokens({String? accessToken, String? refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    final storage = _sensitiveStorage;
    if (secureStorageEnabled && storage != null) {
      if (accessToken != null && accessToken.isNotEmpty) {
        await storage.save('accessToken', accessToken);
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await storage.save('refreshToken', refreshToken);
      }
    }
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;

    final storage = _sensitiveStorage;
    if (secureStorageEnabled && storage != null) {
      await storage.delete('accessToken');
      await storage.delete('refreshToken');
    }
  }
}
