import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:hive_ce/hive.dart';

import 'package:house_party_offline/src/imposter_packs/data/models/imposter_pack_dto.dart';

abstract interface class ImposterPacksDataSource {
  Future<List<ImposterPackDto>> getBundledPacks();
  Future<List<ImposterPackDto>> getCustomPacks();
  Future<void> saveCustomPack(ImposterPackDto pack);
  Future<void> deleteCustomPack(String id);
}

class LocalImposterPacksDataSource implements ImposterPacksDataSource {
  LocalImposterPacksDataSource(
    this._customPackBox, {
    AssetBundle? bundle,
    this.basePath = _defaultBasePath,
  }) : _bundle = bundle;

  static const _defaultBasePath = 'assets/word_packs';

  final Box<Map<dynamic, dynamic>> _customPackBox;
  final AssetBundle? _bundle;
  final String basePath;

  AssetBundle get assets => _bundle ?? rootBundle;

  @override
  Future<List<ImposterPackDto>> getBundledPacks() async {
    final indexRaw = await assets.loadString('$basePath/index.json');
    final index = json.decode(indexRaw) as Map<String, dynamic>;
    final files = (index['packs'] as List<dynamic>).cast<String>();

    final packs = <ImposterPackDto>[];
    for (final file in files) {
      final raw = await assets.loadString('$basePath/$file');
      final map = json.decode(raw) as Map<String, dynamic>;
      packs.add(ImposterPackDto.fromJson(map));
    }
    return packs;
  }

  @override
  Future<List<ImposterPackDto>> getCustomPacks() async {
    return _customPackBox.values.map(ImposterPackDto.fromMap).toList();
  }

  @override
  Future<void> saveCustomPack(ImposterPackDto pack) async {
    await _customPackBox.put(pack.id, pack.toJson());
  }

  @override
  Future<void> deleteCustomPack(String id) async {
    await _customPackBox.delete(id);
  }
}
