import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import 'package:house_party_offline/src/roster/domain/roster_seed.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';

part 'truth_or_dare_setup_event.dart';
part 'truth_or_dare_setup_state.dart';

/// Drives the Truth or Dare setup form: roster, round count and spice level.
///
/// Seeds numbered defaults synchronously, then [TruthOrDareSetupStarted]
/// swaps in the shared roster's names if any are saved.
class TruthOrDareSetupBloc
    extends Bloc<TruthOrDareSetupEvent, TruthOrDareSetupState> {
  TruthOrDareSetupBloc(this._roster)
    : super(
        TruthOrDareSetupState(
          players: _defaultRoster(TruthOrDareConfig.minPlayers),
        ),
      ) {
    on<TruthOrDareSetupPlayerAdded>(_onPlayerAdded);
    on<TruthOrDareSetupPlayerRemoved>(_onPlayerRemoved);
    on<TruthOrDareSetupPlayerRenamed>(_onPlayerRenamed);
    on<TruthOrDareSetupRoundCountChanged>(_onRoundCountChanged);
    on<TruthOrDareSetupLevelChanged>(_onLevelChanged);
    on<TruthOrDareSetupStarted>(_onStarted);
    on<TruthOrDareSetupRosterSaved>(_onRosterSaved);
  }

  final RosterRepository _roster;

  Future<void> _onStarted(
    TruthOrDareSetupStarted event,
    Emitter<TruthOrDareSetupState> emit,
  ) async {
    final saved = await _roster.loadNames();
    if (saved.isEmpty) return;
    emit(
      state.copyWith(
        players: [
          for (final name in seedRosterNames(
            saved,
            min: TruthOrDareConfig.minPlayers,
            max: TruthOrDareConfig.maxPlayers,
          ))
            TruthOrDarePlayer(id: newId(), name: name),
        ],
      ),
    );
  }

  Future<void> _onRosterSaved(
    TruthOrDareSetupRosterSaved event,
    Emitter<TruthOrDareSetupState> emit,
  ) => _roster.saveNames([for (final p in state.players) p.name]);

  void _onPlayerAdded(
    TruthOrDareSetupPlayerAdded event,
    Emitter<TruthOrDareSetupState> emit,
  ) {
    if (state.players.length >= TruthOrDareConfig.maxPlayers) return;
    emit(
      state.copyWith(
        players: [
          ...state.players,
          TruthOrDarePlayer(
            id: newId(),
            name: 'Player ${state.players.length + 1}',
          ),
        ],
      ),
    );
  }

  void _onPlayerRemoved(
    TruthOrDareSetupPlayerRemoved event,
    Emitter<TruthOrDareSetupState> emit,
  ) {
    emit(
      state.copyWith(
        players: state.players.where((p) => p.id != event.id).toList(),
      ),
    );
  }

  void _onPlayerRenamed(
    TruthOrDareSetupPlayerRenamed event,
    Emitter<TruthOrDareSetupState> emit,
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
    TruthOrDareSetupRoundCountChanged event,
    Emitter<TruthOrDareSetupState> emit,
  ) {
    final count = event.count.clamp(
      TruthOrDareConfig.minRounds,
      TruthOrDareConfig.maxRounds,
    );
    emit(state.copyWith(config: state.config.copyWith(roundCount: count)));
  }

  void _onLevelChanged(
    TruthOrDareSetupLevelChanged event,
    Emitter<TruthOrDareSetupState> emit,
  ) {
    emit(state.copyWith(config: state.config.copyWith(level: event.level)));
  }

  static List<TruthOrDarePlayer> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      TruthOrDarePlayer(id: newId(), name: 'Player ${i + 1}'),
  ];
}
