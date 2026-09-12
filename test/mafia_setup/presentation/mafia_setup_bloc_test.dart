import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_setup/domain/entities/mafia_host_preferences.dart';
import 'package:house_party_offline/src/mafia_setup/presentation/bloc/mafia_setup_bloc.dart';
import '../../helpers/fake_mafia_host_preferences_repository.dart';
import '../../helpers/fake_roster_repository.dart';

/// Subscribes for the next state matching [predicate] *before* adding
/// [event], then adds it — avoiding the race of adding first and hoping the
/// listener attaches in time.
Future<MafiaSetupState> _emitUntil(
  MafiaSetupBloc bloc,
  MafiaSetupEvent event,
  bool Function(MafiaSetupState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  group('roster', () {
    test('Started seeds the saved roster, padded to the minimum', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(['Ann', 'Bo']),
        FakeMafiaHostPreferencesRepository(),
      );

      final s = await _emitUntil(
        bloc,
        const MafiaSetupStarted(),
        (s) => s.players.first.name == 'Ann',
      );

      expect(s.players.map((p) => p.name), [
        'Ann',
        'Bo',
        'Player 3',
        'Player 4',
        'Player 5',
      ]);
      await bloc.close();
    });

    test('RosterSaved writes the current names', () async {
      final roster = FakeRosterRepository();
      final bloc = MafiaSetupBloc(roster, FakeMafiaHostPreferencesRepository())
        ..add(const MafiaSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);

      expect(roster.stored.length, MafiaConfig.minPlayers);
      expect(roster.stored.first, 'Player 1');
      await bloc.close();
    });
  });

  group('initial state', () {
    test('seeds the minimum default roster', () {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      expect(bloc.state.players.length, MafiaConfig.minPlayers);
      expect(
        bloc.state.players.map((p) => p.name),
        List.generate(MafiaConfig.minPlayers, (i) => 'Player ${i + 1}'),
      );
      bloc.close();
    });
  });

  group('players', () {
    test('addPlayer appends up to the max', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      final before = bloc.state.players.length;

      final s = await _emitUntil(
        bloc,
        const MafiaSetupPlayerAdded(),
        (s) => s.players.length == before + 1,
      );
      expect(s.players.length, before + 1);

      await bloc.close();
    });

    test('addPlayer is capped at maxPlayers', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      for (var i = 0; i < 20; i++) {
        bloc.add(const MafiaSetupPlayerAdded());
      }
      await bloc.stream.firstWhere(
        (s) => s.players.length == MafiaConfig.maxPlayers,
      );
      expect(bloc.state.players.length, MafiaConfig.maxPlayers);

      await bloc.close();
    });

    test('removePlayer clamps the mafia count', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      // 5 default players → max mafia is maxMafia(5).
      final maxMafia = const MafiaConfig().maxMafiaFor(
        bloc.state.players.length,
      );
      await _emitUntil(
        bloc,
        MafiaSetupMafiaCountChanged(maxMafia),
        (s) => s.config.mafiaCount == maxMafia,
      );

      final firstId = bloc.state.players.first.id;
      await _emitUntil(
        bloc,
        MafiaSetupPlayerRemoved(firstId),
        (s) => s.players.length == 4,
      );

      expect(bloc.state.players.length, 4);
      expect(bloc.state.config.mafiaCount, const MafiaConfig().maxMafiaFor(4));

      await bloc.close();
    });

    test('renamePlayer updates only the target', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      final id = bloc.state.players[1].id;

      final s = await _emitUntil(
        bloc,
        MafiaSetupPlayerRenamed(id: id, name: 'Alice'),
        (s) => s.players[1].name == 'Alice',
      );

      expect(s.players[1].name, 'Alice');
      expect(s.players[0].name, 'Player 1');

      await bloc.close();
    });
  });

  group('config', () {
    test('setMafiaCount clamps within maxMafia', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      final maxMafia = const MafiaConfig().maxMafiaFor(
        bloc.state.players.length,
      );

      final capped = await _emitUntil(
        bloc,
        const MafiaSetupMafiaCountChanged(99),
        (s) => s.config.mafiaCount == maxMafia,
      );
      expect(capped.config.mafiaCount, maxMafia);

      final floored = await _emitUntil(
        bloc,
        const MafiaSetupMafiaCountChanged(0),
        (s) => s.config.mafiaCount == 1,
      );
      expect(floored.config.mafiaCount, 1);

      await bloc.close();
    });

    test('option switches flip independently', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );

      var s = await _emitUntil(
        bloc,
        const MafiaSetupRevealRolesOnDeathChanged(enabled: false),
        (s) => !s.config.revealRolesOnDeath,
      );
      expect(s.config.revealRolesOnDeath, isFalse);

      s = await _emitUntil(
        bloc,
        const MafiaSetupFirstNightKillChanged(enabled: false),
        (s) => !s.config.firstNightKill,
      );
      expect(s.config.firstNightKill, isFalse);
      expect(s.config.revealRolesOnDeath, isFalse); // untouched

      s = await _emitUntil(
        bloc,
        const MafiaSetupDoctorSelfSaveChanged(enabled: false),
        (s) => !s.config.doctorSelfSave,
      );
      expect(s.config.doctorSelfSave, isFalse);

      s = await _emitUntil(
        bloc,
        const MafiaSetupDetectiveExactRoleChanged(enabled: false),
        (s) => !s.config.detectiveExactRole,
      );
      expect(s.config.detectiveExactRole, isFalse);

      await bloc.close();
    });

    test('buildSetup produces a matching MafiaSetup', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      await _emitUntil(
        bloc,
        const MafiaSetupMafiaCountChanged(2),
        (s) => s.config.mafiaCount == 2,
      );

      expect(bloc.state.canStart, isTrue);
      final setup = bloc.state.buildSetup();
      expect(setup.players.length, MafiaConfig.minPlayers);
      expect(setup.config.mafiaCount, 2);

      await bloc.close();
    });
  });

  group('special roles', () {
    test('both are dealt by default', () {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      expect(bloc.state.config.includeDoctor, isTrue);
      expect(bloc.state.config.includeDetective, isTrue);
      expect(bloc.state.config.specialCount, 2);
      bloc.close();
    });

    test('dropping them frees seats for more mafia', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      // 5 players with both specials: 2 mafia would leave no villagers.
      expect(bloc.state.maxMafia, 2);

      final s = await _emitUntil(
        bloc,
        const MafiaSetupIncludeDoctorChanged(enabled: false),
        (s) => !s.config.includeDoctor,
      );

      expect(s.config.specialCount, 1);
      expect(s.maxMafia, 2);
      expect(s.canStart, isTrue);
      await bloc.close();
    });

    test('bringing a role back re-clamps an over-large mafia count', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      await _emitUntil(
        bloc,
        const MafiaSetupIncludeDoctorChanged(enabled: false),
        (s) => !s.config.includeDoctor,
      );
      await _emitUntil(
        bloc,
        const MafiaSetupIncludeDetectiveChanged(enabled: false),
        (s) => !s.config.includeDetective,
      );
      final wide = await _emitUntil(
        bloc,
        const MafiaSetupMafiaCountChanged(4),
        (s) => s.config.mafiaCount == 2,
      );
      // Balance still caps 5 players at 2 mafia.
      expect(wide.config.mafiaCount, 2);

      final narrowed = await _emitUntil(
        bloc,
        const MafiaSetupIncludeDoctorChanged(enabled: true),
        (s) => s.config.includeDoctor,
      );
      expect(narrowed.config.mafiaCount, lessThanOrEqualTo(narrowed.maxMafia));
      await bloc.close();
    });

    test('the choice reaches the setup that starts the game', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      final s = await _emitUntil(
        bloc,
        const MafiaSetupIncludeDetectiveChanged(enabled: false),
        (s) => !s.config.includeDetective,
      );

      expect(s.buildSetup().config.includeDetective, isFalse);
      expect(s.buildSetup().config.includeDoctor, isTrue);
      await bloc.close();
    });
  });

  group('host rotation', () {
    test('Started reopens on the remembered narrator', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(['Ann', 'Bo', 'Cy', 'Di', 'Ed', 'Fi']),
        FakeMafiaHostPreferencesRepository(
          const MafiaHostPreferences(enabled: true, lastHostName: 'Cy'),
        ),
      );

      final s = await _emitUntil(
        bloc,
        const MafiaSetupStarted(),
        (s) => s.isHosted,
      );

      expect(s.host?.name, 'Cy');
      expect(s.rotateHost, isFalse);
      expect(s.canStart, isTrue);
      await bloc.close();
    });

    test('Started hands the job on when the host rotates', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(['Ann', 'Bo', 'Cy', 'Di', 'Ed', 'Fi']),
        FakeMafiaHostPreferencesRepository(
          const MafiaHostPreferences(
            enabled: true,
            rotate: true,
            lastHostName: 'Cy',
          ),
        ),
      );

      final s = await _emitUntil(
        bloc,
        const MafiaSetupStarted(),
        (s) => s.isHosted,
      );

      expect(s.host?.name, 'Di');
      expect(s.rotateHost, isTrue);
      await bloc.close();
    });

    test('Started pads the roster for the narrator it remembers', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(['Ann', 'Bo']),
        FakeMafiaHostPreferencesRepository(
          const MafiaHostPreferences(enabled: true),
        ),
      );

      final s = await _emitUntil(
        bloc,
        const MafiaSetupStarted(),
        (s) => s.isHosted,
      );

      // Five players plus the narrator.
      expect(s.players.length, MafiaConfig.minPlayers + 1);
      expect(s.playerCount, MafiaConfig.minPlayers);
      expect(s.canStart, isTrue);
      await bloc.close();
    });

    test('starting a game records who narrated it', () async {
      final prefs = FakeMafiaHostPreferencesRepository();
      final bloc = MafiaSetupBloc(FakeRosterRepository(), prefs);
      await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );
      await _emitUntil(
        bloc,
        const MafiaSetupRotateHostChanged(enabled: true),
        (s) => s.rotateHost,
      );
      final hostName = bloc.state.host!.name;

      bloc.add(const MafiaSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);

      expect(prefs.stored.enabled, isTrue);
      expect(prefs.stored.rotate, isTrue);
      expect(prefs.stored.lastHostName, hostName);
      await bloc.close();
    });

    test('a pass-and-play game clears the remembered narrator', () async {
      final prefs = FakeMafiaHostPreferencesRepository(
        const MafiaHostPreferences(
          enabled: true,
          rotate: true,
          lastHostName: 'Ann',
        ),
      );
      final bloc = MafiaSetupBloc(FakeRosterRepository(), prefs)
        ..add(const MafiaSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);

      expect(prefs.stored.enabled, isFalse);
      expect(prefs.stored.lastHostName, isNull);
      await bloc.close();
    });

    test('two games in a row move the job two seats', () async {
      final roster = FakeRosterRepository([
        'Ann',
        'Bo',
        'Cy',
        'Di',
        'Ed',
        'Fi',
      ]);
      final prefs = FakeMafiaHostPreferencesRepository(
        const MafiaHostPreferences(enabled: true, rotate: true),
      );

      final first = MafiaSetupBloc(roster, prefs);
      await _emitUntil(first, const MafiaSetupStarted(), (s) => s.isHosted);
      expect(first.state.host?.name, 'Ann');
      first.add(const MafiaSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);
      await first.close();

      final second = MafiaSetupBloc(roster, prefs);
      await _emitUntil(second, const MafiaSetupStarted(), (s) => s.isHosted);
      expect(second.state.host?.name, 'Bo');
      second.add(const MafiaSetupRosterSaved());
      await Future<void>.delayed(Duration.zero);
      await second.close();

      final third = MafiaSetupBloc(roster, prefs);
      await _emitUntil(third, const MafiaSetupStarted(), (s) => s.isHosted);
      expect(third.state.host?.name, 'Cy');
      await third.close();
    });
  });

  group('host', () {
    test('is off by default and leaves the whole roster playing', () {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      expect(bloc.state.isHosted, isFalse);
      expect(bloc.state.playerCount, MafiaConfig.minPlayers);
      expect(bloc.state.buildSetup().host, isNull);
      bloc.close();
    });

    test('turning it on takes the first player out of the game', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      final first = bloc.state.players.first;

      final s = await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );

      expect(s.host, first);
      expect(s.playerCount, MafiaConfig.minPlayers - 1);
      expect(s.dealtPlayers, isNot(contains(first)));
      // One short of a game until another name is added.
      expect(s.canStart, isFalse);
      await bloc.close();
    });

    test('the roster limits shift by one to make room', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      expect(bloc.state.rosterMinimum, MafiaConfig.minPlayers);
      expect(bloc.state.rosterCapacity, MafiaConfig.maxPlayers);

      final s = await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );

      expect(s.rosterMinimum, MafiaConfig.minPlayers + 1);
      expect(s.rosterCapacity, MafiaConfig.maxPlayers + 1);
      await bloc.close();
    });

    test('buildSetup hands the host over and deals to the rest', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );
      final added = await _emitUntil(
        bloc,
        const MafiaSetupPlayerAdded(),
        (s) => s.playerCount == MafiaConfig.minPlayers,
      );

      expect(added.canStart, isTrue);
      final setup = added.buildSetup();
      expect(setup.host, added.players.first);
      expect(setup.players.length, MafiaConfig.minPlayers);
      expect(setup.players.any((p) => p.id == setup.host!.id), isFalse);
      await bloc.close();
    });

    test('picking a different host swaps who sits out', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );
      final third = bloc.state.players[2];

      final s = await _emitUntil(
        bloc,
        MafiaSetupHostChanged(third.id),
        (s) => s.hostId == third.id,
      );

      expect(s.host, third);
      expect(s.dealtPlayers, contains(bloc.state.players.first));
      await bloc.close();
    });

    test('removing the host hands the job to the first player left', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );
      final host = bloc.state.players.first;
      final next = bloc.state.players[1];

      final s = await _emitUntil(
        bloc,
        MafiaSetupPlayerRemoved(host.id),
        (s) => s.hostId != host.id,
      );

      expect(s.host, next);
      expect(s.isHosted, isTrue);
      await bloc.close();
    });

    test('turning it off puts the host back in the game', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );

      final s = await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: false),
        (s) => !s.isHosted,
      );

      expect(s.host, isNull);
      expect(s.playerCount, MafiaConfig.minPlayers);
      expect(s.canStart, isTrue);
      await bloc.close();
    });

    test('the mafia count re-clamps to the smaller player count', () async {
      final bloc = MafiaSetupBloc(
        FakeRosterRepository(),
        FakeMafiaHostPreferencesRepository(),
      );
      await _emitUntil(
        bloc,
        const MafiaSetupMafiaCountChanged(2),
        (s) => s.config.mafiaCount == 2,
      );

      // 5 players allow 2 mafia; taking one out for the host leaves room
      // for only 1.
      final s = await _emitUntil(
        bloc,
        const MafiaSetupHostModeChanged(enabled: true),
        (s) => s.isHosted,
      );

      expect(s.maxMafia, 1);
      expect(s.config.mafiaCount, 1);
      await bloc.close();
    });
  });
}
