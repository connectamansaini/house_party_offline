import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:house_party_offline/src/imposter/domain/engine/round_engine.dart';
import 'package:house_party_offline/src/imposter/domain/entities/game_session.dart';
import 'package:house_party_offline/src/imposter/domain/entities/game_setup.dart';
import 'package:house_party_offline/src/imposter/domain/entities/round_assignment.dart';
import 'package:house_party_offline/src/imposter/presentation/game/game_event.dart';
import 'package:house_party_offline/src/imposter/presentation/game/game_state.dart';

/// Finite state machine for a full imposter game. Deals the first round on
/// creation and drives the phases: reveal → discussion → voting →
/// (guessing) → result → next round / game over.
///
/// Game rules live in [RoundEngine]; this bloc only orchestrates transitions,
/// runs the discussion timer, and applies score deltas to the session.
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required GameSetup setup, required RoundEngine engine})
    : _engine = engine,
      super(_dealFirstRound(setup, engine)) {
    on<RoleRevealed>(_onRoleRevealed);
    on<RolePassed>(_onRolePassed);
    on<DiscussionTicked>(_onDiscussionTicked);
    on<DiscussionSkipped>(_onDiscussionSkipped);
    on<VoteSelected>(_onVoteSelected);
    on<VoteConfirmed>(_onVoteConfirmed);
    on<BallotOpened>(_onBallotOpened);
    on<BallotSelected>(_onBallotSelected);
    on<BallotCast>(_onBallotCast);
    on<ImposterGuessSubmitted>(_onImposterGuessSubmitted);
    on<NextRoundRequested>(_onNextRoundRequested);
    on<GameEnded>(_onGameEnded);
  }

  final RoundEngine _engine;
  Timer? _timer;

  static RoleReveal _dealFirstRound(GameSetup setup, RoundEngine engine) {
    final session = GameSession(
      players: setup.players,
      config: setup.config,
    );
    final assignment = engine.assignRoles(session.players, session.config);
    return RoleReveal(session, assignment: assignment, currentIndex: 0);
  }

  void _onRoleRevealed(RoleRevealed event, Emitter<GameState> emit) {
    if (state case final RoleReveal r when !r.isRevealed) {
      emit(r.copyWith(isRevealed: true));
    }
  }

  void _onRolePassed(RolePassed event, Emitter<GameState> emit) {
    if (state case final RoleReveal r) {
      if (r.isLastPlayer) {
        emit(
          Discussion(
            r.session,
            assignment: r.assignment,
            remaining: r.session.config.discussionTime,
          ),
        );
        _startTimer();
      } else {
        emit(r.copyWith(currentIndex: r.currentIndex + 1, isRevealed: false));
      }
    }
  }

  void _onDiscussionTicked(DiscussionTicked event, Emitter<GameState> emit) {
    if (state case final Discussion d) {
      final next = d.remaining - const Duration(seconds: 1);
      if (next <= Duration.zero) {
        _stopTimer();
        _startVoting(d.session, d.assignment, emit);
      } else {
        emit(d.copyWith(remaining: next));
      }
    }
  }

  void _onDiscussionSkipped(DiscussionSkipped event, Emitter<GameState> emit) {
    if (state case final Discussion d) {
      _stopTimer();
      _startVoting(d.session, d.assignment, emit);
    }
  }

  /// Enters the voting phase — a shared vote or a secret pass-and-play ballot,
  /// depending on the game config.
  void _startVoting(
    GameSession session,
    RoundAssignment assignment,
    Emitter<GameState> emit,
  ) {
    if (session.config.secretVoting) {
      emit(SecretVoting(session, assignment: assignment, currentVoterIndex: 0));
    } else {
      emit(Voting(session, assignment: assignment));
    }
  }

  void _onVoteSelected(VoteSelected event, Emitter<GameState> emit) {
    if (state case final Voting v) {
      emit(
        Voting(v.session, assignment: v.assignment, selectedId: event.playerId),
      );
    }
  }

  void _onVoteConfirmed(VoteConfirmed event, Emitter<GameState> emit) {
    if (state case final Voting v when v.selectedId != null) {
      _afterVote(v.session, v.assignment, v.selectedId!, emit);
    }
  }

  void _onBallotOpened(BallotOpened event, Emitter<GameState> emit) {
    if (state case final SecretVoting sv when !sv.isVoterReady) {
      emit(sv.copyWith(isVoterReady: true));
    }
  }

  void _onBallotSelected(BallotSelected event, Emitter<GameState> emit) {
    if (state case final SecretVoting sv when sv.isVoterReady) {
      emit(sv.copyWith(selectedId: event.playerId));
    }
  }

  void _onBallotCast(BallotCast event, Emitter<GameState> emit) {
    if (state case final SecretVoting sv when sv.selectedId != null) {
      final ballots = {...sv.ballots, sv.currentVoter.id: sv.selectedId!};
      if (sv.isLastVoter) {
        final votedOutId = _engine.tallyVotes(ballots);
        _afterVote(sv.session, sv.assignment, votedOutId, emit);
      } else {
        emit(
          sv.copyWith(
            currentVoterIndex: sv.currentVoterIndex + 1,
            ballots: ballots,
            isVoterReady: false,
            clearSelection: true,
          ),
        );
      }
    }
  }

  /// Shared post-vote branch: a caught imposter guesses, otherwise resolve.
  void _afterVote(
    GameSession session,
    RoundAssignment assignment,
    String votedOutId,
    Emitter<GameState> emit,
  ) {
    if (_engine.wasImposterCaught(assignment, votedOutId)) {
      emit(
        ImposterGuessing(
          session,
          assignment: assignment,
          votedOutId: votedOutId,
        ),
      );
    } else {
      emit(_resolve(session, assignment, votedOutId, null));
    }
  }

  void _onImposterGuessSubmitted(
    ImposterGuessSubmitted event,
    Emitter<GameState> emit,
  ) {
    if (state case final ImposterGuessing g) {
      emit(_resolve(g.session, g.assignment, g.votedOutId, event.guess));
    }
  }

  void _onNextRoundRequested(
    NextRoundRequested event,
    Emitter<GameState> emit,
  ) {
    final next = state.session.copyWith(
      roundNumber: state.session.roundNumber + 1,
    );
    final assignment = _engine.assignRoles(next.players, next.config);
    emit(RoleReveal(next, assignment: assignment, currentIndex: 0));
  }

  void _onGameEnded(GameEnded event, Emitter<GameState> emit) {
    _stopTimer();
    emit(GameOver(state.session));
  }

  /// Resolves the round via the engine and applies score deltas to the roster.
  RoundResultState _resolve(
    GameSession session,
    RoundAssignment assignment,
    String votedOutId,
    String? guess,
  ) {
    final result = _engine.resolveRound(
      assignment: assignment,
      votedOutId: votedOutId,
      config: session.config,
      imposterGuess: guess,
    );
    final updatedPlayers = [
      for (final p in session.players)
        p.addScore(result.scoreDeltas[p.id] ?? 0),
    ];
    return RoundResultState(
      session.copyWith(players: updatedPlayers),
      assignment: assignment,
      result: result,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const DiscussionTicked()),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
