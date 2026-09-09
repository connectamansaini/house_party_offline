import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/heads_up/domain/engine/heads_up_engine.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_setup.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';
import 'package:house_party_offline/src/heads_up/presentation/bloc/heads_up_game_bloc.dart';

import '../../helpers/fake_heads_up_clock.dart';

const _setup = HeadsUpSetup(
  players: [
    HeadsUpPlayer(id: 'p1', name: 'Ann'),
    HeadsUpPlayer(id: 'p2', name: 'Bo'),
  ],
  config: HeadsUpConfig(roundSeconds: 30),
  words: ['cat', 'dog', 'owl'],
);

Future<HeadsUpGameState> _until(
  HeadsUpGameBloc bloc,
  bool Function(HeadsUpGameState s) predicate,
) => bloc.stream.firstWhere(predicate);

void main() {
  late ManualHeadsUpTicker ticker;
  late ManualTiltSensor tilt;
  late HeadsUpGameBloc bloc;

  setUp(() {
    ticker = ManualHeadsUpTicker();
    tilt = ManualTiltSensor();
    bloc = HeadsUpGameBloc(
      setup: _setup,
      engine: const HeadsUpEngine(),
      ticker: ticker,
      tilt: tilt,
    );
  });

  tearDown(() async {
    await bloc.close();
    await tilt.controller.close();
  });

  /// Start → countdown → playing, returning the first playing state.
  Future<HeadsUpGameState> startTurn() async {
    final counting = _until(bloc, (s) => s.phase == HeadsUpPhase.countdown);
    bloc.add(const HeadsUpTurnStarted());
    await counting;
    expect(ticker.requested.last, HeadsUpConfig.countdownSeconds);

    final playing = _until(bloc, (s) => s.phase == HeadsUpPhase.playing);
    ticker.runDown(from: HeadsUpConfig.countdownSeconds);
    return playing;
  }

  test('a turn runs countdown → playing with the round clock', () async {
    final s = await startTurn();

    expect(s.secondsLeft, 30);
    expect(s.currentWord, isNotNull);
    expect(ticker.requested, [HeadsUpConfig.countdownSeconds, 30]);
  });

  test('judging a word scores it, records it, and draws the next', () async {
    final playing = await startTurn();
    final first = playing.currentWord!;

    final judged = _until(bloc, (s) => s.turnGuesses.length == 1);
    bloc.add(const HeadsUpWordJudged(correct: true));
    final s = await judged;

    expect(s.turnGuesses.single, (word: first, correct: true));
    expect(s.turnScore, 1);
    expect(s.session.scores['p1'], 1);
    expect(s.currentWord, isNot(first));
  });

  test('a tilt gesture judges like a button press', () async {
    await startTurn();

    final judged = _until(bloc, (s) => s.turnGuesses.length == 1);
    tilt.controller.add(HeadsUpTilt.pass);
    final s = await judged;

    expect(s.turnGuesses.single.correct, isFalse);
    expect(s.session.scores['p1'], 0);
  });

  test('the clock running out ends the turn and passes the phone', () async {
    await startTurn();

    final summary = _until(bloc, (s) => s.phase == HeadsUpPhase.summary);
    ticker.runDown(from: 30);
    final s = await summary;

    expect(s.currentWord, isNull);
    expect(s.session.turnsPlayed, 1);
    expect(s.session.currentPlayer.id, 'p2');

    final ready = _until(bloc, (s) => s.phase == HeadsUpPhase.ready);
    bloc.add(const HeadsUpTurnFinished());
    expect((await ready).turnGuesses, isEmpty);
  });

  test('after the last turn the match is over', () async {
    await startTurn();
    ticker.runDown(from: 30);
    await _until(bloc, (s) => s.phase == HeadsUpPhase.summary);
    bloc.add(const HeadsUpTurnFinished());
    await _until(bloc, (s) => s.phase == HeadsUpPhase.ready);

    await startTurn();
    ticker.runDown(from: 30);
    await _until(bloc, (s) => s.phase == HeadsUpPhase.summary);

    final over = _until(bloc, (s) => s.phase == HeadsUpPhase.over);
    bloc.add(const HeadsUpTurnFinished());
    expect((await over).session.isOver, isTrue);
  });

  test('judging outside a live turn is ignored', () async {
    bloc.add(const HeadsUpWordJudged(correct: true));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.turnGuesses, isEmpty);
    expect(bloc.state.session.scores['p1'], 0);
  });
}
