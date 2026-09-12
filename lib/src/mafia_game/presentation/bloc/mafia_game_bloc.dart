import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_night_step.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_session.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';

/// Finite state machine for a full Mafia match: reveal → night (pass-and-play
/// actions) → morning recap → day lynch vote → recap → next night, until a
/// faction wins.
///
/// Rules live in [MafiaEngine]; this bloc orchestrates the phases and applies
/// deaths to the session.
class MafiaGameBloc extends Bloc<MafiaGameEvent, MafiaGameState> {
  MafiaGameBloc({required MafiaSetup setup, required MafiaEngine engine})
    : _engine = engine,
      super(_deal(setup, engine)) {
    on<RoleRevealed>(_onRoleRevealed);
    on<RolePassed>(_onRolePassed);
    on<NightActorRevealed>(_onNightActorRevealed);
    on<NightTargetSelected>(_onNightTargetSelected);
    on<NightActionConfirmed>(_onNightActionConfirmed);
    on<NightInvestigationSeen>(_onNightInvestigationSeen);
    on<DayTargetSelected>(_onDayTargetSelected);
    on<DayVoteConfirmed>(_onDayVoteConfirmed);
    on<DaySkipped>(_onDaySkipped);
    on<RecapContinued>(_onRecapContinued);
  }

  final MafiaEngine _engine;

  static MafiaRoleReveal _deal(MafiaSetup setup, MafiaEngine engine) {
    final roles = engine.assignRoles(setup.players, setup.config);
    final session = MafiaSession.initial(
      players: setup.players,
      roles: roles,
      config: setup.config,
      host: setup.host,
    );
    return MafiaRoleReveal(session, currentIndex: 0);
  }

  /// The night that follows [session]: a host-run script, or the
  /// pass-and-play round when nobody is narrating.
  MafiaGameState _startNight(MafiaSession session) {
    if (!session.isHosted) return MafiaNight(session, currentIndex: 0);
    return MafiaHostNight(
      session,
      steps: _engine.nightSteps(session.roles, session.aliveIds),
    );
  }

  // --- Reveal ---------------------------------------------------------------

  void _onRoleRevealed(RoleRevealed event, Emitter<MafiaGameState> emit) {
    if (state case final MafiaRoleReveal r when !r.isRevealed) {
      emit(r.copyWith(isRevealed: true));
    }
  }

  void _onRolePassed(RolePassed event, Emitter<MafiaGameState> emit) {
    if (state case final MafiaRoleReveal r) {
      if (r.isLastPlayer) {
        emit(_startNight(r.session));
      } else {
        emit(r.copyWith(currentIndex: r.currentIndex + 1, isRevealed: false));
      }
    }
  }

  // --- Night ----------------------------------------------------------------

  void _onNightActorRevealed(
    NightActorRevealed event,
    Emitter<MafiaGameState> emit,
  ) {
    if (state case final MafiaNight n when !n.isRevealed) {
      emit(n.copyWith(isRevealed: true));
    }
  }

  void _onNightTargetSelected(
    NightTargetSelected event,
    Emitter<MafiaGameState> emit,
  ) {
    switch (state) {
      case final MafiaNight n
          when n.isRevealed && n.investigationReveal == null:
        emit(n.copyWith(selectedId: event.playerId));
      case final MafiaHostNight h when h.investigationReveal == null:
        emit(h.copyWith(selectedId: event.playerId));
      default:
        break;
    }
  }

  void _onNightActionConfirmed(
    NightActionConfirmed event,
    Emitter<MafiaGameState> emit,
  ) {
    if (state case final MafiaHostNight h) {
      _onHostStepConfirmed(h, emit);
      return;
    }
    if (state case final MafiaNight n when n.isRevealed) {
      switch (n.currentRole) {
        case MafiaRole.villager:
          _advanceNight(n, emit);
        case MafiaRole.mafia:
          if (n.selectedId == null) return;
          _advanceNight(
            n.copyWith(
              mafiaPicks: {...n.mafiaPicks, n.currentPlayer.id: n.selectedId!},
            ),
            emit,
          );
        case MafiaRole.doctor:
          if (n.selectedId == null) return;
          _advanceNight(n.copyWith(doctorProtectId: n.selectedId), emit);
        case MafiaRole.detective:
          if (n.selectedId == null) return;
          final target = n.session.playerOf(n.selectedId!);
          final result = _engine.investigationResult(
            n.session.roleOf(target.id),
            n.session.config,
          );
          emit(n.copyWith(investigationReveal: '${target.name} is $result'));
      }
    }
  }

  void _onNightInvestigationSeen(
    NightInvestigationSeen event,
    Emitter<MafiaGameState> emit,
  ) {
    switch (state) {
      case final MafiaNight n when n.investigationReveal != null:
        _advanceNight(n, emit);
      case final MafiaHostNight h when h.investigationReveal != null:
        _advanceHostNight(h, emit);
      default:
        break;
    }
  }

