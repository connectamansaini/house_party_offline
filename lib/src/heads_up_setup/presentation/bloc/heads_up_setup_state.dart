part of 'heads_up_setup_bloc.dart';

enum HeadsUpPacksStatus { loading, ready, error }

/// Mutable form state for the Heads Up setup flow.
class HeadsUpSetupState extends Equatable {
  const HeadsUpSetupState({
    this.players = const [],
    this.config = const HeadsUpConfig(),
    this.packsStatus = HeadsUpPacksStatus.loading,
    this.availablePacks = const [],
    this.selectedPackIds = const {},
  });

  final List<HeadsUpPlayer> players;
  final HeadsUpConfig config;
  final HeadsUpPacksStatus packsStatus;
  final List<ImposterPackEntity> availablePacks;
  final Set<String> selectedPackIds;

  bool get hasEnoughPlayers =>
      players.length >= HeadsUpConfig.minPlayers &&
      players.length <= HeadsUpConfig.maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  List<ImposterPackEntity> get selectedPacks =>
      availablePacks.where((p) => selectedPackIds.contains(p.id)).toList();

  /// Every word from every selected pack, de-duplicated, in pack order.
  List<String> get words => {
    for (final pack in selectedPacks) ...pack.words,
  }.toList();

  bool get canStart => hasEnoughPlayers && allNamesFilled && words.isNotEmpty;

  HeadsUpSetup buildSetup() =>
      HeadsUpSetup(players: players, config: config, words: words);

  HeadsUpSetupState copyWith({
    List<HeadsUpPlayer>? players,
    HeadsUpConfig? config,
    HeadsUpPacksStatus? packsStatus,
    List<ImposterPackEntity>? availablePacks,
    Set<String>? selectedPackIds,
  }) {
    return HeadsUpSetupState(
      players: players ?? this.players,
      config: config ?? this.config,
      packsStatus: packsStatus ?? this.packsStatus,
      availablePacks: availablePacks ?? this.availablePacks,
      selectedPackIds: selectedPackIds ?? this.selectedPackIds,
    );
  }

  @override
  List<Object?> get props => [
    players,
    config,
    packsStatus,
    availablePacks,
    selectedPackIds,
  ];
}
