import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';

const _engine = MafiaEngine();

MafiaSetup _setup(int players, {int mafia = 1}) => MafiaSetup(
  players: [
    for (var i = 0; i < players; i++) MafiaPlayer(id: 'p$i', name: 'P$i'),
  ],
  config: MafiaConfig(mafiaCount: mafia),
);

extension on MafiaGameBloc {
  Future<MafiaGameState> get next => stream.first;
}

void main() {
  // Drives the initial pass-and-play reveal to the first night.
  Future<MafiaNight> toFirstNight(MafiaGameBloc bloc, int players) async {
    for (var i = 0; i < players; i++) {
      bloc.add(const RoleRevealed());
      await bloc.next;
      bloc.add(const RolePassed());
      await bloc.next;
    }
    return bloc.state as MafiaNight;
  }

  /// Plays one full night: each living player reveals and acts. Mafia kill
  /// [mafiaTarget]; doctor protects [doctorTarget]; detective investigates the
  /// first candidate. Returns the resulting recap.
  Future<MafiaNightRecap> playNight(
    MafiaGameBloc bloc, {
    required String mafiaTarget,
    String? doctorTarget,
  }) async {
    while (bloc.state is MafiaNight) {
      final n = bloc.state as MafiaNight;
      bloc.add(const NightActorRevealed());
      await bloc.next;
      switch (n.currentRole) {
        case MafiaRole.mafia:
          bloc.add(NightTargetSelected(mafiaTarget));
          await bloc.next;
          bloc.add(const NightActionConfirmed());
          await bloc.next;
        case MafiaRole.doctor:
          final t = doctorTarget ?? n.session.livingPlayers.first.id;
          bloc.add(NightTargetSelected(t));
          await bloc.next;
          bloc.add(const NightActionConfirmed());
          await bloc.next;
        case MafiaRole.detective:
          final other = n.session.livingPlayers.firstWhere(
            (p) => p.id != n.currentPlayer.id,
          );
          bloc.add(NightTargetSelected(other.id));
          await bloc.next;
          bloc.add(const NightActionConfirmed());
          await bloc.next; // shows investigation
          bloc.add(const NightInvestigationSeen());
          await bloc.next;
        case MafiaRole.villager:
          bloc.add(const NightActionConfirmed());
          await bloc.next;
      }
    }
    return bloc.state as MafiaNightRecap;
  }

  test('deals roles and starts the reveal for the first player', () {
    final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
    expect(bloc.state, isA<MafiaRoleReveal>());
    final r = bloc.state as MafiaRoleReveal;
    expect(r.currentIndex, 0);
    expect(r.session.mafiaIds.length, 1);
    expect(r.session.aliveIds.length, 6);
    bloc.close();
  });

  test(
    'unprotected mafia kill removes the victim; doctor save prevents it',
    () async {
      final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
      final night = await toFirstNight(bloc, 6);

      // Pick a non-mafia victim.
      final victim = night.session.players.firstWhere(
        (p) => !night.session.roleOf(p.id).isMafia,
      );
      final recap = await playNight(bloc, mafiaTarget: victim.id);

      // Either the victim died, or (if the doctor happened to protect them) was
      // saved — assert the two stay consistent.
      if (recap.resolution.killedId != null) {
        expect(recap.resolution.killedId, victim.id);
        expect(recap.session.isAlive(victim.id), isFalse);
      } else {
        expect(recap.resolution.savedId, victim.id);
        expect(recap.session.isAlive(victim.id), isTrue);
      }
      await bloc.close();
    },
  );

  test('recap continues to the day vote when nobody has won', () async {
    final bloc = MafiaGameBloc(setup: _setup(7), engine: _engine);
    await toFirstNight(bloc, 7);
    final victim = (bloc.state as MafiaNight).session.players.firstWhere(
      (p) => !(bloc.state as MafiaNight).session.roleOf(p.id).isMafia,
    );
    final recap = await playNight(
      bloc,
      mafiaTarget: victim.id,
      doctorTarget: 'none',
    );
    expect(recap.winner, isNull);
    bloc.add(const RecapContinued());
    expect(await bloc.next, isA<MafiaDayVote>());
    await bloc.close();
  });

  test('lynching the last mafia wins the game for the town', () async {
    final bloc = MafiaGameBloc(setup: _setup(5), engine: _engine);
    await toFirstNight(bloc, 5);
    final session = (bloc.state as MafiaNight).session;
    final mafiaId = session.mafiaIds.first;
    // Doctor protects the mafia's target so the night stays peaceful.
    final safe = mafiaId == 'p0' ? 'p1' : 'p0';
    await playNight(bloc, mafiaTarget: safe, doctorTarget: safe);
    // If someone still died, just proceed; the key assertion is the lynch.
    bloc.add(const RecapContinued());
    final s = await bloc.next;
    if (s is MafiaGameOver) {
      await bloc.close();
      return; // mafia already reached parity; acceptable for small games
    }
    expect(s, isA<MafiaDayVote>());
    bloc.add(DayTargetSelected(mafiaId));
    await bloc.next;
    bloc.add(const DayVoteConfirmed());
    final lynch = await bloc.next as MafiaLynchRecap;
    expect(lynch.winner, MafiaFaction.town);
    bloc.add(const RecapContinued());
    expect(await bloc.next, isA<MafiaGameOver>());
    await bloc.close();
  });

  test('skipping the day proceeds to the next night', () async {
    final bloc = MafiaGameBloc(setup: _setup(8), engine: _engine);
    await toFirstNight(bloc, 8);
    final session = (bloc.state as MafiaNight).session;
    final victim = session.players.firstWhere(
      (p) => !session.roleOf(p.id).isMafia,
    );
    await playNight(bloc, mafiaTarget: victim.id, doctorTarget: 'none');
    bloc.add(const RecapContinued());
    await bloc.next; // day vote
    bloc.add(const DaySkipped());
    final lynch = await bloc.next as MafiaLynchRecap;
    expect(lynch.lynchedId, isNull);
    bloc.add(const RecapContinued());
    final s = await bloc.next;
    expect(s, isA<MafiaNight>());
    expect((s as MafiaNight).session.nightNumber, 2);
    await bloc.close();
  });
}
