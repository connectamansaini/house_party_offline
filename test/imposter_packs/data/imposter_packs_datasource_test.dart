import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/imposter_packs/data/datasources/imposter_packs_datasource.dart';

void main() {
  // Uses the real rootBundle, so this verifies the actual asset files listed
  // in assets/word_packs/index.json parse and are non-empty.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all bundled packs load, parse, and have words', () async {
    final source = LocalImposterPacksDataSource(
      _NeverUsedBox(),
    );
    final packs = await source.getBundledPacks();

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

/// [LocalImposterPacksDataSource] never touches its Hive box for
/// [ImposterPacksDataSource.getBundledPacks] — this stands in so the test
/// doesn't need a real, opened box.
class _NeverUsedBox extends Fake implements Box<Map<dynamic, dynamic>> {}
