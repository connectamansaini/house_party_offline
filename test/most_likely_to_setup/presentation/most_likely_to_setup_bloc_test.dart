import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/most_likely_to/domain/custom_prompt_deck.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/bloc/most_likely_to_setup_bloc.dart';
import '../../helpers/fake_custom_prompts_repository.dart';
import '../../helpers/fake_roster_repository.dart';

Future<MostLikelyToSetupState> _emitUntil(
  MostLikelyToSetupBloc bloc,
  MostLikelyToSetupEvent event,
  bool Function(MostLikelyToSetupState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  group('custom prompts', () {
    test(
      'Started loads them, and the include switch gates buildSetup',
      () async {
        final prompts = FakeCustomPromptsRepository({
          kMostLikelyToPromptDeckId: const [
            CustomPrompt(id: 'c1', text: 'Most likely to nap'),
          ],
        });
        final bloc = MostLikelyToSetupBloc(FakeRosterRepository(), prompts);

        final loaded = await _emitUntil(
          bloc,
          const MostLikelyToSetupStarted(),
          (s) => s.customPromptCount == 1,
        );
        expect(loaded.buildSetup().customPrompts, ['Most likely to nap']);

        final excluded = await _emitUntil(
          bloc,
          const MostLikelyToSetupIncludeCustomPromptsChanged(enabled: false),
          (s) => !s.config.includeCustomPrompts,
        );
        expect(excluded.customPromptCount, 1);
        expect(excluded.buildSetup().customPrompts, isEmpty);

        await bloc.close();
      },
    );
  });

  group('roster', () {
    test('Started seeds the saved roster, padded to the minimum', () async {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(['Ann', 'Bo']),
        FakeCustomPromptsRepository(),
      );

      final s = await _emitUntil(
        bloc,
        const MostLikelyToSetupStarted(),
        (s) => s.players.first.name == 'Ann',
      );

      expect(s.players.map((p) => p.name), ['Ann', 'Bo', 'Player 3']);
      await bloc.close();
    });

    test('RosterSaved writes the current names', () async {
      final roster = FakeRosterRepository();
      final bloc = MostLikelyToSetupBloc(roster, FakeCustomPromptsRepository())
        ..add(const MostLikelyToSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);

      expect(roster.stored, ['Player 1', 'Player 2', 'Player 3']);
      await bloc.close();
    });
  });

  group('initial state', () {
    test('seeds the minimum default roster', () {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      expect(bloc.state.players.length, MostLikelyToConfig.minPlayers);
      expect(
        bloc.state.players.map((p) => p.name),
        List.generate(
          MostLikelyToConfig.minPlayers,
          (i) => 'Player ${i + 1}',
        ),
      );
      expect(bloc.state.config.roundCount, 10);
      bloc.close();
    });
  });

  group('players', () {
    test('addPlayer appends up to the max', () async {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      final before = bloc.state.players.length;

      final s = await _emitUntil(
        bloc,
        const MostLikelyToSetupPlayerAdded(),
        (s) => s.players.length == before + 1,
      );
      expect(s.players.length, before + 1);

      await bloc.close();
    });

    test('addPlayer is capped at maxPlayers', () async {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      for (var i = 0; i < 20; i++) {
        bloc.add(const MostLikelyToSetupPlayerAdded());
      }
      await bloc.stream.firstWhere(
        (s) => s.players.length == MostLikelyToConfig.maxPlayers,
      );
      expect(bloc.state.players.length, MostLikelyToConfig.maxPlayers);

      await bloc.close();
    });

    test('removePlayer removes the target', () async {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      final firstId = bloc.state.players.first.id;

      final s = await _emitUntil(
        bloc,
        MostLikelyToSetupPlayerRemoved(firstId),
        (s) => s.players.length == MostLikelyToConfig.minPlayers - 1,
      );

      expect(s.players.any((p) => p.id == firstId), isFalse);
      expect(s.canStart, isFalse);
      await bloc.close();
    });

    test('renamePlayer updates only the target', () async {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      final id = bloc.state.players[1].id;

      final s = await _emitUntil(
        bloc,
        MostLikelyToSetupPlayerRenamed(id: id, name: 'Alice'),
        (s) => s.players[1].name == 'Alice',
      );

      expect(s.players[1].name, 'Alice');
      expect(s.players[0].name, 'Player 1');

      await bloc.close();
    });
  });

  group('config', () {
    test('setRoundCount clamps within min/max', () async {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );

      final capped = await _emitUntil(
        bloc,
        const MostLikelyToSetupRoundCountChanged(99),
        (s) => s.config.roundCount == MostLikelyToConfig.maxRounds,
      );
      expect(capped.config.roundCount, MostLikelyToConfig.maxRounds);

      final floored = await _emitUntil(
        bloc,
        const MostLikelyToSetupRoundCountChanged(0),
        (s) => s.config.roundCount == MostLikelyToConfig.minRounds,
      );
      expect(floored.config.roundCount, MostLikelyToConfig.minRounds);

      await bloc.close();
    });

    test('buildSetup produces a matching MostLikelyToSetup', () async {
      final bloc = MostLikelyToSetupBloc(
        FakeRosterRepository(),
        FakeCustomPromptsRepository(),
      );
      await _emitUntil(
        bloc,
        const MostLikelyToSetupRoundCountChanged(15),
        (s) => s.config.roundCount == 15,
      );

      expect(bloc.state.canStart, isTrue);
      final setup = bloc.state.buildSetup();
      expect(setup.players.length, MostLikelyToConfig.minPlayers);
      expect(setup.config.roundCount, 15);

      await bloc.close();
    });
  });

  test('the deck language is carried into the setup', () async {
    final bloc = MostLikelyToSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );
    expect(bloc.state.config.language, PromptLanguage.english);

    final hinglish = await _emitUntil(
      bloc,
      const MostLikelyToSetupLanguageChanged(PromptLanguage.hinglish),
      (s) => s.config.language == PromptLanguage.hinglish,
    );
    expect(hinglish.buildSetup().config.language, PromptLanguage.hinglish);

    await bloc.close();
  });
}
