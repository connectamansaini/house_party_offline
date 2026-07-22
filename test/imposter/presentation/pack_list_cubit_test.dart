import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';
import 'package:house_party_offline/src/imposter/domain/repositories/word_pack_repository.dart';
import 'package:house_party_offline/src/imposter/presentation/packs/pack_list_cubit.dart';

class _FakeRepo implements WordPackRepository {
  _FakeRepo(this.packs);
  List<WordPack> packs;
  final List<String> deleted = [];

  @override
  Future<List<WordPack>> getPacks() async => packs;

  @override
  Future<void> saveCustomPack(WordPack pack) async {}

  @override
  Future<void> deleteCustomPack(String id) async {
    deleted.add(id);
    packs = packs.where((p) => p.id != id).toList();
  }
}

const _bundled = WordPack(
  id: 'foods',
  name: 'Foods',
  category: 'Food',
  words: ['Pizza'],
);
const _custom = WordPack(
  id: 'mine',
  name: 'Mine',
  category: 'Custom',
  words: ['x', 'y', 'z'],
  isCustom: true,
);

void main() {
  test('load emits the packs', () async {
    final cubit = PackListCubit(_FakeRepo([_bundled, _custom]));
    await cubit.load();
    expect(cubit.state, isA<PackListLoaded>());
    expect((cubit.state as PackListLoaded).packs, [_bundled, _custom]);
  });

  test('deletePack removes it from the repo and reloads', () async {
    final repo = _FakeRepo([_bundled, _custom]);
    final cubit = PackListCubit(repo);
    await cubit.load();

    await cubit.deletePack('mine');

    expect(repo.deleted, ['mine']);
    final loaded = cubit.state as PackListLoaded;
    expect(loaded.packs.map((p) => p.id), ['foods']);
  });
}
