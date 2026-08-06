import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/mafia/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_role.dart';

void main() {
  const engine = MafiaEngine();

  List<MafiaPlayer> players(int n) => [
    for (var i = 0; i < n; i++) MafiaPlayer(id: 'p$i', name: 'P$i'),
  ];

  group('assignRoles', () {
    test('deals the requested mafia plus one doctor and one detective', () {
      final roles = engine.assignRoles(
        players(7),
        const MafiaConfig(mafiaCount: 2),
        rng: Random(1),
      );
      final counts = <MafiaRole, int>{};
      for (final r in roles.values) {
        counts[r] = (counts[r] ?? 0) + 1;
      }
      expect(counts[MafiaRole.mafia], 2);
      expect(counts[MafiaRole.doctor], 1);
      expect(counts[MafiaRole.detective], 1);
      expect(counts[MafiaRole.villager], 3);
      expect(roles.length, 7);
    });

    test('is deterministic for a fixed seed', () {
      final a = engine.assignRoles(players(6), const MafiaConfig(), rng: Random(9));
      final b = engine.assignRoles(players(6), const MafiaConfig(), rng: Random(9));
      expect(a, equals(b));
    });

    test('rejects a mafia count with no room for the two specials', () {
      expect(
        () => engine.assignRoles(players(4), const MafiaConfig(mafiaCount: 3)),
        throwsArgumentError,
      );
    });

    test('rejects duplicate ids and too-few players', () {
      expect(
        () => engine.assignRoles(
          const [MafiaPlayer(id: 'x', name: 'A'), MafiaPlayer(id: 'x', name: 'B')],
          const MafiaConfig(),
        ),
        throwsArgumentError,
      );
    });
  });

  group('resolveMafiaKill', () {
    test('picks the majority target', () {
      final t = engine.resolveMafiaKill({'m1': 'a', 'm2': 'a', 'm3': 'b'});
      expect(t, 'a');
    });

    test('breaks ties with the rng', () {
      final t = engine.resolveMafiaKill({'m1': 'a', 'm2': 'b'}, rng: Random(0));
      expect(['a', 'b'], contains(t));
    });

    test('returns null when there are no picks', () {
      expect(engine.resolveMafiaKill(const {}), isNull);
    });
  });

  group('resolveNight', () {
    const config = MafiaConfig();

    test('kills an unprotected target', () {
      final r = engine.resolveNight(
        killTarget: 'v',
        doctorProtect: 'x',
        isFirstNight: false,
        config: config,
      );
      expect(r.killedId, 'v');
      expect(r.someoneSaved, isFalse);
    });

    test('doctor protection saves the target', () {
      final r = engine.resolveNight(
        killTarget: 'v',
        doctorProtect: 'v',
        isFirstNight: false,
        config: config,
      );
      expect(r.killedId, isNull);
      expect(r.savedId, 'v');
    });

    test('no kill target means a peaceful night', () {
      final r = engine.resolveNight(
        killTarget: null,
        doctorProtect: 'v',
        isFirstNight: false,
        config: config,
      );
      expect(r.someoneDied, isFalse);
      expect(r.someoneSaved, isFalse);
    });

    test('first night is peaceful when firstNightKill is off', () {
      final r = engine.resolveNight(
        killTarget: 'v',
        doctorProtect: null,
        isFirstNight: true,
        config: const MafiaConfig(firstNightKill: false),
      );
      expect(r.someoneDied, isFalse);
    });

    test('first night still kills when firstNightKill is on', () {
      final r = engine.resolveNight(
        killTarget: 'v',
        doctorProtect: null,
        isFirstNight: true,
        config: const MafiaConfig(firstNightKill: true),
      );
      expect(r.killedId, 'v');
    });
  });

  group('investigationResult', () {
    test('exact role when configured', () {
      expect(
        engine.investigationResult(MafiaRole.doctor, const MafiaConfig()),
        'Doctor',
      );
    });

    test('only alignment when exact role is off', () {
      const cfg = MafiaConfig(detectiveExactRole: false);
      expect(engine.investigationResult(MafiaRole.mafia, cfg), 'Mafia');
      expect(engine.investigationResult(MafiaRole.doctor, cfg), 'Not Mafia');
    });
  });

  group('winner', () {
    final roles = {
      'm1': MafiaRole.mafia,
      'd': MafiaRole.doctor,
      'det': MafiaRole.detective,
      'v1': MafiaRole.villager,
      'v2': MafiaRole.villager,
    };

    test('town wins when no mafia remain', () {
      expect(
        engine.winner(roles, {'d', 'det', 'v1', 'v2'}),
        MafiaFaction.town,
      );
    });

    test('mafia win at parity', () {
      // 1 mafia vs 1 town alive → mafia parity.
      expect(engine.winner(roles, {'m1', 'v1'}), MafiaFaction.mafia);
    });

    test('game continues while town outnumbers mafia', () {
      expect(engine.winner(roles, {'m1', 'v1', 'v2'}), isNull);
    });
  });
}
