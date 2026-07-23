import 'package:equatable/equatable.dart';

import 'imposter_mode.dart';

/// Persisted setup choices, so a New Game pre-fills with the last roster and
/// options instead of starting blank.
class ImposterPreferences extends Equatable {
  const ImposterPreferences({
    required this.playerNames,
    required this.imposterCount,
    required this.categoryHintEnabled,
    required this.discussionMinutes,
    required this.civilianWinPoints,
    required this.imposterWinPoints,
    this.imposterMode = ImposterMode.blank,
    this.secretVoting = false,
    this.selectedPackIds = const [],
  });

  final List<String> playerNames;
  final int imposterCount;
  final ImposterMode imposterMode;
  final bool categoryHintEnabled;
  final bool secretVoting;
  final int discussionMinutes;
  final int civilianWinPoints;
  final int imposterWinPoints;

  /// Ids of the last-chosen packs; some may no longer exist (e.g. a deleted
  /// custom pack), so consumers must fall back gracefully.
  final List<String> selectedPackIds;

  @override
  List<Object?> get props => [
    playerNames,
    imposterCount,
    imposterMode,
    categoryHintEnabled,
    secretVoting,
    discussionMinutes,
    civilianWinPoints,
    imposterWinPoints,
    selectedPackIds,
  ];
}
