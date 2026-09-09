part of 'most_likely_to_setup_bloc.dart';

/// Mutable form state for the Most Likely To setup flow.
class MostLikelyToSetupState extends Equatable {
  const MostLikelyToSetupState({
    this.players = const [],
    this.config = const MostLikelyToConfig(),
    this.customPrompts = const [],
  });

  final List<MostLikelyToPlayer> players;
  final MostLikelyToConfig config;

  /// The host's own prompts on this device, whether or not they're included.
  final List<String> customPrompts;

  int get customPromptCount => customPrompts.length;

  bool get hasEnoughPlayers =>
      players.length >= MostLikelyToConfig.minPlayers &&
      players.length <= MostLikelyToConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart => hasEnoughPlayers && allNamesFilled;

  MostLikelyToSetup buildSetup() => MostLikelyToSetup(
    players: players,
    config: config,
    customPrompts: config.includeCustomPrompts ? customPrompts : const [],
  );

  MostLikelyToSetupState copyWith({
    List<MostLikelyToPlayer>? players,
    MostLikelyToConfig? config,
    List<String>? customPrompts,
  }) {
    return MostLikelyToSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
      customPrompts: customPrompts ?? this.customPrompts,
    );
  }

  @override
  List<Object?> get props => [players, config, customPrompts];
}
