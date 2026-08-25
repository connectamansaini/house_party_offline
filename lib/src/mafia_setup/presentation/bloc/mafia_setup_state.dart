part of 'mafia_setup_bloc.dart';

/// Mutable form state for the Mafia setup flow.
class MafiaSetupState extends Equatable {
  const MafiaSetupState({
    this.players = const [],
    this.config = const MafiaConfig(),
  });

  final List<MafiaPlayer> players;
  final MafiaConfig config;

  int get maxMafia => MafiaConfig.maxMafia(players.length);

  bool get hasEnoughPlayers =>
      players.length >= MafiaConfig.minPlayers &&
      players.length <= MafiaConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart =>
      hasEnoughPlayers &&
      allNamesFilled &&
      config.mafiaCount >= 1 &&
      config.mafiaCount <= maxMafia;

  MafiaSetup buildSetup() => MafiaSetup(players: players, config: config);

  MafiaSetupState copyWith({List<MafiaPlayer>? players, MafiaConfig? config}) {
    return MafiaSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [players, config];
}
