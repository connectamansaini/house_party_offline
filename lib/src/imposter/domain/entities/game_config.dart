import 'package:equatable/equatable.dart';

import 'imposter_mode.dart';
import 'word_pack.dart';

/// Per-game settings chosen by the host during setup. Immutable once a game
/// starts.
class GameConfig extends Equatable {
  const GameConfig({
    required this.packs,
    this.imposterCount = 1,
    this.imposterMode = ImposterMode.blank,
    this.categoryHintEnabled = false,
    this.secretVoting = false,
    this.discussionTime = const Duration(minutes: 3),
    this.civilianWinPoints = 1,
    this.imposterWinPoints = 2,
  });

  /// The word packs rounds draw their secret word from. When more than one is
  /// selected, the word is chosen across all of them and the category hint (if
  /// enabled) reflects the chosen word's own pack.
  final List<WordPack> packs;

  /// What the imposter receives at reveal (nothing vs. a decoy word).
  final ImposterMode imposterMode;

  /// How many imposters are dealt in each round. Must satisfy
  /// `1 <= imposterCount < playerCount`.
  final int imposterCount;

  /// When true, imposters are told the chosen word's category as a hint.
  final bool categoryHintEnabled;

  /// When true, voting is a pass-and-play secret ballot (each player casts
  /// privately, then the votes are tallied). When false, the group casts one
  /// shared vote on the device.
  final bool secretVoting;

  final Duration discussionTime;

  /// Points awarded to each member of the winning side.
  final int civilianWinPoints;
  final int imposterWinPoints;

  /// Largest imposter count that still leaves at least one civilian member.
  static int maxImposters(int playerCount) =>
      playerCount <= 1 ? 0 : playerCount - 1;

  GameConfig copyWith({
    List<WordPack>? packs,
    int? imposterCount,
    ImposterMode? imposterMode,
    bool? categoryHintEnabled,
    bool? secretVoting,
    Duration? discussionTime,
    int? civilianWinPoints,
    int? imposterWinPoints,
  }) {
    return GameConfig(
      packs: packs ?? this.packs,
      imposterCount: imposterCount ?? this.imposterCount,
      imposterMode: imposterMode ?? this.imposterMode,
      categoryHintEnabled: categoryHintEnabled ?? this.categoryHintEnabled,
      secretVoting: secretVoting ?? this.secretVoting,
      discussionTime: discussionTime ?? this.discussionTime,
      civilianWinPoints: civilianWinPoints ?? this.civilianWinPoints,
      imposterWinPoints: imposterWinPoints ?? this.imposterWinPoints,
    );
  }

  @override
  List<Object?> get props => [
    packs,
    imposterCount,
    imposterMode,
    categoryHintEnabled,
    secretVoting,
    discussionTime,
    civilianWinPoints,
    imposterWinPoints,
  ];
}
