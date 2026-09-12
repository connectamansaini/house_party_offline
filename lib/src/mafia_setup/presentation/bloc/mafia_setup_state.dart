part of 'mafia_setup_bloc.dart';

/// Mutable form state for the Mafia setup flow.
class MafiaSetupState extends Equatable {
  const MafiaSetupState({
    this.players = const [],
    this.config = const MafiaConfig(),
    this.hostId,
    this.rotateHost = false,
  });

  /// Everyone in the room, narrator included.
  final List<MafiaPlayer> players;
  final MafiaConfig config;

  /// The roster entry running the night, or null for pass-and-play.
  final String? hostId;

  /// Whether the next game hands narrating to the next person along.
  final bool rotateHost;

  bool get isHosted => hostId != null;

  /// The narrator, if the chosen id still matches someone on the roster.
  MafiaPlayer? get host {
    if (hostId == null) return null;
    for (final p in players) {
      if (p.id == hostId) return p;
    }
    return null;
  }

  /// Everyone who gets dealt a role — the roster minus the narrator.
  List<MafiaPlayer> get dealtPlayers => [
    for (final p in players)
      if (p.id != hostId) p,
  ];

  int get playerCount => dealtPlayers.length;

  /// Roster size limits, which shift by one when a narrator takes a seat.
  int get rosterMinimum => MafiaConfig.minPlayers + (isHosted ? 1 : 0);
  int get rosterCapacity => MafiaConfig.maxPlayers + (isHosted ? 1 : 0);

  int get maxMafia => config.maxMafiaFor(playerCount);

  bool get hasEnoughPlayers =>
      playerCount >= MafiaConfig.minPlayers &&
      playerCount <= MafiaConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  bool get canStart =>
      hasEnoughPlayers &&
      allNamesFilled &&
      config.mafiaCount >= 1 &&
      config.mafiaCount <= maxMafia;

  MafiaSetup buildSetup() =>
      MafiaSetup(players: dealtPlayers, config: config, host: host);

  MafiaSetupState copyWith({
    List<MafiaPlayer>? players,
    MafiaConfig? config,
    String? hostId,
    bool? rotateHost,
    bool clearHost = false,
  }) {
    return MafiaSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
      hostId: clearHost ? null : (hostId ?? this.hostId),
      rotateHost: rotateHost ?? this.rotateHost,
    );
  }

  @override
  List<Object?> get props => [players, config, hostId, rotateHost];
}
