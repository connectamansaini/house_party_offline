import 'package:equatable/equatable.dart';

import 'role.dart';

/// The dealt state of a single round: who got which role and what the secret
/// word is. Produced by the round engine and consumed by the game FSM.
class RoundAssignment extends Equatable {
  const RoundAssignment({
    required this.rolesByPlayerId,
    required this.secretWord,
    required this.imposterIds,
  });

  final Map<String, Role> rolesByPlayerId;
  final String secretWord;
  final Set<String> imposterIds;

  Role roleOf(String playerId) {
    final role = rolesByPlayerId[playerId];
    if (role == null) {
      throw ArgumentError('No role assigned for player "$playerId"');
    }
    return role;
  }

  bool isImposter(String playerId) => imposterIds.contains(playerId);

  @override
  List<Object?> get props => [rolesByPlayerId, secretWord, imposterIds];
}
