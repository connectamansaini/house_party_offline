import 'package:equatable/equatable.dart';

import 'mafia_config.dart';
import 'mafia_player.dart';

/// Validated input to a Mafia match: the roster and the chosen settings.
class MafiaSetup extends Equatable {
  const MafiaSetup({required this.players, required this.config});

  final List<MafiaPlayer> players;
  final MafiaConfig config;

  @override
  List<Object?> get props => [players, config];
}
