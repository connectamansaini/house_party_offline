import 'package:equatable/equatable.dart';

/// Which side won a round.
enum WinningSide { civilian, imposter }

/// The outcome of a resolved round, including per-player score changes to apply
/// to cumulative totals.
class RoundResult extends Equatable {
  const RoundResult({
    required this.winningSide,
    required this.votedOutId,
    required this.imposterGuessedRight,
    required this.scoreDeltas,
  });

  final WinningSide winningSide;

  /// The player the group voted out this round.
  final String votedOutId;

  /// True only when a caught imposter guessed the secret word to steal the win.
  final bool imposterGuessedRight;

  /// Points to add to each player's cumulative score (0 for the losing side).
  final Map<String, int> scoreDeltas;

  @override
  List<Object?> get props => [
    winningSide,
    votedOutId,
    imposterGuessedRight,
    scoreDeltas,
  ];
}
