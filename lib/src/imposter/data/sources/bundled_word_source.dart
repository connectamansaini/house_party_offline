import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import 'package:house_party_offline/src/imposter/data/models/word_pack_dto.dart';

/// Loads the read-only word packs that ship with the app.
///
/// Kept as an interface (not a top-level function) so tests can substitute a
/// fake — see `test/imposter/data/word_pack_repository_impl_test.dart`.
// ignore: one_member_abstracts
abstract interface class BundledWordSource {
  Future<List<WordPackDto>> load();
}

/// Reads bundled packs from `assets/word_packs/`. An `index.json` lists the
/// pack files so new packs can be added by dropping a file and referencing it,
/// without touching Dart code.
class AssetBundledWordSource implements BundledWordSource {
  const AssetBundledWordSource({AssetBundle? bundle, this.basePath = _base})
    : _bundle = bundle;

  static const _base = 'assets/word_packs';

  final AssetBundle? _bundle;
  final String basePath;

  AssetBundle get _assets => _bundle ?? rootBundle;

  @override
  Future<List<WordPackDto>> load() async {
    final indexRaw = await _assets.loadString('$basePath/index.json');
    final index = json.decode(indexRaw) as Map<String, dynamic>;
    final files = (index['packs'] as List<dynamic>).cast<String>();

    final packs = <WordPackDto>[];
    for (final file in files) {
      final raw = await _assets.loadString('$basePath/$file');
      final map = json.decode(raw) as Map<String, dynamic>;
      packs.add(WordPackDto.fromJson(map));
    }
    return packs;
  }
}
