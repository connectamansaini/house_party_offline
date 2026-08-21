abstract interface class IAppConfig {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Map<String, String> get defaultHeaders;
}

class AppConfig implements IAppConfig {
  const AppConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 15),
    this.defaultHeaders = const {'Content-Type': 'application/json'},
  });

  const AppConfig.base()
    : this(
        baseUrl: 'https://example.invalid',
      );

  @override
  final String baseUrl;

  @override
  final Duration connectTimeout;

  @override
  final Duration receiveTimeout;

  @override
  final Map<String, String> defaultHeaders;
}
