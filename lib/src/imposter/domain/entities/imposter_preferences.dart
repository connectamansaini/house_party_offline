import 'package:equatable/equatable.dart';

/// Persisted setup choices, so a New Game pre-fills with the last roster and
/// options instead of starting blank.
class ImposterPreferences extends Equatable {
  const ImposterPreferences({
    required this.playerNames,
    required this.imposterCount,
    required this.categoryHintEnabled,
    required this.discussionMinutes,
    required this.crewWinPoints,
    required this.imposterWinPoints,
    this.selectedPackIds = const [],
  });

  final List<String> playerNames;
  final int imposterCount;
  final bool categoryHintEnabled;
  final int discussionMinutes;
  final int crewWinPoints;
  final int imposterWinPoints;

  /// Ids of the last-chosen packs; some may no longer exist (e.g. a deleted
  /// custom pack), so consumers must fall back gracefully.
  final List<String> selectedPackIds;

  @override
  List<Object?> get props => [
    playerNames,
    imposterCount,
    categoryHintEnabled,
    discussionMinutes,
    crewWinPoints,
    imposterWinPoints,
    selectedPackIds,
  ];
}
