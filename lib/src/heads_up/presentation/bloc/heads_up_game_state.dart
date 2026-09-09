part of 'heads_up_game_bloc.dart';

/// Where a turn is. [over] is terminal.
enum HeadsUpPhase { ready, countdown, playing, summary, over }

/// One judged word from the current turn.
typedef HeadsUpGuess = ({String word, bool correct});

class HeadsUpGameState extends Equatable {
  const HeadsUpGameState({
    required this.session,
    this.phase = HeadsUpPhase.ready,
    this.secondsLeft = 0,
    this.currentWord,
    this.turnGuesses = const [],
  });

  final HeadsUpSession session;
  final HeadsUpPhase phase;

  /// Countdown seconds during [HeadsUpPhase.countdown]; clock seconds during
  /// [HeadsUpPhase.playing].
  final int secondsLeft;

  /// The word on the forehead; null outside [HeadsUpPhase.playing].
  final String? currentWord;

  /// Every word judged so far this turn, in order.
  final List<HeadsUpGuess> turnGuesses;

  int get turnScore => turnGuesses.where((g) => g.correct).length;

  HeadsUpGameState copyWith({
    HeadsUpSession? session,
    HeadsUpPhase? phase,
    int? secondsLeft,
    String? currentWord,
    bool clearWord = false,
    List<HeadsUpGuess>? turnGuesses,
  }) {
    return HeadsUpGameState(
      session: session ?? this.session,
      phase: phase ?? this.phase,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      currentWord: clearWord ? null : (currentWord ?? this.currentWord),
      turnGuesses: turnGuesses ?? this.turnGuesses,
    );
  }

  @override
  List<Object?> get props => [
    session,
    phase,
    secondsLeft,
    currentWord,
    turnGuesses,
  ];
}
