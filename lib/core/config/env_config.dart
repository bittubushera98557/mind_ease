enum AppEnvironment {
  dev,
  staging,
  prod,
}

/// Environment Configuration Manager
class EnvConfig {
  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final Duration apiTimeout;
  final bool enableLogging;

  static late EnvConfig _instance;
  static EnvConfig get instance => _instance;
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  EnvConfig._({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.apiTimeout,
    required this.enableLogging,
  });

  static void initialize({
    AppEnvironment environment = AppEnvironment.dev,
    String? customBaseUrl,
    Duration? customTimeout,
    bool? enableLogging,
  }) {
    switch (environment) {
      case AppEnvironment.dev:
        _instance = EnvConfig._(
          environment: AppEnvironment.dev,
          appName: 'MindEase (Dev)',
          apiBaseUrl: customBaseUrl ?? 'https://api-dev.mindease.app/v1',
          apiTimeout: customTimeout ?? const Duration(seconds: 30),
          enableLogging: enableLogging ?? true,
        );
        break;
      case AppEnvironment.staging:
        _instance = EnvConfig._(
          environment: AppEnvironment.staging,
          appName: 'MindEase (Staging)',
          apiBaseUrl: customBaseUrl ?? 'https://api-staging.mindease.app/v1',
          apiTimeout: customTimeout ?? const Duration(seconds: 30),
          enableLogging: enableLogging ?? true,
        );
        break;
      case AppEnvironment.prod:
        _instance = EnvConfig._(
          environment: AppEnvironment.prod,
          appName: 'MindEase',
          apiBaseUrl: customBaseUrl ?? 'https://api.mindease.app/v1',
          apiTimeout: customTimeout ?? const Duration(seconds: 15),
          enableLogging: enableLogging ?? false,
        );
        break;
    }
    _isInitialized = true;
  }

  bool get isDev => environment == AppEnvironment.dev;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProd => environment == AppEnvironment.prod;
}
