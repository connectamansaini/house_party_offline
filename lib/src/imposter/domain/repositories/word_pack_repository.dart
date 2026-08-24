import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';

/// Abstract source of word packs. Implemented in the data layer over bundled
/// JSON assets plus locally persisted custom packs.
abstract interface class WordPackRepository {
  /// All available packs: bundled first, then custom.
  Future<List<WordPack>> getPacks();

  /// Persists a user-created pack ([WordPack.isCustom] must be true).
  Future<void> saveCustomPack(WordPack pack);

  /// Removes a custom pack by id. Bundled packs cannot be deleted.
  Future<void> deleteCustomPack(String id);
}
