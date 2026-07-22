import 'package:equatable/equatable.dart';

import '../../domain/entities/game_config.dart';
import '../../domain/entities/game_setup.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/word_pack.dart';

/// Loading status of the available word packs.
enum PacksStatus { loading, ready, error }

/// Mutable form state for the imposter setup flow. A single immutable snapshot
/// with [copyWith]; the cubit swaps whole snapshots.
class SetupState extends Equatable {
  const SetupState({
    this.packsStatus = PacksStatus.loading,
    this.availablePacks = const [],
    this.selectedPackIds = const {},
    this.players = const [],
    this.imposterCount = 1,
    this.categoryHintEnabled = false,
    this.discussionMinutes = 3,
    this.crewWinPoints = 1,
    this.imposterWinPoints = 2,
    this.errorMessage,
  });

  final PacksStatus packsStatus;
  final List<WordPack> availablePacks;
  final Set<String> selectedPackIds;
  final List<Player> players;
  final int imposterCount;
  final bool categoryHintEnabled;
  final int discussionMinutes;
  final int crewWinPoints;
  final int imposterWinPoints;
  final String? errorMessage;

  /// A party game needs an imposter plus at least two others to bluff.
  static const minPlayers = 3;
  static const maxPlayers = 12;

  /// Largest imposter count that still leaves a crew member.
  int get maxImposters => GameConfig.maxImposters(players.length);

  bool get hasEnoughPlayers =>
      players.length >= minPlayers && players.length <= maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  /// The available packs the host has selected, in display order.
  List<WordPack> get selectedPacks =>
      availablePacks.where((p) => selectedPackIds.contains(p.id)).toList();

  int get selectedWordCount =>
      selectedPacks.fold(0, (sum, p) => sum + p.words.length);

  bool get allPacksSelected =>
      availablePacks.isNotEmpty &&
      selectedPackIds.length == availablePacks.length;

  bool get hasUsablePacks => selectedWordCount > 0;

  /// Whether the current form is valid enough to start a game.
  bool get canStart =>
      hasEnoughPlayers &&
      allNamesFilled &&
      hasUsablePacks &&
      imposterCount >= 1 &&
      imposterCount < players.length;

  /// Builds the validated [GameSetup]. Only call when [canStart] is true.
  GameSetup buildSetup() {
    return GameSetup(
      players: players,
      config: GameConfig(
        packs: selectedPacks,
        imposterCount: imposterCount,
        categoryHintEnabled: categoryHintEnabled,
        discussionTime: Duration(minutes: discussionMinutes),
        crewWinPoints: crewWinPoints,
        imposterWinPoints: imposterWinPoints,
      ),
    );
  }

  SetupState copyWith({
    PacksStatus? packsStatus,
    List<WordPack>? availablePacks,
    Set<String>? selectedPackIds,
    List<Player>? players,
    int? imposterCount,
    bool? categoryHintEnabled,
    int? discussionMinutes,
    int? crewWinPoints,
    int? imposterWinPoints,
    String? errorMessage,
  }) {
    return SetupState(
      packsStatus: packsStatus ?? this.packsStatus,
      availablePacks: availablePacks ?? this.availablePacks,
      selectedPackIds: selectedPackIds ?? this.selectedPackIds,
      players: players ?? this.players,
      imposterCount: imposterCount ?? this.imposterCount,
      categoryHintEnabled: categoryHintEnabled ?? this.categoryHintEnabled,
      discussionMinutes: discussionMinutes ?? this.discussionMinutes,
      crewWinPoints: crewWinPoints ?? this.crewWinPoints,
      imposterWinPoints: imposterWinPoints ?? this.imposterWinPoints,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    packsStatus,
    availablePacks,
    selectedPackIds,
    players,
    imposterCount,
    categoryHintEnabled,
    discussionMinutes,
    crewWinPoints,
    imposterWinPoints,
    errorMessage,
  ];
}
