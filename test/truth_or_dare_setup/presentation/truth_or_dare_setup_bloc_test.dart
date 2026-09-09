import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/custom_prompt_deck.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare_setup/presentation/bloc/truth_or_dare_setup_bloc.dart';
import '../../helpers/fake_custom_prompts_repository.dart';
import '../../helpers/fake_roster_repository.dart';

Future<TruthOrDareSetupState> _emitUntil(
  TruthOrDareSetupBloc bloc,
  TruthOrDareSetupEvent event,
  bool Function(TruthOrDareSetupState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  group('custom prompts', () {
    test(
      'Started loads both decks and buildSetup honours the switch',
      () async {
        final prompts = FakeCustomPromptsRepository({
          kTruthOrDareTruthDeckId: const [
            CustomPrompt(id: 't', text: 'A truth'),
          ],
          kTruthOrDareDareDeckId: const [
            CustomPrompt(id: 'd1', text: 'Dare one'),
            CustomPrompt(id: 'd2', text: 'Dare two'),
          ],
        });
        final bloc = TruthOrDareSetupBloc(FakeRosterRepository(), prompts);

        final loaded = await _emitUntil(
          bloc,
          const TruthOrDareSetupStarted(),
          (s) => s.customPromptCount == 3,
        );
        expect(loaded.buildSetup().customTruths, ['A truth']);
        expect(loaded.buildSetup().customDares, ['Dare one', 'Dare two']);

        final excluded = await _emitUntil(
          bloc,
          const TruthOrDareSetupIncludeCustomPromptsChanged(enabled: false),
          (s) => !s.config.includeCustomPrompts,
        );
        expect(excluded.buildSetup().customTruths, isEmpty);
        expect(excluded.buildSetup().customDares, isEmpty);

        await bloc.close();
      },
    );
  });

  group('roster', () {
    test('Started seeds the saved roster, cut to the maximum', () async {
      final names = List.generate(15, (i) => 'P$i');
      final bloc = TruthOrDareSetupBloc(
        FakeRosterRepository(names),
        FakeCustomPromptsRepository(),
      );

      final s = await _emitUntil(
        bloc,
        const TruthOrDareSetupStarted(),
        (s) => s.players.first.name == 'P0',
      );

      expect(s.players.length, TruthOrDareConfig.maxPlayers);
      expect(s.players.last.name, 'P11');
      await bloc.close();
    });

    test('RosterSaved writes the current names', () async {
      final roster = FakeRosterRepository();
      final bloc = TruthOrDareSetupBloc(roster, FakeCustomPromptsRepository())
        ..add(const TruthOrDareSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);

      expect(roster.stored, ['Player 1', 'Player 2']);
      await bloc.close();
    });
  });

  test('seeds the minimum roster with mild, three-round defaults', () {
    final bloc = TruthOrDareSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );
    expect(bloc.state.players.length, TruthOrDareConfig.minPlayers);
    expect(bloc.state.config.roundCount, 3);
    expect(bloc.state.config.level, TruthOrDareLevel.mild);
    expect(bloc.state.canStart, isTrue);
    bloc.close();
  });

  test('addPlayer is capped at maxPlayers', () async {
    final bloc = TruthOrDareSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );
    for (var i = 0; i < 20; i++) {
      bloc.add(const TruthOrDareSetupPlayerAdded());
    }
    await bloc.stream.firstWhere(
      (s) => s.players.length == TruthOrDareConfig.maxPlayers,
    );
    expect(bloc.state.players.length, TruthOrDareConfig.maxPlayers);
    await bloc.close();
  });

  test('removing below the minimum blocks starting', () async {
    final bloc = TruthOrDareSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );
    final firstId = bloc.state.players.first.id;

    final s = await _emitUntil(
      bloc,
      TruthOrDareSetupPlayerRemoved(firstId),
      (s) => s.players.length == TruthOrDareConfig.minPlayers - 1,
    );

    expect(s.canStart, isFalse);
    await bloc.close();
  });

  test('renamePlayer updates only the target', () async {
    final bloc = TruthOrDareSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );
    final id = bloc.state.players[1].id;

    final s = await _emitUntil(
      bloc,
      TruthOrDareSetupPlayerRenamed(id: id, name: 'Alice'),
      (s) => s.players[1].name == 'Alice',
    );

    expect(s.players[0].name, 'Player 1');
    await bloc.close();
  });

  test('round count clamps and level switches', () async {
    final bloc = TruthOrDareSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );

    final capped = await _emitUntil(
      bloc,
      const TruthOrDareSetupRoundCountChanged(99),
      (s) => s.config.roundCount == TruthOrDareConfig.maxRounds,
    );
    expect(capped.config.roundCount, TruthOrDareConfig.maxRounds);

    final spicy = await _emitUntil(
      bloc,
      const TruthOrDareSetupLevelChanged(TruthOrDareLevel.spicy),
      (s) => s.config.level == TruthOrDareLevel.spicy,
    );
    expect(spicy.buildSetup().config.level, TruthOrDareLevel.spicy);
    expect(spicy.buildSetup().config.roundCount, TruthOrDareConfig.maxRounds);

    await bloc.close();
  });

  test('the deck language is carried into the setup', () async {
    final bloc = TruthOrDareSetupBloc(
      FakeRosterRepository(),
      FakeCustomPromptsRepository(),
    );
    expect(bloc.state.config.language, PromptLanguage.english);

    final hinglish = await _emitUntil(
      bloc,
      const TruthOrDareSetupLanguageChanged(PromptLanguage.hinglish),
      (s) => s.config.language == PromptLanguage.hinglish,
    );
    expect(hinglish.buildSetup().config.language, PromptLanguage.hinglish);

    await bloc.close();
  });
}
