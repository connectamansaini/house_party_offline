import 'package:equatable/equatable.dart';

/// A participant in a game. Pure domain object — no persistence concerns here.
class Player extends Equatable {
  const Player({
    required this.id,
    required this.name,
    this.cumulativeScore = 0,
  });

  final String id;
  final String name;

  /// Running total across all rounds played in the current session.
  final int cumulativeScore;

  Player copyWith({String? id, String? name, int? cumulativeScore}) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      cumulativeScore: cumulativeScore ?? this.cumulativeScore,
    );
  }

  /// Returns a copy with [delta] added to the running score.
  Player addScore(int delta) =>
      copyWith(cumulativeScore: cumulativeScore + delta);

  @override
  List<Object?> get props => [id, name, cumulativeScore];
}
