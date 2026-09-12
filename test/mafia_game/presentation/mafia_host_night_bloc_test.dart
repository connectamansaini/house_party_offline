import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_night_step.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';

const _engine = MafiaEngine();
const _host = MafiaPlayer(id: 'host', name: 'Host');

MafiaSetup _setup(int players, {int mafia = 1}) => MafiaSetup(
  players: [
    for (var i = 0; i < players; i++) MafiaPlayer(id: 'p$i', name: 'P$i'),
  ],
  config: MafiaConfig(mafiaCount: mafia),
  host: _host,
);

extension on MafiaGameBloc {
  Future<MafiaGameState> get next => stream.first;
}

void main() {
  /// Walks the opening reveal — one card per dealt player, the host holding
  /// the phone — through to the first host-run night.
  Future<MafiaHostNight> toFirstNight(MafiaGameBloc bloc, int players) async {
    for (var i = 0; i < players; i++) {
      bloc.add(const RoleRevealed());
      await bloc.next;
      bloc.add(const RolePassed());
      await bloc.next;
    }
    return bloc.state as MafiaHostNight;
  }

  /// Runs the host's whole script: sleep, then each waking role in turn.
  Future<MafiaNightRecap> playNight(
    MafiaGameBloc bloc, {
    required String mafiaTarget,
    String? doctorTarget,
  }) async {
    while (bloc.state is MafiaHostNight) {
      final h = bloc.state as MafiaHostNight;
      switch (h.step) {
        case MafiaNightStep.sleep:
          bloc.add(const NightActionConfirmed());
          await bloc.next;
        case MafiaNightStep.mafia:
          bloc.add(NightTargetSelected(mafiaTarget));
          await bloc.next;
          bloc.add(const NightActionConfirmed());
          await bloc.next;
        case MafiaNightStep.doctor:
          final t = doctorTarget ?? h.session.livingPlayers.first.id;
          bloc.add(NightTargetSelected(t));
          await bloc.next;
          bloc.add(const NightActionConfirmed());
          await bloc.next;
        case MafiaNightStep.detective:
          final detective = h.session.livingWithRole(MafiaRole.detective).first;
          final other = h.session.livingPlayers.firstWhere(
            (p) => p.id != detective.id,
          );
          bloc.add(NightTargetSelected(other.id));
          await bloc.next;
          bloc.add(const NightActionConfirmed());
          await bloc.next; // result for the host to show the detective
          bloc.add(const NightInvestigationSeen());
          await bloc.next;
      }
    }
    return bloc.state as MafiaNightRecap;
  }

  test('the host is dealt no role and never appears in the roster', () async {
    final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
    final session = bloc.state.session;

    expect(session.isHosted, isTrue);
    expect(session.host, _host);
    expect(session.players.length, 6);
    expect(session.players.any((p) => p.id == _host.id), isFalse);
    expect(session.roles.containsKey(_host.id), isFalse);
    await bloc.close();
  });

  test('the reveal runs once per player, then opens the night', () async {
    final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
    final night = await toFirstNight(bloc, 6);

    expect(night.step, MafiaNightStep.sleep);
    expect(night.steps, [
      MafiaNightStep.sleep,
      MafiaNightStep.mafia,
      MafiaNightStep.doctor,
      MafiaNightStep.detective,
    ]);
    await bloc.close();
  });

  test('the script walks sleep, mafia, doctor, detective in order', () async {
    final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
    final night = await toFirstNight(bloc, 6);
    final victim = night.session.players.firstWhere(
      (p) => !night.session.roleOf(p.id).isMafia,
    );

    bloc.add(const NightActionConfirmed());
    expect((await bloc.next as MafiaHostNight).step, MafiaNightStep.mafia);

    bloc.add(NightTargetSelected(victim.id));
    await bloc.next;
    bloc.add(const NightActionConfirmed());
    final afterMafia = await bloc.next as MafiaHostNight;
    expect(afterMafia.step, MafiaNightStep.doctor);
    expect(afterMafia.mafiaTargetId, victim.id);
    // The pick is cleared so the next step starts blank.
    expect(afterMafia.selectedId, isNull);
    await bloc.close();
  });

  test('a step cannot be confirmed with nobody picked', () async {
    final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
    await toFirstNight(bloc, 6);
    bloc.add(const NightActionConfirmed());
    await bloc.next;

    bloc.add(const NightActionConfirmed());
    await Future<void>.delayed(Duration.zero);
    expect((bloc.state as MafiaHostNight).step, MafiaNightStep.mafia);
    await bloc.close();
  });

  test('the mafia pick kills unless the doctor saved them', () async {
    final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
    final night = await toFirstNight(bloc, 6);
    final victim = night.session.players.firstWhere(
      (p) => !night.session.roleOf(p.id).isMafia,
    );

    final recap = await playNight(
      bloc,
      mafiaTarget: victim.id,
      doctorTarget: 'nobody',
    );
    expect(recap.resolution.killedId, victim.id);
    expect(recap.session.isAlive(victim.id), isFalse);
    await bloc.close();
  });

  test('the doctor saving the target keeps them alive', () async {
    final bloc = MafiaGameBloc(setup: _setup(6), engine: _engine);
    final night = await toFirstNight(bloc, 6);
    final victim = night.session.players.firstWhere(
      (p) => !night.session.roleOf(p.id).isMafia,
    );

    final recap = await playNight(
      bloc,
      mafiaTarget: victim.id,
      doctorTarget: victim.id,
    );
    expect(recap.resolution.killedId, isNull);
    expect(recap.resolution.savedId, victim.id);
    expect(recap.session.isAlive(victim.id), isTrue);
    await bloc.close();
  });

  test('the next night is host-run too, and skips a dead role', () async {
    final bloc = MafiaGameBloc(setup: _setup(7), engine: _engine);
    final night = await toFirstNight(bloc, 7);
    final doctor = night.session.livingWithRole(MafiaRole.doctor).first;

    await playNight(bloc, mafiaTarget: doctor.id, doctorTarget: 'nobody');
    bloc.add(const RecapContinued());
    await bloc.next; // day vote
    bloc.add(const DaySkipped());
    await bloc.next;
    bloc.add(const RecapContinued());

    final second = await bloc.next as MafiaHostNight;
    expect(second.session.nightNumber, 2);
    expect(second.steps, isNot(contains(MafiaNightStep.doctor)));
    expect(second.steps, contains(MafiaNightStep.detective));
    await bloc.close();
  });

  test('without a host the night is still pass-and-play', () async {
    final bloc = MafiaGameBloc(
      setup: MafiaSetup(
        players: [
          for (var i = 0; i < 6; i++) MafiaPlayer(id: 'p$i', name: 'P$i'),
        ],
        config: const MafiaConfig(),
      ),
      engine: _engine,
    );
    for (var i = 0; i < 6; i++) {
      bloc.add(const RoleRevealed());
      await bloc.next;
      bloc.add(const RolePassed());
      await bloc.next;
    }
    expect(bloc.state, isA<MafiaNight>());
    await bloc.close();
  });
}
