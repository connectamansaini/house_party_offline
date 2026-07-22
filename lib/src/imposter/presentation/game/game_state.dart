import 'package:equatable/equatable.dart';

import '../../domain/entities/game_session.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/round_assignment.dart';
import '../../domain/entities/round_result.dart';

/// States of the imposter game FSM. Every state carries the [GameSession] so
/// the UI always has the roster, config, and round number.
sealed class GameState extends Equatable {
  const GameState(this.session);

  final GameSession session;

  @override
  List<Object?> get props => [session];
}

/// Pass-and-play role reveal. Each player privately views their role, then
/// passes on. [isRevealed] toggles the "pass to X" cover vs. the role card.
class RoleReveal extends GameState {
  const RoleReveal(
    super.session, {
    required this.assignment,
    required this.currentIndex,
    this.isRevealed = false,
  });

  final RoundAssignment assignment;
  final int currentIndex;
  final bool isRevealed;

  Player get currentPlayer => session.players[currentIndex];
  bool get isLastPlayer => currentIndex == session.players.length - 1;

  RoleReveal copyWith({int? currentIndex, bool? isRevealed}) {
    return RoleReveal(
      session,
      assignment: assignment,
      currentIndex: currentIndex ?? this.currentIndex,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  @override
  List<Object?> get props => [session, assignment, currentIndex, isRevealed];
}

/// The timed discussion phase.
class Discussion extends GameState {
  const Discussion(
    super.session, {
    required this.assignment,
    required this.remaining,
  });

  final RoundAssignment assignment;
  final Duration remaining;

  Discussion copyWith({Duration? remaining}) {
    return Discussion(
      session,
      assignment: assignment,
      remaining: remaining ?? this.remaining,
    );
  }

  @override
  List<Object?> get props => [session, assignment, remaining];
}

/// The group votes one player out. [selectedId] is the current highlight.
class Voting extends GameState {
  const Voting(super.session, {required this.assignment, this.selectedId});

  final RoundAssignment assignment;
  final String? selectedId;

  Voting copyWith({String? selectedId}) {
    return Voting(
      session,
      assignment: assignment,
      selectedId: selectedId ?? this.selectedId,
    );
  }

  @override
  List<Object?> get props => [session, assignment, selectedId];
}

/// A caught imposter gets one guess of the secret word to steal the win.
class ImposterGuessing extends GameState {
  const ImposterGuessing(
    super.session, {
    required this.assignment,
    required this.votedOutId,
  });

  final RoundAssignment assignment;
  final String votedOutId;

  Player get guesser =>
      session.players.firstWhere((p) => p.id == votedOutId);

  @override
  List<Object?> get props => [session, assignment, votedOutId];
}

/// The resolved round. [session] already reflects the applied score deltas.
class RoundResultState extends GameState {
  const RoundResultState(
    super.session, {
    required this.assignment,
    required this.result,
  });

  final RoundAssignment assignment;
  final RoundResult result;

  List<Player> get imposters => session.players
      .where((p) => assignment.imposterIds.contains(p.id))
      .toList();

  Player get votedOut =>
      session.players.firstWhere((p) => p.id == result.votedOutId);

  @override
  List<Object?> get props => [session, assignment, result];
}

/// The game is over; show final standings.
class GameOver extends GameState {
  const GameOver(super.session);
}
