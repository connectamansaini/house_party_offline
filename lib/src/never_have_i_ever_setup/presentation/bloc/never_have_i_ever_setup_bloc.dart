import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';

part 'never_have_i_ever_setup_event.dart';
part 'never_have_i_ever_setup_state.dart';

/// Drives the Never Have I Ever setup form: roster and lives count.
///
/// Nothing to load — the roster is seeded fresh on every visit, so the
/// initial state is computed directly rather than via a `Started` event.
class NeverHaveIEverSetupBloc
    extends Bloc<NeverHaveIEverSetupEvent, NeverHaveIEverSetupState> {
  NeverHaveIEverSetupBloc()
    : super(
        NeverHaveIEverSetupState(
          players: _defaultRoster(NeverHaveIEverConfig.minPlayers),
        ),
      ) {
    on<NeverHaveIEverSetupPlayerAdded>(_onPlayerAdded);
    on<NeverHaveIEverSetupPlayerRemoved>(_onPlayerRemoved);
    on<NeverHaveIEverSetupPlayerRenamed>(_onPlayerRenamed);
    on<NeverHaveIEverSetupLivesCountChanged>(_onLivesCountChanged);
  }

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
