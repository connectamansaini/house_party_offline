import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/data/sources/bundled_word_source.dart';

void main() {
  // Uses the real rootBundle, so this verifies the actual asset files listed in
  // assets/word_packs/index.json parse and are non-empty.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all bundled packs load, parse, and have words', () async {
    const source = AssetBundledWordSource();
    final packs = await source.load();

    expect(packs, isNotEmpty);
    final ids = packs.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length, reason: 'pack ids must be unique');

    for (final pack in packs) {
      expect(pack.id, isNotEmpty);
      expect(pack.name, isNotEmpty);
      expect(pack.category, isNotEmpty);
      expect(pack.words, isNotEmpty, reason: '${pack.id} has no words');
    }
  });
}
