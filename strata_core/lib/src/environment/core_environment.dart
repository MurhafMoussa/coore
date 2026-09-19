/// Enumeration of standard environment types in Strata framework.
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
