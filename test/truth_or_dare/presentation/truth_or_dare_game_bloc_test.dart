import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/engine/truth_or_dare_engine.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_kind.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/prompts.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/prompts_hinglish.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/bloc/truth_or_dare_game_bloc.dart';

void main() {
  const players = [
    TruthOrDarePlayer(id: 'p0', name: 'Ann'),
    TruthOrDarePlayer(id: 'p1', name: 'Bo'),
  ];

  Future<String?> firstTruth(TruthOrDareConfig config) async {
    final bloc = TruthOrDareGameBloc(
      setup: TruthOrDareSetup(players: players, config: config),
      engine: const TruthOrDareEngine(),
    );
    final drawn = bloc.stream.firstWhere((s) => s.prompt != null);
    bloc.add(const TruthOrDareKindChosen(TruthOrDareKind.truth));
    final prompt = (await drawn).prompt;
    await bloc.close();
    return prompt;
  }

  test('draws from the English decks by default', () async {
    expect(kMildTruths, contains(await firstTruth(const TruthOrDareConfig())));
  });

  test('draws from the Hinglish decks when asked', () async {
    expect(
      kMildTruthsHinglish,
      contains(
        await firstTruth(
          const TruthOrDareConfig(language: PromptLanguage.hinglish),
        ),
      ),
    );
  });
}
