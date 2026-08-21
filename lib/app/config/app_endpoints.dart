import 'app_config.dart';

abstract interface class IAppEndpoints {
  String get health;
  String get wordPacks;
  String customWordPack(String id);
}

class AppEndpoints implements IAppEndpoints {
  const AppEndpoints(this._config);

  final IAppConfig _config;

  String _join(String path) => '${_config.baseUrl}$path';

  @override
  String get health => _join('/health');

  @override
  String get wordPacks => _join('/word-packs');

  @override
  String customWordPack(String id) => _join('/word-packs/$id');
}
