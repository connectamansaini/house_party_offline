import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/custom_prompt_deck.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import 'package:house_party_offline/src/roster/domain/roster_seed.dart';

part 'never_have_i_ever_setup_event.dart';
part 'never_have_i_ever_setup_state.dart';

/// Drives the Never Have I Ever setup form: roster and lives count.
///
/// Seeds numbered defaults synchronously, then [NeverHaveIEverSetupStarted]
/// swaps in the shared roster's names if any are saved.
class NeverHaveIEverSetupBloc
    extends Bloc<NeverHaveIEverSetupEvent, NeverHaveIEverSetupState> {
  NeverHaveIEverSetupBloc(this._roster, this._customPrompts)
    : super(
        NeverHaveIEverSetupState(
          players: _defaultRoster(NeverHaveIEverConfig.minPlayers),
        ),
      ) {
    on<NeverHaveIEverSetupPlayerAdded>(_onPlayerAdded);
    on<NeverHaveIEverSetupPlayerRemoved>(_onPlayerRemoved);
    on<NeverHaveIEverSetupPlayerRenamed>(_onPlayerRenamed);
    on<NeverHaveIEverSetupLivesCountChanged>(_onLivesCountChanged);
    on<NeverHaveIEverSetupStarted>(_onStarted);
    on<NeverHaveIEverSetupRosterSaved>(_onRosterSaved);
    on<NeverHaveIEverSetupIncludeCustomPromptsChanged>(
      _onIncludeCustomPromptsChanged,
    );
    on<NeverHaveIEverSetupLanguageChanged>(_onLanguageChanged);
  }

  final RosterRepository _roster;
  final CustomPromptsRepository _customPrompts;

  void _onLanguageChanged(
    NeverHaveIEverSetupLanguageChanged event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) {
    emit(
      state.copyWith(config: state.config.copyWith(language: event.language)),
    );
  }

  Future<void> _onStarted(
    NeverHaveIEverSetupStarted event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) async {
    final saved = await _roster.loadNames();
    final custom = await _customPrompts.load(kNeverHaveIEverPromptDeckId);
    emit(
      state.copyWith(
        players: saved.isEmpty
            ? state.players
            : [
                for (final name in seedRosterNames(
                  saved,
                  min: NeverHaveIEverConfig.minPlayers,
                  max: NeverHaveIEverConfig.maxPlayers,
                ))
                  NeverHaveIEverPlayer(id: newId(), name: name),
              ],
        customPrompts: [for (final p in custom) p.text],
      ),
    );
  }

  void _onIncludeCustomPromptsChanged(
    NeverHaveIEverSetupIncludeCustomPromptsChanged event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) {
    emit(
      state.copyWith(
        config: state.config.copyWith(includeCustomPrompts: event.enabled),
      ),
    );
  }

  Future<void> _onRosterSaved(
    NeverHaveIEverSetupRosterSaved event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) => _roster.saveNames([for (final p in state.players) p.name]);

  void _onPlayerAdded(
    NeverHaveIEverSetupPlayerAdded event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) {
    if (state.players.length >= NeverHaveIEverConfig.maxPlayers) return;
    emit(
      state.copyWith(
        players: [
          ...state.players,
          NeverHaveIEverPlayer(
            id: newId(),
            name: 'Player ${state.players.length + 1}',
          ),
        ],
      ),
    );
  }

  void _onPlayerRemoved(
    NeverHaveIEverSetupPlayerRemoved event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) {
    emit(
      state.copyWith(
        players: state.players.where((p) => p.id != event.id).toList(),
      ),
    );
  }

  void _onPlayerRenamed(
    NeverHaveIEverSetupPlayerRenamed event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) {
    emit(
      state.copyWith(
        players: [
          for (final p in state.players)
            if (p.id == event.id) p.copyWith(name: event.name) else p,
        ],
      ),
    );
  }

  void _onLivesCountChanged(
    NeverHaveIEverSetupLivesCountChanged event,
    Emitter<NeverHaveIEverSetupState> emit,
  ) {
    final count = event.count.clamp(
      NeverHaveIEverConfig.minLives,
      NeverHaveIEverConfig.maxLives,
    );
    emit(state.copyWith(config: state.config.copyWith(livesPerPlayer: count)));
  }

  static List<NeverHaveIEverPlayer> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      NeverHaveIEverPlayer(id: newId(), name: 'Player ${i + 1}'),
  ];
}
