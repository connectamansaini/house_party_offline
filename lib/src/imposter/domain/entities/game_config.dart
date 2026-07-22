import 'package:equatable/equatable.dart';

import 'word_pack.dart';

/// Per-game settings chosen by the host during setup. Immutable once a game
/// starts.
class GameConfig extends Equatable {
  const GameConfig({
    required this.packs,
    this.imposterCount = 1,
    this.categoryHintEnabled = false,
    this.discussionTime = const Duration(minutes: 3),
    this.crewWinPoints = 1,
    this.imposterWinPoints = 2,
  });

  /// The word packs rounds draw their secret word from. When more than one is
  /// selected, the word is chosen across all of them and the category hint (if
  /// enabled) reflects the chosen word's own pack.
  final List<WordPack> packs;

  /// How many imposters are dealt in each round. Must satisfy
  /// `1 <= imposterCount < playerCount`.
  final int imposterCount;

  /// When true, imposters are told the chosen word's category as a hint.
  final bool categoryHintEnabled;

  final Duration discussionTime;

  /// Points awarded to each member of the winning side.
  final int crewWinPoints;
  final int imposterWinPoints;

  /// Largest imposter count that still leaves at least one crew member.
  static int maxImposters(int playerCount) =>
      playerCount <= 1 ? 0 : playerCount - 1;

  GameConfig copyWith({
    List<WordPack>? packs,
    int? imposterCount,
    bool? categoryHintEnabled,
    Duration? discussionTime,
    int? crewWinPoints,
    int? imposterWinPoints,
  }) {
    return GameConfig(
      packs: packs ?? this.packs,
      imposterCount: imposterCount ?? this.imposterCount,
      categoryHintEnabled: categoryHintEnabled ?? this.categoryHintEnabled,
      discussionTime: discussionTime ?? this.discussionTime,
      crewWinPoints: crewWinPoints ?? this.crewWinPoints,
      imposterWinPoints: imposterWinPoints ?? this.imposterWinPoints,
    );
  }

  @override
  List<Object?> get props => [
    packs,
    imposterCount,
    categoryHintEnabled,
    discussionTime,
    crewWinPoints,
    imposterWinPoints,
  ];
}
