import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';

part 'mafia_setup_event.dart';
part 'mafia_setup_state.dart';

/// Drives the Mafia setup form: roster and match options.
///
/// Unlike the Imposter setup, there is nothing to load — the roster is
/// seeded fresh on every visit, so the initial state is computed directly
/// rather than via a `Started` event.
class MafiaSetupBloc extends Bloc<MafiaSetupEvent, MafiaSetupState> {
  MafiaSetupBloc()
    : super(MafiaSetupState(players: _defaultRoster(MafiaConfig.minPlayers))) {
    on<MafiaSetupPlayerAdded>(_onPlayerAdded);
    on<MafiaSetupPlayerRemoved>(_onPlayerRemoved);
    on<MafiaSetupPlayerRenamed>(_onPlayerRenamed);
    on<MafiaSetupMafiaCountChanged>(_onMafiaCountChanged);
    on<MafiaSetupRevealRolesOnDeathChanged>(_onRevealRolesOnDeathChanged);
    on<MafiaSetupFirstNightKillChanged>(_onFirstNightKillChanged);
    on<MafiaSetupDoctorSelfSaveChanged>(_onDoctorSelfSaveChanged);
    on<MafiaSetupDetectiveExactRoleChanged>(_onDetectiveExactRoleChanged);
  }

  void _onPlayerAdded(
    MafiaSetupPlayerAdded event,
    Emitter<MafiaSetupState> emit,
  ) {
    if (state.players.length >= MafiaConfig.maxPlayers) return;
    emit(
      state.copyWith(
        players: [
          ...state.players,
          MafiaPlayer(id: newId(), name: 'Player ${state.players.length + 1}'),
        ],
      ),
    );
  }

  void _onPlayerRemoved(
    MafiaSetupPlayerRemoved event,
    Emitter<MafiaSetupState> emit,
  ) {
    final players = state.players.where((p) => p.id != event.id).toList();
    emit(
      state.copyWith(
        players: players,
        config: state.config.copyWith(
          mafiaCount: _clampMafia(state.config.mafiaCount, players.length),
        ),
      ),
    );
  }

  void _onPlayerRenamed(
    MafiaSetupPlayerRenamed event,
    Emitter<MafiaSetupState> emit,
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

  void _onMafiaCountChanged(
    MafiaSetupMafiaCountChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          mafiaCount: _clampMafia(event.count, state.players.length),
        ),
      ),
    );
  }

  void _onRevealRolesOnDeathChanged(
    MafiaSetupRevealRolesOnDeathChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(
      state.copyWith(
        config: state.config.copyWith(revealRolesOnDeath: event.enabled),
      ),
    );
  }

  void _onFirstNightKillChanged(
    MafiaSetupFirstNightKillChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(
      state.copyWith(
        config: state.config.copyWith(firstNightKill: event.enabled),
      ),
    );
  }

  void _onDoctorSelfSaveChanged(
    MafiaSetupDoctorSelfSaveChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(
      state.copyWith(
        config: state.config.copyWith(doctorSelfSave: event.enabled),
      ),
    );
  }

  void _onDetectiveExactRoleChanged(
    MafiaSetupDetectiveExactRoleChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(
      state.copyWith(
        config: state.config.copyWith(detectiveExactRole: event.enabled),
      ),
    );
  }

  static List<MafiaPlayer> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      MafiaPlayer(id: newId(), name: 'Player ${i + 1}'),
  ];

  static int _clampMafia(int count, int playerCount) =>
      count.clamp(1, MafiaConfig.maxMafia(playerCount));
}
