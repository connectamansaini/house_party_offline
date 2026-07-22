import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/domain/entities/imposter_preferences.dart';
import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';
import 'package:house_party_offline/src/imposter/domain/repositories/imposter_settings_repository.dart';
import 'package:house_party_offline/src/imposter/domain/repositories/word_pack_repository.dart';
import 'package:house_party_offline/src/imposter/presentation/setup/setup_cubit.dart';
import 'package:house_party_offline/src/imposter/presentation/setup/setup_state.dart';

class _FakeRepo implements WordPackRepository {
  _FakeRepo(this.packs, {this.throwOnGet = false});
  final List<WordPack> packs;
  final bool throwOnGet;

  @override
  Future<List<WordPack>> getPacks() async {
    if (throwOnGet) throw Exception('boom');
    return packs;
  }

  @override
  Future<void> saveCustomPack(WordPack pack) async {}

  @override
  Future<void> deleteCustomPack(String id) async {}
}

/// In-memory settings repo. Starts empty unless [initial] is provided; records
/// the last saved value.
class _FakeSettings implements ImposterSettingsRepository {
  _FakeSettings([this.stored]);
  ImposterPreferences? stored;

  @override
  Future<ImposterPreferences?> load() async => stored;

  @override
  Future<void> save(ImposterPreferences prefs) async => stored = prefs;
}

const _foods = WordPack(
  id: 'foods',
  name: 'Foods',
  category: 'Food',
  words: ['Pizza', 'Sushi'],
);
const _animals = WordPack(
  id: 'animals',
  name: 'Animals',
  category: 'Animal',
  words: ['Owl'],
);

SetupCubit _cubit(
  List<WordPack> packs, {
  bool throwOnGet = false,
  ImposterPreferences? prefs,
}) {
  return SetupCubit(
    _FakeRepo(packs, throwOnGet: throwOnGet),
    _FakeSettings(prefs),
  );
}

void main() {
  group('SetupCubit.init', () {
    test('seeds a default roster, loads packs, selects the first', () async {
      final cubit = _cubit([_foods, _animals]);
      await cubit.init();

      final s = cubit.state;
      expect(s.packsStatus, PacksStatus.ready);
      expect(s.players.length, SetupState.minPlayers);
      expect(s.selectedPack?.id, 'foods');
      expect(s.canStart, isTrue);
    });

    test('reports an error when packs fail to load', () async {
      final cubit = _cubit([], throwOnGet: true);
      await cubit.init();

      expect(cubit.state.packsStatus, PacksStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
      expect(cubit.state.canStart, isFalse);
    });
  });

  group('preferences', () {
    test('init restores saved roster, options, and pack', () async {
      const prefs = ImposterPreferences(
        playerNames: ['Ann', 'Bo', 'Cy', 'Di'],
        imposterCount: 2,
        categoryHintEnabled: true,
        discussionMinutes: 4,
        crewWinPoints: 3,
        imposterWinPoints: 5,
        selectedPackId: 'animals',
      );
      final cubit = _cubit([_foods, _animals], prefs: prefs);
      await cubit.init();

      final s = cubit.state;
      expect(s.players.map((p) => p.name), ['Ann', 'Bo', 'Cy', 'Di']);
      expect(s.imposterCount, 2);
      expect(s.categoryHintEnabled, isTrue);
      expect(s.discussionMinutes, 4);
      expect(s.crewWinPoints, 3);
      expect(s.imposterWinPoints, 5);
      expect(s.selectedPack?.id, 'animals');
    });

    test('falls back to the first pack when the saved one is gone', () async {
      const prefs = ImposterPreferences(
        playerNames: ['A', 'B', 'C'],
        imposterCount: 1,
        categoryHintEnabled: false,
        discussionMinutes: 3,
        crewWinPoints: 1,
        imposterWinPoints: 2,
        selectedPackId: 'deleted-pack',
      );
      final cubit = _cubit([_foods], prefs: prefs);
      await cubit.init();
      expect(cubit.state.selectedPack?.id, 'foods');
    });

    test('clamps a saved imposter count that no longer fits the roster',
        () async {
      const prefs = ImposterPreferences(
        playerNames: ['A', 'B', 'C'], // 3 players → max 2 imposters
        imposterCount: 9,
        categoryHintEnabled: false,
        discussionMinutes: 3,
        crewWinPoints: 1,
        imposterWinPoints: 2,
      );
      final cubit = _cubit([_foods], prefs: prefs);
      await cubit.init();
      expect(cubit.state.imposterCount, 2);
    });

    test('persist writes the current form back to the repository', () async {
      final settings = _FakeSettings();
      final cubit = SetupCubit(_FakeRepo([_foods, _animals]), settings);
      await cubit.init();
      cubit.selectPack('animals');
      cubit.setCategoryHint(true);
      cubit.setDiscussionMinutes(6);

      await cubit.persist();

      final saved = settings.stored!;
      expect(saved.playerNames.length, SetupState.minPlayers);
      expect(saved.selectedPackId, 'animals');
      expect(saved.categoryHintEnabled, isTrue);
      expect(saved.discussionMinutes, 6);
    });
  });

  group('players', () {
    test('addPlayer appends up to the max', () async {
      final cubit = _cubit([_foods]);
      await cubit.init();
      final before = cubit.state.players.length;
      cubit.addPlayer();
      expect(cubit.state.players.length, before + 1);
    });

    test('addPlayer is capped at maxPlayers', () async {
      final cubit = _cubit([_foods]);
      await cubit.init();
      for (var i = 0; i < 20; i++) {
        cubit.addPlayer();
      }
      expect(cubit.state.players.length, SetupState.maxPlayers);
    });

    test('removePlayer clamps the imposter count', () async {
      final cubit = _cubit([_foods]);
      await cubit.init();
      cubit.addPlayer(); // 4 players
      cubit.setImposterCount(3);
      expect(cubit.state.imposterCount, 3);

      final firstId = cubit.state.players.first.id;
      cubit.removePlayer(firstId);
      expect(cubit.state.players.length, 3);
      expect(cubit.state.imposterCount, 2);
    });

    test('renamePlayer updates only the target', () async {
      final cubit = _cubit([_foods]);
      await cubit.init();
      final id = cubit.state.players[1].id;
      cubit.renamePlayer(id, 'Alice');
      expect(cubit.state.players[1].name, 'Alice');
      expect(cubit.state.players[0].name, 'Player 1');
    });
  });

  group('config', () {
    test('setImposterCount clamps to 1..(players-1)', () async {
      final cubit = _cubit([_foods]);
      await cubit.init(); // 3 players → max 2

      cubit.setImposterCount(99);
      expect(cubit.state.imposterCount, 2);

      cubit.setImposterCount(0);
      expect(cubit.state.imposterCount, 1);
    });

    test('selectPack switches the chosen pack', () async {
      final cubit = _cubit([_foods, _animals]);
      await cubit.init();
      cubit.selectPack('animals');
      expect(cubit.state.selectedPack?.id, 'animals');
    });

    test('buildSetup produces a matching GameSetup', () async {
      final cubit = _cubit([_foods]);
      await cubit.init();
      cubit.setCategoryHint(true);
      cubit.setDiscussionMinutes(5);

      expect(cubit.state.canStart, isTrue);
      final setup = cubit.state.buildSetup();
      expect(setup.players.length, 3);
      expect(setup.config.pack.id, 'foods');
      expect(setup.config.categoryHintEnabled, isTrue);
      expect(setup.config.discussionTime, const Duration(minutes: 5));
    });
  });
}
