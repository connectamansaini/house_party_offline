import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_setup/domain/entities/mafia_host_preferences.dart';
import 'package:house_party_offline/src/mafia_setup/domain/host_rotation.dart';
import 'package:house_party_offline/src/mafia_setup/domain/repositories/mafia_host_preferences_repository.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import 'package:house_party_offline/src/roster/domain/roster_seed.dart';

part 'mafia_setup_event.dart';
part 'mafia_setup_state.dart';

/// Drives the Mafia setup form: roster and match options.
///
/// Seeds numbered defaults synchronously, then [MafiaSetupStarted] swaps in
/// the shared roster's names if any are saved.
class MafiaSetupBloc extends Bloc<MafiaSetupEvent, MafiaSetupState> {
  MafiaSetupBloc(this._roster, this._hostPreferences)
    : super(MafiaSetupState(players: _defaultRoster(MafiaConfig.minPlayers))) {
    on<MafiaSetupStarted>(_onStarted);
    on<MafiaSetupRosterSaved>(_onRosterSaved);
    on<MafiaSetupPlayerAdded>(_onPlayerAdded);
    on<MafiaSetupPlayerRemoved>(_onPlayerRemoved);
    on<MafiaSetupPlayerRenamed>(_onPlayerRenamed);
    on<MafiaSetupHostModeChanged>(_onHostModeChanged);
    on<MafiaSetupHostChanged>(_onHostChanged);
    on<MafiaSetupRotateHostChanged>(_onRotateHostChanged);
    on<MafiaSetupMafiaCountChanged>(_onMafiaCountChanged);
    on<MafiaSetupIncludeDoctorChanged>(_onIncludeDoctorChanged);
    on<MafiaSetupIncludeDetectiveChanged>(_onIncludeDetectiveChanged);
    on<MafiaSetupRevealRolesOnDeathChanged>(_onRevealRolesOnDeathChanged);
    on<MafiaSetupFirstNightKillChanged>(_onFirstNightKillChanged);
    on<MafiaSetupDoctorSelfSaveChanged>(_onDoctorSelfSaveChanged);
    on<MafiaSetupDetectiveExactRoleChanged>(_onDetectiveExactRoleChanged);
  }

  final RosterRepository _roster;
  final MafiaHostPreferencesRepository _hostPreferences;

  /// Opens the form on the shared roster and on however the last game was
  /// narrated — including handing the job to the next person when the host
  /// rotates.
  Future<void> _onStarted(
    MafiaSetupStarted event,
    Emitter<MafiaSetupState> emit,
  ) async {
    final saved = await _roster.loadNames();
    final prefs = await _hostPreferences.load();
    final hosted = prefs.enabled;

    // A narrator takes a seat of their own, so the roster needs one more
    // name than the game itself.
    final names = seedRosterNames(
      saved.isEmpty ? [for (final p in state.players) p.name] : saved,
      min: MafiaConfig.minPlayers + (hosted ? 1 : 0),
      max: MafiaConfig.maxPlayers + (hosted ? 1 : 0),
    );
    final players = [
      for (var i = 0; i < names.length; i++)
        if (i < state.players.length)
          state.players[i].copyWith(name: names[i])
        else
          MafiaPlayer(id: newId(), name: names[i]),
    ];

    final hostName = hosted
        ? nextHostName(
            names,
            lastHost: prefs.lastHostName,
            rotate: prefs.rotate,
          )
        : null;
    final hostIndex = hostName == null ? -1 : names.indexOf(hostName);

    emit(
      _reconciled(
        state.copyWith(
          players: players,
          rotateHost: prefs.rotate,
          hostId: hostIndex < 0 ? null : players[hostIndex].id,
          clearHost: hostIndex < 0,
        ),
      ),
    );
  }

  Future<void> _onRosterSaved(
    MafiaSetupRosterSaved event,
    Emitter<MafiaSetupState> emit,
  ) async {
    await _roster.saveNames([for (final p in state.players) p.name]);
    await _hostPreferences.save(
      MafiaHostPreferences(
        enabled: state.isHosted,
        rotate: state.rotateHost,
        lastHostName: state.host?.name,
      ),
    );
  }

  void _onRotateHostChanged(
    MafiaSetupRotateHostChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(state.copyWith(rotateHost: event.enabled));
  }

  void _onPlayerAdded(
    MafiaSetupPlayerAdded event,
    Emitter<MafiaSetupState> emit,
  ) {
    if (state.players.length >= state.rosterCapacity) return;
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
    emit(_reconciled(state.copyWith(players: players)));
  }

  void _onHostModeChanged(
    MafiaSetupHostModeChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    if (!event.enabled) {
      emit(_reconciled(state.copyWith(clearHost: true)));
      return;
    }
    if (state.players.isEmpty) return;
    emit(_reconciled(state.copyWith(hostId: state.players.first.id)));
  }

  void _onHostChanged(
    MafiaSetupHostChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    if (!state.players.any((p) => p.id == event.id)) return;
    emit(_reconciled(state.copyWith(hostId: event.id)));
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
          mafiaCount: _clampMafia(event.count, state.config, state.playerCount),
        ),
      ),
    );
  }

  void _onIncludeDoctorChanged(
    MafiaSetupIncludeDoctorChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(
      _reconciled(
        state.copyWith(
          config: state.config.copyWith(includeDoctor: event.enabled),
        ),
      ),
    );
  }

  void _onIncludeDetectiveChanged(
    MafiaSetupIncludeDetectiveChanged event,
    Emitter<MafiaSetupState> emit,
  ) {
    emit(
      _reconciled(
        state.copyWith(
          config: state.config.copyWith(includeDetective: event.enabled),
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

  /// Keeps the narrator pick and the mafia count valid after the roster or
  /// the host changes: a removed narrator hands the job to the first player
  /// left, and the mafia count re-clamps to the new player count.
  static MafiaSetupState _reconciled(MafiaSetupState next) {
    var state = next;
    if (state.hostId != null && state.host == null) {
      state = state.players.isEmpty
          ? state.copyWith(clearHost: true)
          : state.copyWith(hostId: state.players.first.id);
    }
    return state.copyWith(
      config: state.config.copyWith(
        mafiaCount: _clampMafia(
          state.config.mafiaCount,
          state.config,
          state.playerCount,
        ),
      ),
    );
  }

  static List<MafiaPlayer> _defaultRoster(int count) => [
    for (var i = 0; i < count; i++)
      MafiaPlayer(id: newId(), name: 'Player ${i + 1}'),
  ];

  static int _clampMafia(int count, MafiaConfig config, int playerCount) =>
      count.clamp(1, config.maxMafiaFor(playerCount));
}
