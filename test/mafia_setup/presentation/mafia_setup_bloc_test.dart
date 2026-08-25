import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_setup/presentation/bloc/mafia_setup_bloc.dart';

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
  group('initial state', () {
    test('seeds the minimum default roster', () {
      final bloc = MafiaSetupBloc();
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
      final bloc = MafiaSetupBloc();
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
      final bloc = MafiaSetupBloc();
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
      final bloc = MafiaSetupBloc();
      // 5 default players → max mafia is maxMafia(5).
      final maxMafia = MafiaConfig.maxMafia(bloc.state.players.length);
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
      expect(bloc.state.config.mafiaCount, MafiaConfig.maxMafia(4));

      await bloc.close();
    });

    test('renamePlayer updates only the target', () async {
      final bloc = MafiaSetupBloc();
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
      final bloc = MafiaSetupBloc();
      final maxMafia = MafiaConfig.maxMafia(bloc.state.players.length);

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
      final bloc = MafiaSetupBloc();

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
      final bloc = MafiaSetupBloc();
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
}
