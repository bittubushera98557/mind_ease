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
  final String stripePublishableKey;

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
    required this.stripePublishableKey,
  });

  static void initialize({
    AppEnvironment environment = AppEnvironment.dev,
    String? customBaseUrl,
    Duration? customTimeout,
    bool? enableLogging,
    String? stripePublishableKey,
  }) {
    const defaultStripeKey = 'pk_test_51R6Ud7Jkj5lOrYw1aaYaU5l73oXXiDQ1agqIKS3G6dIM0G2ulpKygXUybVNtFcpsk5mseGMiZC6Hi8Aq2OSjhNXd009LeAamkW'; // Test Stripe Publishable Key
    // const defaultStripeKey = 'pk_test_51P2poYFOjqYjuziSQehIuAQksSaw3hKCtNnK5r7mrLs5xwS6ULXbNQJCDmPwdUISPMzqvxdMvzl5g2sHZHpDk4zq00YjLu4h6C'; // Test Stripe Publishable Key
    // const defaultStripeKey = 'pk_test_51Mz2xSGB582kSKxQ32847923847923849'; // Test Stripe Publishable Key

    switch (environment) {
      case AppEnvironment.dev:
        _instance = EnvConfig._(
          environment: AppEnvironment.dev,
          appName: 'MindEase (Dev)',
          apiBaseUrl: customBaseUrl ?? 'https://api.mindease.me/v1',
          apiTimeout: customTimeout ?? const Duration(seconds: 30),
          enableLogging: enableLogging ?? true,
          stripePublishableKey: stripePublishableKey ?? defaultStripeKey,
        );
        break;
      case AppEnvironment.staging:
        _instance = EnvConfig._(
          environment: AppEnvironment.staging,
          appName: 'MindEase (Staging)',
          apiBaseUrl: customBaseUrl ?? 'https://api.mindease.me/v1',
          apiTimeout: customTimeout ?? const Duration(seconds: 30),
          enableLogging: enableLogging ?? true,
          stripePublishableKey: stripePublishableKey ?? defaultStripeKey,
        );
        break;
      case AppEnvironment.prod:
        _instance = EnvConfig._(
          environment: AppEnvironment.prod,
          appName: 'MindEase',
          apiBaseUrl: customBaseUrl ?? 'https://api.mindease.me/v1',
          apiTimeout: customTimeout ?? const Duration(seconds: 15),
          enableLogging: enableLogging ?? false,
          stripePublishableKey: stripePublishableKey ?? defaultStripeKey,
        );
        break;
    }
    _isInitialized = true;
  }

  bool get isDev => environment == AppEnvironment.dev;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProd => environment == AppEnvironment.prod;
}
