import '../../domain/entities/word_pack.dart';
import '../../domain/repositories/word_pack_repository.dart';
import '../models/word_pack_dto.dart';
import '../sources/bundled_word_source.dart';
import '../sources/imposter_local_source.dart';

/// Combines read-only bundled packs with user-created custom packs.
///
/// Bundled packs are read straight from assets each call (no Hive seeding), so
/// there is no stale copy to keep in sync. Custom packs live in local storage.
class WordPackRepositoryImpl implements WordPackRepository {
  WordPackRepositoryImpl({
    required BundledWordSource bundled,
    required ImposterLocalSource local,
  }) : _bundled = bundled,
       _local = local;

  final BundledWordSource _bundled;
  final ImposterLocalSource _local;

  @override
  Future<List<WordPack>> getPacks() async {
    final bundled = await _bundled.load();
    final custom = await _local.getCustomPacks();
    return [
      ...bundled.map((dto) => dto.toDomain(isCustom: false)),
      ...custom.map((dto) => dto.toDomain(isCustom: true)),
    ];
  }

  @override
  Future<void> saveCustomPack(WordPack pack) async {
    if (!pack.isCustom) {
      throw ArgumentError('Only custom packs can be saved.');
    }
    await _local.saveCustomPack(WordPackDto.fromDomain(pack));
  }

  @override
  Future<void> deleteCustomPack(String id) async {
    await _local.deleteCustomPack(id);
  }
}
