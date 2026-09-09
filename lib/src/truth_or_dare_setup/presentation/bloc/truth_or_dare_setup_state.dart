part of 'truth_or_dare_setup_bloc.dart';

/// Mutable form state for the Truth or Dare setup flow.
class TruthOrDareSetupState extends Equatable {
  const TruthOrDareSetupState({
    this.players = const [],
    this.config = const TruthOrDareConfig(),
    this.customTruths = const [],
    this.customDares = const [],
  });

  final List<TruthOrDarePlayer> players;
  final TruthOrDareConfig config;

  /// The host's own prompts on this device, whether or not they're included.
  final List<String> customTruths;
  final List<String> customDares;

  int get customPromptCount => customTruths.length + customDares.length;

  bool get hasEnoughPlayers =>
      players.length >= TruthOrDareConfig.minPlayers &&
      players.length <= TruthOrDareConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart => hasEnoughPlayers && allNamesFilled;

  TruthOrDareSetup buildSetup() => TruthOrDareSetup(
    players: players,
    config: config,
    customTruths: config.includeCustomPrompts ? customTruths : const [],
    customDares: config.includeCustomPrompts ? customDares : const [],
  );

  TruthOrDareSetupState copyWith({
    List<TruthOrDarePlayer>? players,
    TruthOrDareConfig? config,
    List<String>? customTruths,
    List<String>? customDares,
  }) {
    return TruthOrDareSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
      customTruths: customTruths ?? this.customTruths,
      customDares: customDares ?? this.customDares,
    );
  }

  @override
  List<Object?> get props => [players, config, customTruths, customDares];
}
