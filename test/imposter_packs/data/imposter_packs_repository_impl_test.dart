import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter_packs/data/datasources/imposter_packs_datasource.dart';
import 'package:house_party_offline/src/imposter_packs/data/models/imposter_pack_dto.dart';
import 'package:house_party_offline/src/imposter_packs/data/repositories/imposter_packs_repository_impl.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/failures/imposter_packs_failure.dart';

class _FakeDataSource implements ImposterPacksDataSource {
  _FakeDataSource({this.bundled = const [], this.throwOnGetBundled = false});

  final List<ImposterPackDto> bundled;
  final bool throwOnGetBundled;
  final Map<String, ImposterPackDto> custom = {};

  @override
  Future<List<ImposterPackDto>> getBundledPacks() async {
    if (throwOnGetBundled) throw Exception('boom');
    return bundled;
  }

  @override
  Future<List<ImposterPackDto>> getCustomPacks() async =>
      custom.values.toList();

  @override
  Future<void> saveCustomPack(ImposterPackDto pack) async =>
      custom[pack.id] = pack;

  @override
  Future<void> deleteCustomPack(String id) async => custom.remove(id);
}

void main() {
  const bundledDto = ImposterPackDto(
    id: 'foods',
    name: 'Foods',
    category: 'Food',
    words: ['Pizza'],
  );

  late _FakeDataSource dataSource;
  late ImposterPacksRepositoryImpl repo;

  setUp(() {
    dataSource = _FakeDataSource(bundled: [bundledDto]);
    repo = ImposterPacksRepositoryImpl(dataSource);
  });

  test(
    'getPacks merges bundled (isCustom=false) and custom (isCustom=true)',
    () async {
      dataSource.custom['mine'] = const ImposterPackDto(
        id: 'mine',
        name: 'Mine',
        category: 'Custom',
        words: ['secret'],
      );

      final packs = await repo.getPacks();

      expect(packs.map((p) => p.id), ['foods', 'mine']);
      expect(packs.firstWhere((p) => p.id == 'foods').isCustom, isFalse);
      expect(packs.firstWhere((p) => p.id == 'mine').isCustom, isTrue);
    },
  );

  test('getPacks wraps a data-source failure', () async {
    dataSource = _FakeDataSource(throwOnGetBundled: true);
    repo = ImposterPacksRepositoryImpl(dataSource);

    expect(() => repo.getPacks(), throwsA(isA<ImposterPacksFailure>()));
  });

  test('saveCustomPack persists to the data source', () async {
    const pack = ImposterPackEntity(
      id: 'c1',
      name: 'C1',
      category: 'Cat',
      words: ['a'],
      isCustom: true,
    );
    await repo.saveCustomPack(pack);
    expect(dataSource.custom.containsKey('c1'), isTrue);
  });

  test('saveCustomPack rejects a non-custom pack', () async {
    const pack = ImposterPackEntity(
      id: 'b1',
      name: 'B1',
      category: 'Cat',
      words: ['a'],
    );
    expect(
      () => repo.saveCustomPack(pack),
      throwsA(isA<ImposterPacksFailure>()),
    );
  });

  test('deleteCustomPack removes it from the data source', () async {
    dataSource.custom['gone'] = const ImposterPackDto(
      id: 'gone',
      name: 'Gone',
      category: 'Cat',
      words: ['x'],
    );
    await repo.deleteCustomPack('gone');
    expect(dataSource.custom.containsKey('gone'), isFalse);
  });
}
