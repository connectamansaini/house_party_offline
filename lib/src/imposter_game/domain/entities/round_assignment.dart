import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/role.dart';

part 'round_assignment.freezed.dart';

/// The dealt state of a single round: who got which role and what the secret
/// word is. Produced by the round engine and consumed by the game FSM.
@freezed
abstract class RoundAssignment with _$RoundAssignment {
  const factory RoundAssignment({
    required Map<String, Role> rolesByPlayerId,
    required String secretWord,
    required Set<String> imposterIds,
  }) = _RoundAssignment;

  const RoundAssignment._();

  Role roleOf(String playerId) {
    final role = rolesByPlayerId[playerId];
    if (role == null) {
      throw ArgumentError('No role assigned for player "$playerId"');
    }
    return role;
  }

  bool isImposter(String playerId) => imposterIds.contains(playerId);
}
