import 'package:hive_ce/hive.dart';

/// Local persistence for custom prompt decks.
abstract interface class CustomPromptsDataSource {
  List<Map<dynamic, dynamic>>? read(String deckId);
  Future<void> write(String deckId, List<Map<String, dynamic>> prompts);
}

/// Hive-backed implementation: one list of `{id, text}` maps per deck,
/// keyed in the settings box.
class HiveCustomPromptsDataSource implements CustomPromptsDataSource {
  HiveCustomPromptsDataSource(this._box);

  final Box<dynamic> _box;

  static String _key(String deckId) => 'custom_prompts_$deckId';

  @override
  List<Map<dynamic, dynamic>>? read(String deckId) {
    final stored = _box.get(_key(deckId));
    if (stored is! List) return null;
    return stored.whereType<Map<dynamic, dynamic>>().toList();
  }

  @override
  Future<void> write(String deckId, List<Map<String, dynamic>> prompts) =>
      _box.put(_key(deckId), prompts);
}
