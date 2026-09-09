import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';

part 'truth_or_dare_setup_event.dart';
part 'truth_or_dare_setup_state.dart';

/// Drives the Truth or Dare setup form: roster, round count and spice level.
///
/// Nothing to load — the roster is seeded fresh on every visit, so the
/// initial state is computed directly rather than via a `Started` event.
class TruthOrDareSetupBloc
    extends Bloc<TruthOrDareSetupEvent, TruthOrDareSetupState> {
  TruthOrDareSetupBloc()
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
  }

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
