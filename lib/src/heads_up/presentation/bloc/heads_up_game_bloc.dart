import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/heads_up/domain/engine/heads_up_engine.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_session.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_setup.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_ticker.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';

part 'heads_up_game_event.dart';
part 'heads_up_game_state.dart';

/// Drives a single Heads Up match. A turn is a small state machine —
/// ready → countdown → playing → summary — repeated per player; the
/// engine owns the deck and scores, the bloc owns the clock and the
/// current word.
class HeadsUpGameBloc extends Bloc<HeadsUpGameEvent, HeadsUpGameState> {
  HeadsUpGameBloc({
    required HeadsUpSetup setup,
    required HeadsUpEngine engine,
    required HeadsUpTicker ticker,
    required HeadsUpTiltSensor tilt,
  }) : _engine = engine,
       _ticker = ticker,
       _tilt = tilt,
       _roundSeconds = setup.config.roundSeconds,
       super(
         HeadsUpGameState(
           session: engine.deal(setup.players, setup.config, setup.words),
         ),
       ) {
    on<HeadsUpTurnStarted>(_onTurnStarted);
    on<_HeadsUpCountdownTicked>(_onCountdownTicked);
    on<_HeadsUpClockTicked>(_onClockTicked);
    on<HeadsUpWordJudged>(_onWordJudged);
    on<HeadsUpTurnFinished>(_onTurnFinished);
  }

  final HeadsUpEngine _engine;
  final HeadsUpTicker _ticker;
  final HeadsUpTiltSensor _tilt;
  final int _roundSeconds;

  /// The full clock length, so the UI can scale its progress bar.
  int get roundSeconds => _roundSeconds;

  StreamSubscription<int>? _clock;
  StreamSubscription<HeadsUpTilt>? _gestures;

  void _onTurnStarted(
    HeadsUpTurnStarted event,
    Emitter<HeadsUpGameState> emit,
  ) {
    if (state.phase != HeadsUpPhase.ready) return;
    emit(
      state.copyWith(
        phase: HeadsUpPhase.countdown,
        secondsLeft: HeadsUpConfig.countdownSeconds,
      ),
    );
    _listenToClock(HeadsUpConfig.countdownSeconds, _HeadsUpCountdownTicked.new);
  }

  void _onCountdownTicked(
    _HeadsUpCountdownTicked event,
    Emitter<HeadsUpGameState> emit,
  ) {
    if (event.secondsLeft > 0) {
      emit(state.copyWith(secondsLeft: event.secondsLeft));
      return;
    }
    // Countdown done: draw the first word and start the real clock.
    final drawn = _engine.draw(state.session);
    emit(
      state.copyWith(
        phase: HeadsUpPhase.playing,
        session: drawn.session,
        currentWord: drawn.word,
        secondsLeft: _roundSeconds,
        turnGuesses: const [],
      ),
    );
    _listenToClock(_roundSeconds, _HeadsUpClockTicked.new);
    _gestures = _tilt.gestures.listen(
      (tilt) => add(HeadsUpWordJudged(correct: tilt == HeadsUpTilt.correct)),
    );
  }

  void _onClockTicked(
    _HeadsUpClockTicked event,
    Emitter<HeadsUpGameState> emit,
  ) {
    if (event.secondsLeft > 0) {
      emit(state.copyWith(secondsLeft: event.secondsLeft));
      return;
    }
    _stopListening();
    emit(
      state.copyWith(
        phase: HeadsUpPhase.summary,
        secondsLeft: 0,
        session: _engine.endTurn(state.session),
        clearWord: true,
      ),
    );
  }

  void _onWordJudged(HeadsUpWordJudged event, Emitter<HeadsUpGameState> emit) {
    if (state.phase != HeadsUpPhase.playing || state.currentWord == null) {
      return;
    }
    final judged = _engine.judge(state.session, correct: event.correct);
    final drawn = _engine.draw(judged);
    emit(
      state.copyWith(
        session: drawn.session,
        currentWord: drawn.word,
        turnGuesses: [
          ...state.turnGuesses,
          (word: state.currentWord!, correct: event.correct),
        ],
      ),
    );
  }

  void _onTurnFinished(
    HeadsUpTurnFinished event,
    Emitter<HeadsUpGameState> emit,
  ) {
    if (state.phase != HeadsUpPhase.summary) return;
    emit(
      state.copyWith(
        phase: state.session.isOver ? HeadsUpPhase.over : HeadsUpPhase.ready,
        turnGuesses: const [],
      ),
    );
  }

  void _listenToClock(int seconds, HeadsUpGameEvent Function(int) toEvent) {
    _clock?.cancel();
    _clock = _ticker
        .tick(seconds: seconds)
        .listen((secondsLeft) => add(toEvent(secondsLeft)));
  }

  void _stopListening() {
    _clock?.cancel();
    _clock = null;
    _gestures?.cancel();
    _gestures = null;
  }

  @override
  Future<void> close() {
    _stopListening();
    return super.close();
  }
}
