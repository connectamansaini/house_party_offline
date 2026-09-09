import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/engine/never_have_i_ever_engine.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/prompts.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/prompts_hinglish.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/bloc/never_have_i_ever_game_bloc.dart';

void main() {
  const players = [
    NeverHaveIEverPlayer(id: 'p0', name: 'Ann'),
    NeverHaveIEverPlayer(id: 'p1', name: 'Bo'),
  ];

  test('deals from the English deck by default', () async {
    final bloc = NeverHaveIEverGameBloc(
      setup: const NeverHaveIEverSetup(
        players: players,
        config: NeverHaveIEverConfig(),
      ),
      engine: const NeverHaveIEverEngine(),
    );
    expect(kNeverHaveIEverPrompts, contains(bloc.state.session.currentPrompt));
    await bloc.close();
  });

  test('deals from the Hinglish deck when asked', () async {
    final bloc = NeverHaveIEverGameBloc(
      setup: const NeverHaveIEverSetup(
        players: players,
        config: NeverHaveIEverConfig(language: PromptLanguage.hinglish),
      ),
      engine: const NeverHaveIEverEngine(),
    );
    expect(
      kNeverHaveIEverPromptsHinglish,
      contains(bloc.state.session.currentPrompt),
    );
    await bloc.close();
  });
}
