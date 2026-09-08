import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';

part 'most_likely_to_setup_event.dart';
part 'most_likely_to_setup_state.dart';

/// Drives the Most Likely To setup form: roster and round count.
///
/// Nothing to load — the roster is seeded fresh on every visit, so the
/// initial state is computed directly rather than via a `Started` event.
class MostLikelyToSetupBloc
    extends Bloc<MostLikelyToSetupEvent, MostLikelyToSetupState> {
  MostLikelyToSetupBloc()
    : super(
        MostLikelyToSetupState(
          players: _defaultRoster(MostLikelyToConfig.minPlayers),
        ),
      ) {
    on<MostLikelyToSetupPlayerAdded>(_onPlayerAdded);
    on<MostLikelyToSetupPlayerRemoved>(_onPlayerRemoved);
    on<MostLikelyToSetupPlayerRenamed>(_onPlayerRenamed);
    on<MostLikelyToSetupRoundCountChanged>(_onRoundCountChanged);
  }

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
