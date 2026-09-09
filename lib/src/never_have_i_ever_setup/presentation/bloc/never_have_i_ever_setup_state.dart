part of 'never_have_i_ever_setup_bloc.dart';

/// Mutable form state for the Never Have I Ever setup flow.
class NeverHaveIEverSetupState extends Equatable {
  const NeverHaveIEverSetupState({
    this.players = const [],
    this.config = const NeverHaveIEverConfig(),
    this.customPrompts = const [],
  });

  final List<NeverHaveIEverPlayer> players;
  final NeverHaveIEverConfig config;

  /// The host's own prompts on this device, whether or not they're included.
  final List<String> customPrompts;

  int get customPromptCount => customPrompts.length;

  bool get hasEnoughPlayers =>
      players.length >= NeverHaveIEverConfig.minPlayers &&
      players.length <= NeverHaveIEverConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart => hasEnoughPlayers && allNamesFilled;

  NeverHaveIEverSetup buildSetup() => NeverHaveIEverSetup(
    players: players,
    config: config,
    customPrompts: config.includeCustomPrompts ? customPrompts : const [],
  );

  NeverHaveIEverSetupState copyWith({
    List<NeverHaveIEverPlayer>? players,
    NeverHaveIEverConfig? config,
    List<String>? customPrompts,
  }) {
    return NeverHaveIEverSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
      customPrompts: customPrompts ?? this.customPrompts,
    );
  }

  @override
  List<Object?> get props => [players, config, customPrompts];
}
