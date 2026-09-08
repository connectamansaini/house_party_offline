part of 'most_likely_to_setup_bloc.dart';

/// Mutable form state for the Most Likely To setup flow.
class MostLikelyToSetupState extends Equatable {
  const MostLikelyToSetupState({
    this.players = const [],
    this.config = const MostLikelyToConfig(),
  });

  final List<MostLikelyToPlayer> players;
  final MostLikelyToConfig config;

  bool get hasEnoughPlayers =>
      players.length >= MostLikelyToConfig.minPlayers &&
      players.length <= MostLikelyToConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart => hasEnoughPlayers && allNamesFilled;

  MostLikelyToSetup buildSetup() =>
      MostLikelyToSetup(players: players, config: config);

  MostLikelyToSetupState copyWith({
    List<MostLikelyToPlayer>? players,
    MostLikelyToConfig? config,
  }) {
    return MostLikelyToSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [players, config];
}
