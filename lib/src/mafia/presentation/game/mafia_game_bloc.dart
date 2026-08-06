import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/engine/mafia_engine.dart';
import '../../domain/entities/mafia_role.dart';
import '../../domain/entities/mafia_session.dart';
import '../../domain/entities/mafia_setup.dart';
import 'mafia_game_event.dart';
import 'mafia_game_state.dart';

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
    );
    return MafiaRoleReveal(session, currentIndex: 0);
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
        emit(MafiaNight(r.session, currentIndex: 0));
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
    if (state case final MafiaNight n
        when n.isRevealed && n.investigationReveal == null) {
      emit(n.copyWith(selectedId: event.playerId));
    }
  }

  void _onNightActionConfirmed(
    NightActionConfirmed event,
    Emitter<MafiaGameState> emit,
  ) {
    if (state case final MafiaNight n when n.isRevealed) {
      switch (n.currentRole) {
        case MafiaRole.villager:
          _advanceNight(n, emit);
        case MafiaRole.mafia:
          if (n.selectedId == null) return;
          _advanceNight(
            n.copyWith(mafiaPicks: {...n.mafiaPicks, n.currentPlayer.id: n.selectedId!}),
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
    if (state case final MafiaNight n when n.investigationReveal != null) {
      _advanceNight(n, emit);
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
    final killTarget = _engine.resolveMafiaKill(n.mafiaPicks);
    final resolution = _engine.resolveNight(
      killTarget: killTarget,
      doctorProtect: n.doctorProtectId,
      isFirstNight: n.session.nightNumber == 1,
      config: n.session.config,
    );
    var session = n.session;
    if (resolution.killedId != null) {
      session = session.kill(resolution.killedId!);
    }
    emit(
      MafiaNightRecap(
        session,
        resolution: resolution,
        winner: _engine.winner(session.roles, session.aliveIds),
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
            MafiaNight(
              l.session.copyWith(nightNumber: l.session.nightNumber + 1),
              currentIndex: 0,
            ),
          );
        }
      default:
        break;
    }
  }
}
