part of 'most_likely_to_game_bloc.dart';

sealed class MostLikelyToGameEvent extends Equatable {
  const MostLikelyToGameEvent();

  @override
  List<Object?> get props => [];
}

/// Toggles whether a player was pointed at for the current prompt.
class MostLikelyToPlayerToggled extends MostLikelyToGameEvent {
  const MostLikelyToPlayerToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Awards a point to everyone selected and advances to the next prompt.
class MostLikelyToRoundConfirmed extends MostLikelyToGameEvent {
  const MostLikelyToRoundConfirmed();
}
