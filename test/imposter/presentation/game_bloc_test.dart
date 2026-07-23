import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/domain/engine/round_engine.dart';
import 'package:house_party_offline/src/imposter/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter/domain/entities/game_setup.dart';
import 'package:house_party_offline/src/imposter/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter/domain/entities/round_result.dart';
import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';
import 'package:house_party_offline/src/imposter/presentation/game/game_bloc.dart';
import 'package:house_party_offline/src/imposter/presentation/game/game_event.dart';
import 'package:house_party_offline/src/imposter/presentation/game/game_state.dart';

const _engine = RoundEngine();

// Single-word pack → the secret word is always "Word", making guesses testable.
GameSetup _setup({int players = 4, int imposters = 1, bool secret = false}) {
  return GameSetup(
    players: [for (var i = 0; i < players; i++) Player(id: 'p$i', name: 'P$i')],
    config: GameConfig(
      packs: const [
        WordPack(
          id: 'x',
          name: 'X',
          category: 'Cat',
          words: ['Word'],
        ),
      ],
      imposterCount: imposters,
      secretVoting: secret,
    ),
  );
}

void main() {
  Future<GameState> next(GameBloc bloc) => bloc.stream.first;

  Future<Discussion> driveToDiscussion(GameBloc bloc, int n) async {
    late Discussion disc;
    for (var i = 0; i < n; i++) {
      bloc.add(const RoleRevealed());
      await next(bloc);
      bloc.add(const RolePassed());
      final s = await next(bloc);
      if (s is Discussion) disc = s;
    }
    return disc;
  }

  Future<Voting> driveToVoting(GameBloc bloc, int n) async {
    await driveToDiscussion(bloc, n);
    bloc.add(const DiscussionSkipped());
    return await next(bloc) as Voting;
  }

  test('initial state reveals the first player of round 1', () {
    final bloc = GameBloc(setup: _setup(), engine: _engine);
    expect(bloc.state, isA<RoleReveal>());
    final r = bloc.state as RoleReveal;
    expect(r.currentIndex, 0);
    expect(r.isRevealed, isFalse);
    expect(r.session.roundNumber, 1);
    expect(r.assignment.imposterIds.length, 1);
    bloc.close();
  });

  test('reveal → pass through all players → discussion', () async {
    final bloc = GameBloc(setup: _setup(players: 3), engine: _engine);
    final disc = await driveToDiscussion(bloc, 3);
    expect(disc.remaining, bloc.state.session.config.discussionTime);
    await bloc.close();
  });

  test('a discussion tick decrements the remaining time', () async {
    final bloc = GameBloc(setup: _setup(players: 3), engine: _engine);
    final disc = await driveToDiscussion(bloc, 3);
    bloc.add(const DiscussionTicked());
    final ticked = await next(bloc) as Discussion;
    expect(ticked.remaining, lessThan(disc.remaining));
    await bloc.close();
  });

  test('voting out an imposter moves to the guess step', () async {
    final bloc = GameBloc(setup: _setup(), engine: _engine);
    final voting = await driveToVoting(bloc, 4);
    final imposterId = voting.assignment.imposterIds.first;

    bloc.add(VoteSelected(imposterId));
    await next(bloc);
    bloc.add(const VoteConfirmed());
    final s = await next(bloc);
    expect(s, isA<ImposterGuessing>());
    expect((s as ImposterGuessing).votedOutId, imposterId);
    await bloc.close();
  });

  test('caught imposter with a correct guess steals the win', () async {
    final bloc = GameBloc(setup: _setup(), engine: _engine);
    final voting = await driveToVoting(bloc, 4);
    final imposterId = voting.assignment.imposterIds.first;

    bloc.add(VoteSelected(imposterId));
    await next(bloc);
    bloc.add(const VoteConfirmed());
    await next(bloc);
    bloc.add(const ImposterGuessSubmitted('word')); // normalized match
    final result = await next(bloc) as RoundResultState;

    expect(result.result.winningSide, WinningSide.imposter);
    expect(result.result.imposterGuessedRight, isTrue);
    expect(
      result.session.players.firstWhere((p) => p.id == imposterId).cumulativeScore,
      greaterThan(0),
    );
    await bloc.close();
  });

  test('caught imposter with a wrong guess gives the civilian the win', () async {
    final bloc = GameBloc(setup: _setup(), engine: _engine);
    final voting = await driveToVoting(bloc, 4);
    final imposterId = voting.assignment.imposterIds.first;

    bloc.add(VoteSelected(imposterId));
    await next(bloc);
    bloc.add(const VoteConfirmed());
    await next(bloc);
    bloc.add(const ImposterGuessSubmitted('wrong'));
    final result = await next(bloc) as RoundResultState;

    expect(result.result.winningSide, WinningSide.civilian);
    expect(result.result.imposterGuessedRight, isFalse);
    await bloc.close();
  });

  test('voting out a civilian member wins the round for the imposter', () async {
    final bloc = GameBloc(setup: _setup(), engine: _engine);
    final voting = await driveToVoting(bloc, 4);
    final civilianId = voting.session.players
        .firstWhere((p) => !voting.assignment.imposterIds.contains(p.id))
        .id;

    bloc.add(VoteSelected(civilianId));
    await next(bloc);
    bloc.add(const VoteConfirmed());
    final result = await next(bloc) as RoundResultState;

    expect(result.result.winningSide, WinningSide.imposter);
    expect(result.result.imposterGuessedRight, isFalse);
    await bloc.close();
  });

  test('secret voting collects ballots and tallies to catch the imposter',
      () async {
    final bloc = GameBloc(setup: _setup(secret: true), engine: _engine);
    await driveToDiscussion(bloc, 4);
    bloc.add(const DiscussionSkipped());
    var sv = await next(bloc) as SecretVoting;
    final imposterId = sv.assignment.imposterIds.first;

    // Every civilian votes the imposter; the imposter votes someone else.
    for (var i = 0; i < 4; i++) {
      bloc.add(const BallotOpened());
      await next(bloc);
      final voter = sv.currentVoter;
      final target =
          voter.id == imposterId ? sv.candidates.first.id : imposterId;
      bloc.add(BallotSelected(target));
      await next(bloc);
      bloc.add(const BallotCast());
      final s = await next(bloc);
      if (s is SecretVoting) sv = s;
    }

    // 3 votes for the imposter vs 1 → imposter caught → guess step.
    expect(bloc.state, isA<ImposterGuessing>());
    expect((bloc.state as ImposterGuessing).votedOutId, imposterId);
    await bloc.close();
  });

  test('next round deals a fresh reveal and increments the round', () async {
    final bloc = GameBloc(setup: _setup(), engine: _engine);
    final voting = await driveToVoting(bloc, 4);
    final civilianId = voting.session.players
        .firstWhere((p) => !voting.assignment.imposterIds.contains(p.id))
        .id;
    bloc.add(VoteSelected(civilianId));
    await next(bloc);
    bloc.add(const VoteConfirmed());
    await next(bloc);

    bloc.add(const NextRoundRequested());
    final s = await next(bloc) as RoleReveal;
    expect(s.session.roundNumber, 2);
    expect(s.currentIndex, 0);
    expect(s.isRevealed, isFalse);
    await bloc.close();
  });

  test('ending the game shows the final standings', () async {
    final bloc = GameBloc(setup: _setup(), engine: _engine);
    final voting = await driveToVoting(bloc, 4);
    final civilianId = voting.session.players
        .firstWhere((p) => !voting.assignment.imposterIds.contains(p.id))
        .id;
    bloc.add(VoteSelected(civilianId));
    await next(bloc);
    bloc.add(const VoteConfirmed());
    await next(bloc);

    bloc.add(const GameEnded());
    final s = await next(bloc);
    expect(s, isA<GameOver>());
    await bloc.close();
  });
}
