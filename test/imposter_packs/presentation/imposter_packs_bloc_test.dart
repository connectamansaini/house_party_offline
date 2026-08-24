import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/failures/imposter_packs_failure.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';
import 'package:house_party_offline/src/imposter_packs/domain/status/imposter_packs_status.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/delete_custom_imposter_pack_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/presentation/bloc/imposter_packs_bloc.dart';

/// Records deletions and can be told to fail, so the bloc's failure branch is
/// reachable without a real data source.
class _FakeRepository implements ImposterPacksRepository {
  _FakeRepository(this.packs);

  List<ImposterPackEntity> packs;
  final List<String> deleted = <String>[];
  ImposterPacksFailure? failure;

  @override
  Future<List<ImposterPackEntity>> getPacks() async {
    final pending = failure;
    if (pending != null) {
      throw pending;
    }
    return packs;
  }

  @override
  Future<void> saveCustomPack(ImposterPackEntity pack) async {}

  @override
  Future<void> deleteCustomPack(String id) async {
    deleted.add(id);
    packs = packs.where((pack) => pack.id != id).toList();
  }
}

const _bundled = ImposterPackEntity(
  id: 'foods',
  name: 'Foods',
  category: 'Food',
  words: ['Pizza'],
);

const _custom = ImposterPackEntity(
  id: 'mine',
  name: 'Mine',
  category: 'Custom',
  words: ['x', 'y', 'z'],
  isCustom: true,
);

ImposterPacksBloc _buildBloc(_FakeRepository repository) {
  return ImposterPacksBloc(
    GetImposterPacksUseCase(repository),
    DeleteCustomImposterPackUseCase(repository),
  );
}

void main() {
  group('ImposterPacksBloc', () {
    blocTest<ImposterPacksBloc, ImposterPacksState>(
      'started emits loading then the loaded packs',
      build: () => _buildBloc(_FakeRepository([_bundled, _custom])),
      act: (bloc) => bloc.add(const ImposterPacksStarted()),
      expect: () => const <ImposterPacksState>[
        ImposterPacksState(status: ImposterPacksStatus.loading),
        ImposterPacksState(
          status: ImposterPacksStatus.success,
          packs: [_bundled, _custom],
        ),
      ],
    );

    blocTest<ImposterPacksBloc, ImposterPacksState>(
      'started emits the empty status when there are no packs',
      build: () => _buildBloc(_FakeRepository([])),
      act: (bloc) => bloc.add(const ImposterPacksStarted()),
      expect: () => const <ImposterPacksState>[
        ImposterPacksState(status: ImposterPacksStatus.loading),
        ImposterPacksState(status: ImposterPacksStatus.empty),
      ],
    );

    blocTest<ImposterPacksBloc, ImposterPacksState>(
      'started surfaces a failure message',
      build: () {
        final repository = _FakeRepository([])
          ..failure = const ImposterPacksFailure(message: 'boom');
        return _buildBloc(repository);
      },
      act: (bloc) => bloc.add(const ImposterPacksStarted()),
      expect: () => const <ImposterPacksState>[
        ImposterPacksState(status: ImposterPacksStatus.loading),
        ImposterPacksState(
          status: ImposterPacksStatus.failure,
          errorMessage: 'boom',
        ),
      ],
    );

    test(
      'deleting a pack removes it from the repository and reloads',
      () async {
        final repository = _FakeRepository([_bundled, _custom]);
        final bloc = _buildBloc(repository);

        bloc.add(const ImposterPacksStarted());
        await bloc.stream.firstWhere(
          (state) => state.status == ImposterPacksStatus.success,
        );

        bloc.add(const ImposterPackDeletedRequested('mine'));
        final reloaded = await bloc.stream.firstWhere(
          (state) => state.status == ImposterPacksStatus.success,
        );

        expect(repository.deleted, ['mine']);
        expect(reloaded.packs.map((pack) => pack.id), ['foods']);

        await bloc.close();
      },
    );
  });
}
