import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up_setup/presentation/bloc/heads_up_setup_bloc.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';

import '../../helpers/fake_roster_repository.dart';

class _FakePacksRepo implements ImposterPacksRepository {
  _FakePacksRepo(this.packs, {this.throwOnGet = false});
  final List<ImposterPackEntity> packs;
  final bool throwOnGet;

  @override
  Future<List<ImposterPackEntity>> getPacks() async {
    if (throwOnGet) throw Exception('boom');
    return packs;
  }

  @override
  Future<void> saveCustomPack(ImposterPackEntity pack) async {}

  @override
  Future<void> deleteCustomPack(String id) async {}
}

const _animals = ImposterPackEntity(
  id: 'animals',
  name: 'Animals',
  category: 'Animal',
  words: ['Owl', 'Cat'],
);
const _foods = ImposterPackEntity(
  id: 'foods',
  name: 'Foods',
  category: 'Food',
  words: ['Pizza', 'Cat'], // "Cat" overlaps on purpose
);

HeadsUpSetupBloc _bloc({
  List<ImposterPackEntity> packs = const [_animals, _foods],
  bool throwOnGet = false,
  List<String> roster = const [],
}) => HeadsUpSetupBloc(
  FakeRosterRepository(roster),
  GetImposterPacksUseCase(_FakePacksRepo(packs, throwOnGet: throwOnGet)),
);

Future<HeadsUpSetupState> _started(HeadsUpSetupBloc bloc) {
  final future = bloc.stream.firstWhere(
    (s) => s.packsStatus != HeadsUpPacksStatus.loading,
  );
  bloc.add(const HeadsUpSetupStarted());
  return future;
}

void main() {
  test('Started seeds the roster, loads packs, selects them all', () async {
    final bloc = _bloc(roster: ['Ann', 'Bo', 'Cy']);
    final s = await _started(bloc);

    expect(s.players.map((p) => p.name), ['Ann', 'Bo', 'Cy']);
    expect(s.packsStatus, HeadsUpPacksStatus.ready);
    expect(s.selectedPackIds, {'animals', 'foods'});
    expect(s.words, ['Owl', 'Cat', 'Pizza']); // de-duplicated, pack order
    expect(s.canStart, isTrue);
    await bloc.close();
  });

  test('cannot start before packs load or with none selected', () async {
    final bloc = _bloc();
    expect(bloc.state.canStart, isFalse);

    await _started(bloc);
    final future = bloc.stream.firstWhere((s) => s.selectedPackIds.isEmpty);
    bloc
      ..add(const HeadsUpSetupPackToggled('animals'))
      ..add(const HeadsUpSetupPackToggled('foods'));
    final none = await future;

    expect(none.words, isEmpty);
    expect(none.canStart, isFalse);
    await bloc.close();
  });

  test('a pack load failure is reported, not thrown', () async {
    final bloc = _bloc(throwOnGet: true);
    final s = await _started(bloc);

    expect(s.packsStatus, HeadsUpPacksStatus.error);
    expect(s.canStart, isFalse);
    await bloc.close();
  });

  test('turn length accepts only the offered options; turns clamp', () async {
    final bloc = _bloc();
    await _started(bloc);

    bloc.add(const HeadsUpSetupRoundSecondsChanged(45));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.config.roundSeconds, 60);

    final ninety = bloc.stream.firstWhere((s) => s.config.roundSeconds == 90);
    bloc.add(const HeadsUpSetupRoundSecondsChanged(90));
    await ninety;

    final capped = bloc.stream.firstWhere(
      (s) => s.config.roundCount == HeadsUpConfig.maxRounds,
    );
    bloc.add(const HeadsUpSetupRoundCountChanged(99));
    await capped;

    final setup = bloc.state.buildSetup();
    expect(setup.config.roundSeconds, 90);
    expect(setup.config.roundCount, HeadsUpConfig.maxRounds);
    expect(setup.words.length, 3);
    await bloc.close();
  });
}
