import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_setup.dart';

/// Mutable form state for the Mafia setup flow.
class MafiaSetupState extends Equatable {
  const MafiaSetupState({
    this.players = const [],
    this.config = const MafiaConfig(),
  });

  final List<MafiaPlayer> players;
  final MafiaConfig config;

  int get maxMafia => MafiaConfig.maxMafia(players.length);

  bool get hasEnoughPlayers =>
      players.length >= MafiaConfig.minPlayers &&
      players.length <= MafiaConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart =>
      hasEnoughPlayers &&
      allNamesFilled &&
      config.mafiaCount >= 1 &&
      config.mafiaCount <= maxMafia;

  MafiaSetup buildSetup() => MafiaSetup(players: players, config: config);

  MafiaSetupState copyWith({List<MafiaPlayer>? players, MafiaConfig? config}) {
    return MafiaSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [players, config];
}

/// Drives the Mafia setup form: roster and match options.
class MafiaSetupCubit extends Cubit<MafiaSetupState> {
  MafiaSetupCubit() : super(const MafiaSetupState()) {
    emit(state.copyWith(players: _defaultRoster(MafiaConfig.minPlayers)));
  }

  void addPlayer() {
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

  void removePlayer(String id) {
    final players = state.players.where((p) => p.id != id).toList();
    emit(
      state.copyWith(
        players: players,
        config: state.config.copyWith(
          mafiaCount: _clampMafia(state.config.mafiaCount, players.length),
        ),
      ),
    );
  }

  void renamePlayer(String id, String name) {
    emit(
      state.copyWith(
        players: [
          for (final p in state.players)
            if (p.id == id) p.copyWith(name: name) else p,
        ],
      ),
    );
  }

  void setMafiaCount(int count) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          mafiaCount: _clampMafia(count, state.players.length),
        ),
      ),
    );
  }

  void setRevealRolesOnDeath({required bool value}) => emit(
    state.copyWith(config: state.config.copyWith(revealRolesOnDeath: value)),
  );

  void setFirstNightKill({required bool value}) => emit(
    state.copyWith(config: state.config.copyWith(firstNightKill: value)),
  );

  void setDoctorSelfSave({required bool value}) => emit(
    state.copyWith(config: state.config.copyWith(doctorSelfSave: value)),
  );

  void setDetectiveExactRole({required bool value}) => emit(
    state.copyWith(config: state.config.copyWith(detectiveExactRole: value)),
  );

  List<MafiaPlayer> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      MafiaPlayer(id: newId(), name: 'Player ${i + 1}'),
  ];

  int _clampMafia(int count, int playerCount) =>
      count.clamp(1, MafiaConfig.maxMafia(playerCount));
}
