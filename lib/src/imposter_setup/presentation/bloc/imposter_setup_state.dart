part of 'imposter_setup_bloc.dart';

/// Loading status of the available word packs.
enum ImposterSetupPacksStatus { loading, ready, error }

/// Mutable form state for the imposter setup flow. A single immutable
/// snapshot with [copyWith]; the bloc swaps whole snapshots.
class ImposterSetupState extends Equatable {
  const ImposterSetupState({
    this.packsStatus = ImposterSetupPacksStatus.loading,
    this.availablePacks = const <ImposterPackEntity>[],
    this.selectedPackIds = const {},
    this.players = const <Player>[],
    this.imposterCount = 1,
    this.imposterMode = ImposterMode.blank,
    this.categoryHintEnabled = false,
    this.secretVoting = false,
    this.discussionMinutes = 3,
    this.civilianWinPoints = 1,
    this.imposterWinPoints = 2,
    this.errorMessage,
  });

  final ImposterSetupPacksStatus packsStatus;
  final List<ImposterPackEntity> availablePacks;
  final Set<String> selectedPackIds;
  final List<Player> players;
  final int imposterCount;
  final ImposterMode imposterMode;
  final bool categoryHintEnabled;
  final bool secretVoting;
  final int discussionMinutes;
  final int civilianWinPoints;
  final int imposterWinPoints;
  final String? errorMessage;

  /// A party game needs an imposter plus at least two others to bluff.
  static const minPlayers = 3;
  static const maxPlayers = 12;

  /// Largest imposter count that still leaves a civilian member.
  int get maxImposters => GameConfig.maxImposters(players.length);

  bool get hasEnoughPlayers =>
      players.length >= minPlayers && players.length <= maxPlayers;

  bool get allNamesFilled => players.every((p) => p.name.trim().isNotEmpty);

  /// The available packs the host has selected, in display order.
  List<ImposterPackEntity> get selectedPacks =>
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
        packs: [for (final pack in selectedPacks) _toWordPack(pack)],
        imposterCount: imposterCount,
        imposterMode: imposterMode,
        categoryHintEnabled: categoryHintEnabled,
        secretVoting: secretVoting,
        discussionTime: Duration(minutes: discussionMinutes),
        civilianWinPoints: civilianWinPoints,
        imposterWinPoints: imposterWinPoints,
      ),
    );
  }

  /// [GameConfig] still speaks the pre-migration [WordPack] shape — it feeds
  /// the not-yet-migrated Imposter game engine. This adapts the pack
  /// picker's [ImposterPackEntity] to it at the setup/game boundary.
  static WordPack _toWordPack(ImposterPackEntity pack) => WordPack(
    id: pack.id,
    name: pack.name,
    category: pack.category,
    words: pack.words,
    isCustom: pack.isCustom,
  );

  ImposterSetupState copyWith({
    ImposterSetupPacksStatus? packsStatus,
    List<ImposterPackEntity>? availablePacks,
    Set<String>? selectedPackIds,
    List<Player>? players,
    int? imposterCount,
    ImposterMode? imposterMode,
    bool? categoryHintEnabled,
    bool? secretVoting,
    int? discussionMinutes,
    int? civilianWinPoints,
    int? imposterWinPoints,
    String? errorMessage,
  }) {
    return ImposterSetupState(
      packsStatus: packsStatus ?? this.packsStatus,
      availablePacks: availablePacks ?? this.availablePacks,
      selectedPackIds: selectedPackIds ?? this.selectedPackIds,
      players: players ?? this.players,
      imposterCount: imposterCount ?? this.imposterCount,
      imposterMode: imposterMode ?? this.imposterMode,
      categoryHintEnabled: categoryHintEnabled ?? this.categoryHintEnabled,
      secretVoting: secretVoting ?? this.secretVoting,
      discussionMinutes: discussionMinutes ?? this.discussionMinutes,
      civilianWinPoints: civilianWinPoints ?? this.civilianWinPoints,
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
    imposterMode,
    categoryHintEnabled,
    secretVoting,
    discussionMinutes,
    civilianWinPoints,
    imposterWinPoints,
    errorMessage,
  ];
}
