import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever_setup/presentation/bloc/never_have_i_ever_setup_bloc.dart';
import '../../helpers/fake_custom_prompts_repository.dart';
import '../../helpers/fake_roster_repository.dart';

Future<NeverHaveIEverSetupState> _emitUntil(
  NeverHaveIEverSetupBloc bloc,
  NeverHaveIEverSetupEvent event,
  bool Function(NeverHaveIEverSetupState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  group('roster', () {
    test('Started seeds the saved roster', () async {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(['Ann', 'Bo', 'Cy']),
        FakeCustomPromptsRepository(),
      );

      final s = await _emitUntil(
        bloc,
        const NeverHaveIEverSetupStarted(),
        (s) => s.players.first.name == 'Ann',
      );

      expect(s.players.map((p) => p.name), ['Ann', 'Bo', 'Cy']);
      await bloc.close();
    });

    test('RosterSaved writes the current names', () async {
      final roster = FakeRosterRepository();
      final bloc = NeverHaveIEverSetupBloc(
        roster,
        FakeCustomPromptsRepository(),
      )..add(const NeverHaveIEverSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);

      expect(roster.stored, ['Player 1', 'Player 2']);
      await bloc.close();
    });
  });

  group('initial state', () {
    test('seeds the minimum default roster', () {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      expect(bloc.state.players.length, NeverHaveIEverConfig.minPlayers);
      expect(
        bloc.state.players.map((p) => p.name),
        List.generate(
          NeverHaveIEverConfig.minPlayers,
          (i) => 'Player ${i + 1}',
        ),
      );
      expect(bloc.state.config.livesPerPlayer, 3);
      bloc.close();
    });
  });

  group('players', () {
    test('addPlayer appends up to the max', () async {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      final before = bloc.state.players.length;

      final s = await _emitUntil(
        bloc,
        const NeverHaveIEverSetupPlayerAdded(),
        (s) => s.players.length == before + 1,
      );
      expect(s.players.length, before + 1);

      await bloc.close();
    });

    test('addPlayer is capped at maxPlayers', () async {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      for (var i = 0; i < 20; i++) {
        bloc.add(const NeverHaveIEverSetupPlayerAdded());
      }
      await bloc.stream.firstWhere(
        (s) => s.players.length == NeverHaveIEverConfig.maxPlayers,
      );
      expect(bloc.state.players.length, NeverHaveIEverConfig.maxPlayers);

      await bloc.close();
    });

    test('removePlayer removes the target', () async {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      final firstId = bloc.state.players.first.id;

      final s = await _emitUntil(
        bloc,
        NeverHaveIEverSetupPlayerRemoved(firstId),
        (s) => s.players.length == NeverHaveIEverConfig.minPlayers - 1,
      );

      expect(s.players.any((p) => p.id == firstId), isFalse);
      await bloc.close();
    });

    test('renamePlayer updates only the target', () async {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      final id = bloc.state.players[1].id;

      final s = await _emitUntil(
        bloc,
        NeverHaveIEverSetupPlayerRenamed(id: id, name: 'Alice'),
        (s) => s.players[1].name == 'Alice',
      );

      expect(s.players[1].name, 'Alice');
      expect(s.players[0].name, 'Player 1');

      await bloc.close();
    });
  });

  group('config', () {
    test('setLivesCount clamps within min/max', () async {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );

      final capped = await _emitUntil(
        bloc,
        const NeverHaveIEverSetupLivesCountChanged(99),
        (s) => s.config.livesPerPlayer == NeverHaveIEverConfig.maxLives,
      );
      expect(capped.config.livesPerPlayer, NeverHaveIEverConfig.maxLives);

      final floored = await _emitUntil(
        bloc,
        const NeverHaveIEverSetupLivesCountChanged(0),
        (s) => s.config.livesPerPlayer == NeverHaveIEverConfig.minLives,
      );
      expect(floored.config.livesPerPlayer, NeverHaveIEverConfig.minLives);

      await bloc.close();
    });

    test('buildSetup produces a matching NeverHaveIEverSetup', () async {
      final bloc = NeverHaveIEverSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      await _emitUntil(
        bloc,
        const NeverHaveIEverSetupLivesCountChanged(5),
        (s) => s.config.livesPerPlayer == 5,
      );

      expect(bloc.state.canStart, isTrue);
      final setup = bloc.state.buildSetup();
      expect(setup.players.length, NeverHaveIEverConfig.minPlayers);
      expect(setup.config.livesPerPlayer, 5);

      await bloc.close();
    });
  });

  test('the deck language is carried into the setup', () async {
    final bloc = NeverHaveIEverSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );
    expect(bloc.state.config.language, PromptLanguage.english);

    final hinglish = await _emitUntil(
      bloc,
      const NeverHaveIEverSetupLanguageChanged(PromptLanguage.hinglish),
      (s) => s.config.language == PromptLanguage.hinglish,
    );
    expect(hinglish.buildSetup().config.language, PromptLanguage.hinglish);

    await bloc.close();
  });
}
