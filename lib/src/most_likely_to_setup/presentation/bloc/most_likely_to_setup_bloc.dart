import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';
import 'package:house_party_offline/src/most_likely_to/domain/custom_prompt_deck.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import 'package:house_party_offline/src/roster/domain/roster_seed.dart';

part 'most_likely_to_setup_event.dart';
part 'most_likely_to_setup_state.dart';

/// Drives the Most Likely To setup form: roster and round count.
///
/// Seeds numbered defaults synchronously, then [MostLikelyToSetupStarted]
/// swaps in the shared roster's names if any are saved.
class MostLikelyToSetupBloc
    extends Bloc<MostLikelyToSetupEvent, MostLikelyToSetupState> {
  MostLikelyToSetupBloc(this._roster, this._customPrompts)
    : super(
        MostLikelyToSetupState(
          players: _defaultRoster(MostLikelyToConfig.minPlayers),
        ),
      ) {
    on<MostLikelyToSetupPlayerAdded>(_onPlayerAdded);
    on<MostLikelyToSetupPlayerRemoved>(_onPlayerRemoved);
    on<MostLikelyToSetupPlayerRenamed>(_onPlayerRenamed);
    on<MostLikelyToSetupRoundCountChanged>(_onRoundCountChanged);
    on<MostLikelyToSetupStarted>(_onStarted);
    on<MostLikelyToSetupRosterSaved>(_onRosterSaved);
    on<MostLikelyToSetupIncludeCustomPromptsChanged>(
      _onIncludeCustomPromptsChanged,
    );
  }

  final RosterRepository _roster;
  final CustomPromptsRepository _customPrompts;

  Future<void> _onStarted(
    MostLikelyToSetupStarted event,
    Emitter<MostLikelyToSetupState> emit,
  ) async {
    final saved = await _roster.loadNames();
    final custom = await _customPrompts.load(kMostLikelyToPromptDeckId);
    emit(
      state.copyWith(
        players: saved.isEmpty
            ? state.players
            : [
                for (final name in seedRosterNames(
                  saved,
                  min: MostLikelyToConfig.minPlayers,
                  max: MostLikelyToConfig.maxPlayers,
                ))
                  MostLikelyToPlayer(id: newId(), name: name),
              ],
        customPrompts: [for (final p in custom) p.text],
      ),
    );
  }

  void _onIncludeCustomPromptsChanged(
    MostLikelyToSetupIncludeCustomPromptsChanged event,
    Emitter<MostLikelyToSetupState> emit,
  ) {
    emit(
      state.copyWith(
        config: state.config.copyWith(includeCustomPrompts: event.enabled),
      ),
    );
  }

  Future<void> _onRosterSaved(
    MostLikelyToSetupRosterSaved event,
    Emitter<MostLikelyToSetupState> emit,
  ) => _roster.saveNames([for (final p in state.players) p.name]);

  void _onPlayerAdded(
    MostLikelyToSetupPlayerAdded event,
    Emitter<MostLikelyToSetupState> emit,
  ) {
    if (state.players.length >= MostLikelyToConfig.maxPlayers) return;
    emit(
      state.copyWith(
        players: [
          ...state.players,
          MostLikelyToPlayer(
            id: newId(),
            name: 'Player ${state.players.length + 1}',
          ),
        ],
      ),
    );
  }

  void _onPlayerRemoved(
    MostLikelyToSetupPlayerRemoved event,
    Emitter<MostLikelyToSetupState> emit,
  ) {
    emit(
      state.copyWith(
        players: state.players.where((p) => p.id != event.id).toList(),
      ),
    );
  }

  void _onPlayerRenamed(
    MostLikelyToSetupPlayerRenamed event,
    Emitter<MostLikelyToSetupState> emit,
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

  void _onRoundCountChanged(
    MostLikelyToSetupRoundCountChanged event,
    Emitter<MostLikelyToSetupState> emit,
  ) {
    final count = event.count.clamp(
      MostLikelyToConfig.minRounds,
      MostLikelyToConfig.maxRounds,
    );
    emit(state.copyWith(config: state.config.copyWith(roundCount: count)));
  }

  static List<MostLikelyToPlayer> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      MostLikelyToPlayer(id: newId(), name: 'Player ${i + 1}'),
  ];
}
