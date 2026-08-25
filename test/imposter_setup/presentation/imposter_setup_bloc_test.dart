import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';
import 'package:house_party_offline/src/imposter_setup/domain/repositories/imposter_setup_preferences_repository.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/load_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/save_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/presentation/bloc/imposter_setup_bloc.dart';

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

/// In-memory preferences repo. Starts empty unless [stored] is provided;
/// records the last saved value.
class _FakePreferencesRepo implements ImposterSetupPreferencesRepository {
  _FakePreferencesRepo([this.stored]);
  ImposterSetupPreferencesEntity? stored;

  @override
  Future<ImposterSetupPreferencesEntity?> load() async => stored;

  @override
  Future<void> save(ImposterSetupPreferencesEntity prefs) async =>
      stored = prefs;
}

const _foods = ImposterPackEntity(
  id: 'foods',
  name: 'Foods',
  category: 'Food',
  words: ['Pizza', 'Sushi'],
);
const _animals = ImposterPackEntity(
  id: 'animals',
  name: 'Animals',
  category: 'Animal',
  words: ['Owl'],
);

ImposterSetupBloc _bloc(
  List<ImposterPackEntity> packs, {
  bool throwOnGet = false,
  ImposterSetupPreferencesEntity? prefs,
  _FakePreferencesRepo? preferencesRepo,
}) {
  final preferences = preferencesRepo ?? _FakePreferencesRepo(prefs);
  return ImposterSetupBloc(
    LoadImposterSetupPreferencesUseCase(preferences),
    SaveImposterSetupPreferencesUseCase(preferences),
    GetImposterPacksUseCase(_FakePacksRepo(packs, throwOnGet: throwOnGet)),
  );
}

