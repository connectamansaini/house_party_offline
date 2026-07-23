import 'package:equatable/equatable.dart';

/// Events driving the imposter game state machine.
sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// The current player taps to reveal their secret role.
class RoleRevealed extends GameEvent {
  const RoleRevealed();
}

/// The current player hides their role and passes the phone on. Advances to the
/// next player, or to discussion once everyone has seen their role.
class RolePassed extends GameEvent {
  const RolePassed();
}

/// One-second tick of the discussion countdown.
class DiscussionTicked extends GameEvent {
  const DiscussionTicked();
}

/// Skip the remaining discussion time and go straight to voting.
class DiscussionSkipped extends GameEvent {
  const DiscussionSkipped();
}

/// The group highlights a candidate to vote out (not yet confirmed).
class VoteSelected extends GameEvent {
  const VoteSelected(this.playerId);

  final String playerId;

  @override
  List<Object?> get props => [playerId];
}

/// Confirm the selected vote and resolve the round (or move to the guess step).
class VoteConfirmed extends GameEvent {
  const VoteConfirmed();
}

/// Secret voting: the current voter takes the phone and opens their ballot.
class BallotOpened extends GameEvent {
  const BallotOpened();
}

/// Secret voting: the current voter tentatively selects a suspect.
class BallotSelected extends GameEvent {
  const BallotSelected(this.playerId);

  final String playerId;

  @override
  List<Object?> get props => [playerId];
}

/// Secret voting: the current voter confirms their ballot and passes on. After
/// the last voter, the tally decides who is eliminated.
class BallotCast extends GameEvent {
  const BallotCast();
}

/// A caught imposter submits their guess of the secret word. An empty guess
/// counts as giving up.
class ImposterGuessSubmitted extends GameEvent {
  const ImposterGuessSubmitted(this.guess);

  final String guess;

  @override
  List<Object?> get props => [guess];
}

/// Deal and start the next round.
class NextRoundRequested extends GameEvent {
  const NextRoundRequested();
}

/// End the game and show the final scoreboard.
class GameEnded extends GameEvent {
  const GameEnded();
}
