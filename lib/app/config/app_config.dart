/// Environment-varying settings for the app.
///
/// This app is fully offline — there is no backend — so the only things that
/// actually vary per flavor are the build's identity and where bundled content
/// is read from. Anything that never varies belongs in a constants class, not
/// here.
abstract interface class IAppConfig {
  /// Which flavor this build is: `development`, `staging`, or `production`.
  String get flavor;

  /// Whether verbose diagnostics (bloc transitions, asset load failures) should
  /// be logged. Off in production.
  bool get enableVerboseLogging;

  /// Root asset directory holding `index.json` and the bundled word packs.
  String get wordPackAssetPath;
}

class AppConfig implements IAppConfig {
  const AppConfig({
    required this.flavor,
    required this.enableVerboseLogging,
    this.wordPackAssetPath = 'assets/word_packs',
  });

  const AppConfig.development()
    : this(flavor: 'development', enableVerboseLogging: true);

  const AppConfig.staging()
    : this(flavor: 'staging', enableVerboseLogging: true);

  const AppConfig.production()
    : this(flavor: 'production', enableVerboseLogging: false);

  @override
  final String flavor;

  @override
  final bool enableVerboseLogging;

  @override
  final String wordPackAssetPath;
}