/// Subscribes for the next state matching [predicate] *before* adding
/// [event], then adds it — avoiding the race of adding first and hoping the
/// listener attaches in time.
Future<ImposterSetupState> _emitUntil(
  ImposterSetupBloc bloc,
  ImposterSetupEvent event,
  bool Function(ImposterSetupState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

/// Starts the bloc and waits for the initial pack load to settle
/// (success or error).
Future<ImposterSetupState> _started(ImposterSetupBloc bloc) => _emitUntil(
  bloc,
  const ImposterSetupStarted(),
  (s) => s.packsStatus != ImposterSetupPacksStatus.loading,
);

void main() {
  group('ImposterSetupStarted', () {
    test('seeds a default roster, loads packs, selects the first', () async {
      final bloc = _bloc([_foods, _animals]);
      final s = await _started(bloc);

      expect(s.packsStatus, ImposterSetupPacksStatus.ready);
      expect(s.players.length, ImposterSetupState.minPlayers);
      expect(s.selectedPackIds, {'foods'});
      expect(s.canStart, isTrue);

      await bloc.close();
    });

    test('reports an error when packs fail to load', () async {
      final bloc = _bloc([], throwOnGet: true);
      final s = await _started(bloc);

      expect(s.packsStatus, ImposterSetupPacksStatus.error);
      expect(s.errorMessage, isNotNull);
      expect(s.canStart, isFalse);

      await bloc.close();
    });
  });

  group('preferences', () {
    test('init restores saved roster, options, and packs', () async {
      const prefs = ImposterSetupPreferencesEntity(
        playerNames: ['Ann', 'Bo', 'Cy', 'Di'],
        imposterCount: 2,
        categoryHintEnabled: true,
        discussionMinutes: 4,
        civilianWinPoints: 3,
        imposterWinPoints: 5,
        selectedPackIds: ['animals', 'foods'],
      );
      final bloc = _bloc([_foods, _animals], prefs: prefs);
      final s = await _started(bloc);

      expect(s.players.map((p) => p.name), ['Ann', 'Bo', 'Cy', 'Di']);
      expect(s.imposterCount, 2);
      expect(s.categoryHintEnabled, isTrue);
      expect(s.discussionMinutes, 4);
      expect(s.civilianWinPoints, 3);
      expect(s.imposterWinPoints, 5);
      expect(s.selectedPackIds, {'animals', 'foods'});

      await bloc.close();
    });

    test(
      'drops saved packs that no longer exist, falling back to first',
      () async {
        const prefs = ImposterSetupPreferencesEntity(
          playerNames: ['A', 'B', 'C'],
          selectedPackIds: ['deleted-pack'],
        );
        final bloc = _bloc([_foods], prefs: prefs);
        final s = await _started(bloc);
        expect(s.selectedPackIds, {'foods'});

        await bloc.close();
      },
    );

    test(
      'clamps a saved imposter count that no longer fits the roster',
      () async {
        const prefs = ImposterSetupPreferencesEntity(
          playerNames: ['A', 'B', 'C'], // 3 players → max 2 imposters
          imposterCount: 9,
        );
        final bloc = _bloc([_foods], prefs: prefs);
        final s = await _started(bloc);
        expect(s.imposterCount, 2);

        await bloc.close();
      },
    );

    test('persist writes the current form back to the repository', () async {
      final preferencesRepo = _FakePreferencesRepo();
      final bloc = _bloc([_foods, _animals], preferencesRepo: preferencesRepo);
      await _started(bloc); // defaults to {foods}

      await _emitUntil(
        bloc,
        const ImposterSetupPackToggled('animals'), // now {foods, animals}
        (s) => s.selectedPackIds.length == 2,
      );
      await _emitUntil(
        bloc,
        const ImposterSetupCategoryHintChanged(enabled: true),
        (s) => s.categoryHintEnabled,
      );
      await _emitUntil(
        bloc,
        const ImposterSetupDiscussionMinutesChanged(6),
        (s) => s.discussionMinutes == 6,
      );

      await bloc.persist();

      final saved = preferencesRepo.stored!;
      expect(saved.playerNames.length, ImposterSetupState.minPlayers);
      expect(saved.selectedPackIds, containsAll(['foods', 'animals']));
      expect(saved.categoryHintEnabled, isTrue);
      expect(saved.discussionMinutes, 6);

      await bloc.close();
    });
  });

  group('players', () {
    test('addPlayer appends up to the max', () async {
      final bloc = _bloc([_foods]);
      final started = await _started(bloc);
      final before = started.players.length;

      final s = await _emitUntil(
        bloc,
        const ImposterSetupPlayerAdded(),
        (s) => s.players.length == before + 1,
      );
      expect(s.players.length, before + 1);

      await bloc.close();
    });

    test('addPlayer is capped at maxPlayers', () async {
      final bloc = _bloc([_foods]);
      await _started(bloc);

      for (var i = 0; i < 20; i++) {
        bloc.add(const ImposterSetupPlayerAdded());
      }
      await bloc.stream.firstWhere(
        (s) => s.players.length == ImposterSetupState.maxPlayers,
      );
      expect(bloc.state.players.length, ImposterSetupState.maxPlayers);

      await bloc.close();
    });

    test('removePlayer clamps the imposter count', () async {
      final bloc = _bloc([_foods]);
      await _started(bloc);

      await _emitUntil(
        bloc,
        const ImposterSetupPlayerAdded(), // 4 players
        (s) => s.players.length == 4,
      );
      await _emitUntil(
        bloc,
        const ImposterSetupImposterCountChanged(3),
        (s) => s.imposterCount == 3,
      );

      final firstId = bloc.state.players.first.id;
      await _emitUntil(
        bloc,
        ImposterSetupPlayerRemoved(firstId),
        (s) => s.players.length == 3,
      );

      expect(bloc.state.players.length, 3);
      expect(bloc.state.imposterCount, 2);

      await bloc.close();
    });

    test('renamePlayer updates only the target', () async {
      final bloc = _bloc([_foods]);
      final started = await _started(bloc);
      final id = started.players[1].id;

      final s = await _emitUntil(
        bloc,
        ImposterSetupPlayerRenamed(id: id, name: 'Alice'),
        (s) => s.players[1].name == 'Alice',
      );

      expect(s.players[1].name, 'Alice');
      expect(s.players[0].name, 'Player 1');

      await bloc.close();
    });
  });

  group('config', () {
    test('setImposterCount clamps to 1..(players-1)', () async {
      final bloc = _bloc([_foods]);
      await _started(bloc); // 3 players → max 2

      await _emitUntil(
        bloc,
        const ImposterSetupImposterCountChanged(99),
        (s) => s.imposterCount == 2,
      );
      await _emitUntil(
        bloc,
        const ImposterSetupImposterCountChanged(0),
        (s) => s.imposterCount == 1,
      );

      await bloc.close();
    });

    test('togglePack adds and removes packs', () async {
      final bloc = _bloc([_foods, _animals]);
      await _started(bloc); // {foods}

      await _emitUntil(
        bloc,
        const ImposterSetupPackToggled('animals'),
        (s) => s.selectedPackIds.length == 2,
      );
      expect(bloc.state.selectedPackIds, {'foods', 'animals'});

      await _emitUntil(
        bloc,
        const ImposterSetupPackToggled('foods'),
        (s) => s.selectedPackIds.length == 1,
      );
      expect(bloc.state.selectedPackIds, {'animals'});

      await bloc.close();
    });

    test('selectAll and clear toggle every pack', () async {
      final bloc = _bloc([_foods, _animals]);
      await _started(bloc);

      await _emitUntil(
        bloc,
        const ImposterSetupAllPacksSelected(),
        (s) => s.allPacksSelected,
      );
      expect(bloc.state.selectedPackIds, {'foods', 'animals'});

      await _emitUntil(
        bloc,
        const ImposterSetupPacksCleared(),
        (s) => s.selectedPackIds.isEmpty,
      );
      expect(bloc.state.canStart, isFalse);

      await bloc.close();
    });

    test('buildSetup produces a matching GameSetup', () async {
      final bloc = _bloc([_foods, _animals]);
      await _started(bloc);

      await _emitUntil(
        bloc,
        const ImposterSetupAllPacksSelected(),
        (s) => s.allPacksSelected,
      );
      await _emitUntil(
        bloc,
        const ImposterSetupCategoryHintChanged(enabled: true),
        (s) => s.categoryHintEnabled,
      );
      await _emitUntil(
        bloc,
        const ImposterSetupDiscussionMinutesChanged(5),
        (s) => s.discussionMinutes == 5,
      );

      expect(bloc.state.canStart, isTrue);
      final setup = bloc.state.buildSetup();
      expect(setup.players.length, 3);
      expect(
        setup.config.packs.map((p) => p.id),
        containsAll(['foods', 'animals']),
      );
      expect(setup.config.categoryHintEnabled, isTrue);
      expect(setup.config.discussionTime, const Duration(minutes: 5));

      await bloc.close();
    });
  });
}
