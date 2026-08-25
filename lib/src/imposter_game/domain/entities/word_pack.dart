import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_pack.freezed.dart';

/// A themed set of secret words that a round draws from. Bundled packs ship
/// with the app; custom packs are created by users and persisted locally
/// ([isCustom] == true).
///
/// Narrower than `imposter_packs`' `ImposterPackEntity` on purpose: this is
/// only what the round engine needs, not the pack library's CRUD-managed
/// shape. `ImposterSetupState` adapts one to the other at the setup/game
/// boundary.
@freezed
abstract class WordPack with _$WordPack {
  const factory WordPack({
    required String id,
    required String name,

    /// Human-readable category shown as the imposter's hint when hints are
    /// on (e.g. "Food", "Places").
    required String category,
    required List<String> words,
    @Default(false) bool isCustom,
  }) = _WordPack;
}