  // --- Host-run night -------------------------------------------------------

  void _onHostStepConfirmed(MafiaHostNight h, Emitter<MafiaGameState> emit) {
    switch (h.step) {
      case MafiaNightStep.sleep:
        _advanceHostNight(h, emit);
      case MafiaNightStep.mafia:
        if (h.selectedId == null) return;
        _advanceHostNight(h.copyWith(mafiaTargetId: h.selectedId), emit);
      case MafiaNightStep.doctor:
        if (h.selectedId == null) return;
        _advanceHostNight(h.copyWith(doctorProtectId: h.selectedId), emit);
      case MafiaNightStep.detective:
        if (h.selectedId == null) return;
        final target = h.session.playerOf(h.selectedId!);
        final result = _engine.investigationResult(
          h.session.roleOf(target.id),
          h.session.config,
        );
        emit(h.copyWith(investigationReveal: '${target.name} is $result'));
    }
  }

  /// Moves to the next beat of the host's script, or resolves the night
  /// after the last one.
  void _advanceHostNight(MafiaHostNight h, Emitter<MafiaGameState> emit) {
    if (h.isLastStep) {
      _emitNightRecap(
        h.session,
        killTarget: h.mafiaTargetId,
        doctorProtect: h.doctorProtectId,
        emit: emit,
      );
    } else {
      emit(
        h.copyWith(
          stepIndex: h.stepIndex + 1,
          clearSelection: true,
          clearInvestigation: true,
        ),
      );
    }
  }

  /// Moves to the next living player, or resolves the night after the last.
  void _advanceNight(MafiaNight n, Emitter<MafiaGameState> emit) {
    if (n.currentIndex >= n.session.livingPlayers.length - 1) {
      _resolveNight(n, emit);
    } else {
      emit(
        n.copyWith(
          currentIndex: n.currentIndex + 1,
          isRevealed: false,
          clearSelection: true,
          clearInvestigation: true,
        ),
      );
    }
  }

  void _resolveNight(MafiaNight n, Emitter<MafiaGameState> emit) {
    _emitNightRecap(
      n.session,
      killTarget: _engine.resolveMafiaKill(n.mafiaPicks),
      doctorProtect: n.doctorProtectId,
      emit: emit,
    );
  }

  /// Applies the night's actions to [session] and emits the morning recap.
  void _emitNightRecap(
    MafiaSession session, {
    required String? killTarget,
    required String? doctorProtect,
    required Emitter<MafiaGameState> emit,
  }) {
    final resolution = _engine.resolveNight(
      killTarget: killTarget,
      doctorProtect: doctorProtect,
      isFirstNight: session.nightNumber == 1,
      config: session.config,
    );
    var next = session;
    if (resolution.killedId != null) {
      next = next.kill(resolution.killedId!);
    }
    emit(
      MafiaNightRecap(
        next,
        resolution: resolution,
        winner: _engine.winner(next.roles, next.aliveIds),
      ),
    );
  }

  // --- Day ------------------------------------------------------------------

  void _onDayTargetSelected(
    DayTargetSelected event,
    Emitter<MafiaGameState> emit,
  ) {
    if (state case final MafiaDayVote d) {
      emit(d.copyWith(selectedId: event.playerId));
    }
  }

  void _onDayVoteConfirmed(
    DayVoteConfirmed event,
    Emitter<MafiaGameState> emit,
  ) {
    if (state case final MafiaDayVote d when d.selectedId != null) {
      final session = d.session.kill(d.selectedId!);
      emit(
        MafiaLynchRecap(
          session,
          lynchedId: d.selectedId,
          winner: _engine.winner(session.roles, session.aliveIds),
        ),
      );
    }
  }

  void _onDaySkipped(DaySkipped event, Emitter<MafiaGameState> emit) {
    if (state case final MafiaDayVote d) {
      emit(
        MafiaLynchRecap(
          d.session,
          winner: _engine.winner(d.session.roles, d.session.aliveIds),
        ),
      );
    }
  }

  // --- Recap routing --------------------------------------------------------

  void _onRecapContinued(RecapContinued event, Emitter<MafiaGameState> emit) {
    switch (state) {
      case final MafiaNightRecap r:
        if (r.winner != null) {
          emit(MafiaGameOver(r.session, winner: r.winner!));
        } else {
          emit(MafiaDayVote(r.session));
        }
      case final MafiaLynchRecap l:
        if (l.winner != null) {
          emit(MafiaGameOver(l.session, winner: l.winner!));
        } else {
          emit(
            _startNight(
              l.session.copyWith(nightNumber: l.session.nightNumber + 1),
            ),
          );
        }
      default:
        break;
    }
  }
}
