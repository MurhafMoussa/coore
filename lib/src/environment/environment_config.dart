import 'package:flutter_dotenv/flutter_dotenv.dart';

enum CoreEnvironment {
  development,
  staging,
  uat,
  production;

  static CoreEnvironment getEnvironmentFromString(String env) {
    return CoreEnvironment.values.firstWhere(
      (element) => element.name == env,
      orElse: () => CoreEnvironment.development,
    );
  }
}

class EnvironmentConfig {
  /// Load the .env file and optionally merge with additional environment variables.
  Future<void> loadEnv(
    CoreEnvironment environment, {
    String? customPath,
  }) async {
    switch (environment) {
      case CoreEnvironment.development:
        await dotenv.load(
          fileName: customPath != null
              ? '$customPath.env.development'
              : '.env.development',
        );
        break;
      case CoreEnvironment.staging:
        await dotenv.load(
          fileName: customPath != null
              ? '$customPath.env.staging'
              : '.env.staging',
        );
        break;
      case CoreEnvironment.uat:
        await dotenv.load(
          fileName: customPath != null ? '$customPath.env.uat' : '.env.uat',
        );
        break;
      case CoreEnvironment.production:
        await dotenv.load(
          fileName: customPath != null
              ? '$customPath.env.production'
              : '.env.production',
        );
        break;
    }
  }

  String getString(String key, {String? fallback}) {
    return dotenv.get(key, fallback: fallback);
  }

  int getInt(String key, {int fallback = -1}) {
    return dotenv.getInt(key, fallback: fallback);
  }

  bool getBool(String key, {bool fallback = false}) {
    return dotenv.getBool(key, fallback: fallback);
  }

  double getDouble(String key, {double fallback = -1}) {
    return dotenv.getDouble(key, fallback: fallback);
  }

  /// Get a value with optional default.
  String? maybeGet(String key, {String? fallback}) {
    return dotenv.maybeGet(key, fallback: fallback);
  }
}
