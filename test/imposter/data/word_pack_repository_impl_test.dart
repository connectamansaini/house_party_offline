import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/data/models/word_pack_dto.dart';
import 'package:house_party_offline/src/imposter/data/repositories/word_pack_repository_impl.dart';
import 'package:house_party_offline/src/imposter/data/sources/bundled_word_source.dart';
import 'package:house_party_offline/src/imposter/data/sources/imposter_local_source.dart';
import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';

class _FakeBundledSource implements BundledWordSource {
  _FakeBundledSource(this.packs);
  final List<WordPackDto> packs;
  @override
  Future<List<WordPackDto>> load() async => packs;
}

class _FakeLocalSource implements ImposterLocalSource {
  final Map<String, WordPackDto> store = {};

  @override
  Future<List<WordPackDto>> getCustomPacks() async => store.values.toList();

  @override
  Future<void> saveCustomPack(WordPackDto pack) async => store[pack.id] = pack;

  @override
  Future<void> deleteCustomPack(String id) async => store.remove(id);
}

void main() {
  const bundledDto = WordPackDto(
    id: 'foods',
    name: 'Foods',
    category: 'Food',
    words: ['Pizza'],
  );

  late _FakeLocalSource local;
  late WordPackRepositoryImpl repo;

  setUp(() {
    local = _FakeLocalSource();
    repo = WordPackRepositoryImpl(
      bundled: _FakeBundledSource([bundledDto]),
      local: local,
    );
  });

  test('getPacks merges bundled (isCustom=false) and custom (isCustom=true)',
      () async {
    local.store['mine'] = const WordPackDto(
      id: 'mine',
      name: 'Mine',
      category: 'Custom',
      words: ['secret'],
    );

    final packs = await repo.getPacks();

    expect(packs.map((p) => p.id), ['foods', 'mine']);
    expect(packs.firstWhere((p) => p.id == 'foods').isCustom, isFalse);
    expect(packs.firstWhere((p) => p.id == 'mine').isCustom, isTrue);
  });

  test('saveCustomPack persists to the local source', () async {
    const pack = WordPack(
      id: 'c1',
      name: 'C1',
      category: 'Cat',
      words: ['a'],
      isCustom: true,
    );
    await repo.saveCustomPack(pack);
    expect(local.store.containsKey('c1'), isTrue);
  });

  test('saveCustomPack rejects a non-custom pack', () async {
    const pack = WordPack(
      id: 'b1',
      name: 'B1',
      category: 'Cat',
      words: ['a'],
    );
    expect(() => repo.saveCustomPack(pack), throwsArgumentError);
  });

  test('deleteCustomPack removes it from the local source', () async {
    local.store['gone'] = const WordPackDto(
      id: 'gone',
      name: 'Gone',
      category: 'Cat',
      words: ['x'],
    );
    await repo.deleteCustomPack('gone');
    expect(local.store.containsKey('gone'), isFalse);
  });
}
