part of 'heads_up_game_bloc.dart';

sealed class HeadsUpGameEvent extends Equatable {
  const HeadsUpGameEvent();

  @override
  List<Object?> get props => [];
}

/// The current player is ready: run the countdown, then start the clock.
class HeadsUpTurnStarted extends HeadsUpGameEvent {
  const HeadsUpTurnStarted();
}

/// The word on screen was guessed (or given up on); the next one is drawn.
/// Sent by the on-screen buttons and by tilt gestures alike.
class HeadsUpWordJudged extends HeadsUpGameEvent {
  const HeadsUpWordJudged({required this.correct});

  final bool correct;

  @override
  List<Object?> get props => [correct];
}

/// The turn summary was dismissed; on to the next player, or the results.
class HeadsUpTurnFinished extends HeadsUpGameEvent {
  const HeadsUpTurnFinished();
}

class _HeadsUpCountdownTicked extends HeadsUpGameEvent {
  const _HeadsUpCountdownTicked(this.secondsLeft);

  final int secondsLeft;

  @override
  List<Object?> get props => [secondsLeft];
}

class _HeadsUpClockTicked extends HeadsUpGameEvent {
  const _HeadsUpClockTicked(this.secondsLeft);

  final int secondsLeft;

  @override
  List<Object?> get props => [secondsLeft];
}
