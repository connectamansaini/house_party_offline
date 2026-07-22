import '../../domain/entities/imposter_preferences.dart';

/// Serializable form of [ImposterPreferences] for the Hive settings box.
class ImposterPreferencesDto {
  const ImposterPreferencesDto({
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
  final List<String> selectedPackIds;

  /// Tolerant of Hive's `Map<dynamic, dynamic>` reads. Migrates prefs saved
  /// with the older single `selectedPackId` field.
  factory ImposterPreferencesDto.fromMap(Map<dynamic, dynamic> map) {
    return ImposterPreferencesDto(
      playerNames:
          (map['playerNames'] as List<dynamic>).map((e) => e as String).toList(),
      imposterCount: map['imposterCount'] as int,
      categoryHintEnabled: map['categoryHintEnabled'] as bool,
      discussionMinutes: map['discussionMinutes'] as int,
      crewWinPoints: map['crewWinPoints'] as int,
      imposterWinPoints: map['imposterWinPoints'] as int,
      selectedPackIds: _readPackIds(map),
    );
  }

  static List<String> _readPackIds(Map<dynamic, dynamic> map) {
    final ids = map['selectedPackIds'];
    if (ids is List) return ids.map((e) => e as String).toList();
    final legacy = map['selectedPackId'];
    return legacy is String ? [legacy] : const [];
  }

  Map<String, dynamic> toMap() => {
    'playerNames': playerNames,
    'imposterCount': imposterCount,
    'categoryHintEnabled': categoryHintEnabled,
    'discussionMinutes': discussionMinutes,
    'crewWinPoints': crewWinPoints,
    'imposterWinPoints': imposterWinPoints,
    'selectedPackIds': selectedPackIds,
  };

  factory ImposterPreferencesDto.fromDomain(ImposterPreferences p) =>
      ImposterPreferencesDto(
        playerNames: p.playerNames,
        imposterCount: p.imposterCount,
        categoryHintEnabled: p.categoryHintEnabled,
        discussionMinutes: p.discussionMinutes,
        crewWinPoints: p.crewWinPoints,
        imposterWinPoints: p.imposterWinPoints,
        selectedPackIds: p.selectedPackIds,
      );

  ImposterPreferences toDomain() => ImposterPreferences(
    playerNames: playerNames,
    imposterCount: imposterCount,
    categoryHintEnabled: categoryHintEnabled,
    discussionMinutes: discussionMinutes,
    crewWinPoints: crewWinPoints,
    imposterWinPoints: imposterWinPoints,
    selectedPackIds: selectedPackIds,
  );
}
