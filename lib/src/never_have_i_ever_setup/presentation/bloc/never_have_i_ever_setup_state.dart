part of 'never_have_i_ever_setup_bloc.dart';

/// Mutable form state for the Never Have I Ever setup flow.
class NeverHaveIEverSetupState extends Equatable {
  const NeverHaveIEverSetupState({
    this.players = const [],
    this.config = const NeverHaveIEverConfig(),
  });

  final List<NeverHaveIEverPlayer> players;
  final NeverHaveIEverConfig config;

  bool get hasEnoughPlayers =>
      players.length >= NeverHaveIEverConfig.minPlayers &&
      players.length <= NeverHaveIEverConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart => hasEnoughPlayers && allNamesFilled;

  NeverHaveIEverSetup buildSetup() =>
      NeverHaveIEverSetup(players: players, config: config);

  NeverHaveIEverSetupState copyWith({
    List<NeverHaveIEverPlayer>? players,
    NeverHaveIEverConfig? config,
  }) {
    return NeverHaveIEverSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [players, config];
}
