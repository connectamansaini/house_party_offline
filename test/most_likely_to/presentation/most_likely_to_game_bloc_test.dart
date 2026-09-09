import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/most_likely_to/domain/prompts.dart';
import 'package:house_party_offline/src/most_likely_to/domain/prompts_hinglish.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/bloc/most_likely_to_game_bloc.dart';

void main() {
  const players = [
    MostLikelyToPlayer(id: 'p0', name: 'Ann'),
    MostLikelyToPlayer(id: 'p1', name: 'Bo'),
    MostLikelyToPlayer(id: 'p2', name: 'Cy'),
  ];

  test('deals from the English deck by default', () async {
    final bloc = MostLikelyToGameBloc(
      setup: const MostLikelyToSetup(
        players: players,
        config: MostLikelyToConfig(),
      ),
      engine: const MostLikelyToEngine(),
    );
    expect(kMostLikelyToPrompts, contains(bloc.state.session.currentPrompt));
    await bloc.close();
  });

  test('deals from the Hinglish deck when asked', () async {
    final bloc = MostLikelyToGameBloc(
      setup: const MostLikelyToSetup(
        players: players,
        config: MostLikelyToConfig(language: PromptLanguage.hinglish),
      ),
      engine: const MostLikelyToEngine(),
    );
    expect(
      kMostLikelyToPromptsHinglish,
      contains(bloc.state.session.currentPrompt),
    );
    await bloc.close();
  });
}
