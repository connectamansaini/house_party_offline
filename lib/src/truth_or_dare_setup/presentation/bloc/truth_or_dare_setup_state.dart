part of 'truth_or_dare_setup_bloc.dart';

/// Mutable form state for the Truth or Dare setup flow.
class TruthOrDareSetupState extends Equatable {
  const TruthOrDareSetupState({
    this.players = const [],
    this.config = const TruthOrDareConfig(),
  });

  final List<TruthOrDarePlayer> players;
  final TruthOrDareConfig config;

  bool get hasEnoughPlayers =>
      players.length >= TruthOrDareConfig.minPlayers &&
      players.length <= TruthOrDareConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart => hasEnoughPlayers && allNamesFilled;

  TruthOrDareSetup buildSetup() =>
      TruthOrDareSetup(players: players, config: config);

  TruthOrDareSetupState copyWith({
    List<TruthOrDarePlayer>? players,
    TruthOrDareConfig? config,
  }) {
    return TruthOrDareSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [players, config];
}
