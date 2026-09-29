/// Environment configuration loaded at build time.
enum Environment {
  dev,
  staging,
  prod;

  static Environment fromString(String value) {
    return switch (value) {
      'dev' => Environment.dev,
      'staging' => Environment.staging,
      'prod' => Environment.prod,
      _ => throw ArgumentError('Unknown environment: $value'),
    };
  }

  bool get isDev => this == Environment.dev;
  bool get isProd => this == Environment.prod;

  String get baseUrl => switch (this) {
        Environment.dev => 'https://api.dev.example.com',
        Environment.staging => 'https://api.staging.example.com',
        Environment.prod => 'https://api.example.com',
      };
}
