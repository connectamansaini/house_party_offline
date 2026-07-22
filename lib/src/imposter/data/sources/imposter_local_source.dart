import 'package:hive_ce/hive.dart';

import '../models/word_pack_dto.dart';

/// Local persistence for user-created word packs.
abstract interface class ImposterLocalSource {
  Future<List<WordPackDto>> getCustomPacks();
  Future<void> saveCustomPack(WordPackDto pack);
  Future<void> deleteCustomPack(String id);
}

/// Hive-backed implementation. Each pack is stored as its JSON map keyed by
/// pack id in the custom-packs box.
class HiveImposterLocalSource implements ImposterLocalSource {
  HiveImposterLocalSource(this._box);

  final Box<Map<dynamic, dynamic>> _box;

  @override
  Future<List<WordPackDto>> getCustomPacks() async {
    return _box.values.map(WordPackDto.fromMap).toList();
  }

  @override
  Future<void> saveCustomPack(WordPackDto pack) async {
    await _box.put(pack.id, pack.toJson());
  }

  @override
  Future<void> deleteCustomPack(String id) async {
    await _box.delete(id);
  }
}
