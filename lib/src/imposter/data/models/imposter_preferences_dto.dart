import 'package:house_party_offline/src/imposter/domain/entities/imposter_mode.dart';
import 'package:house_party_offline/src/imposter/domain/entities/imposter_preferences.dart';

/// Serializable form of [ImposterPreferences] for the Hive settings box.
class ImposterPreferencesDto {
  const ImposterPreferencesDto({
    required this.playerNames,
    required this.imposterCount,
    required this.imposterMode,
    required this.categoryHintEnabled,
    required this.secretVoting,
    required this.discussionMinutes,
    required this.civilianWinPoints,
    required this.imposterWinPoints,
    this.selectedPackIds = const [],
  });

  /// Tolerant of Hive's `Map<dynamic, dynamic>` reads. Migrates prefs saved
  /// with the older single `selectedPackId` field and pre-mode prefs.
  factory ImposterPreferencesDto.fromMap(Map<dynamic, dynamic> map) {
    return ImposterPreferencesDto(
      playerNames: (map['playerNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imposterCount: map['imposterCount'] as int,
      imposterMode: _readMode(map['imposterMode']),
      categoryHintEnabled: map['categoryHintEnabled'] as bool,
      secretVoting: (map['secretVoting'] as bool?) ?? false,
      discussionMinutes: map['discussionMinutes'] as int,
      civilianWinPoints: map['civilianWinPoints'] as int,
      imposterWinPoints: map['imposterWinPoints'] as int,
      selectedPackIds: _readPackIds(map),
    );
  }

  factory ImposterPreferencesDto.fromDomain(ImposterPreferences p) =>
      ImposterPreferencesDto(
        playerNames: p.playerNames,
        imposterCount: p.imposterCount,
        imposterMode: p.imposterMode,
        categoryHintEnabled: p.categoryHintEnabled,
        secretVoting: p.secretVoting,
        discussionMinutes: p.discussionMinutes,
        civilianWinPoints: p.civilianWinPoints,
        imposterWinPoints: p.imposterWinPoints,
        selectedPackIds: p.selectedPackIds,
      );

  final List<String> playerNames;
  final int imposterCount;
  final ImposterMode imposterMode;
  final bool categoryHintEnabled;
  final bool secretVoting;
  final int discussionMinutes;
  final int civilianWinPoints;
  final int imposterWinPoints;
  final List<String> selectedPackIds;

  static ImposterMode _readMode(dynamic raw) => ImposterMode.values.firstWhere(
    (m) => m.name == raw,
    orElse: () => ImposterMode.blank,
  );

  static List<String> _readPackIds(Map<dynamic, dynamic> map) {
    final ids = map['selectedPackIds'];
    if (ids is List) return ids.map((e) => e as String).toList();
    final legacy = map['selectedPackId'];
    return legacy is String ? [legacy] : const [];
  }

  Map<String, dynamic> toMap() => {
    'playerNames': playerNames,
    'imposterCount': imposterCount,
    'imposterMode': imposterMode.name,
    'categoryHintEnabled': categoryHintEnabled,
    'secretVoting': secretVoting,
    'discussionMinutes': discussionMinutes,
    'civilianWinPoints': civilianWinPoints,
    'imposterWinPoints': imposterWinPoints,
    'selectedPackIds': selectedPackIds,
  };

  ImposterPreferences toDomain() => ImposterPreferences(
    playerNames: playerNames,
    imposterCount: imposterCount,
    imposterMode: imposterMode,
    categoryHintEnabled: categoryHintEnabled,
    secretVoting: secretVoting,
    discussionMinutes: discussionMinutes,
    civilianWinPoints: civilianWinPoints,
    imposterWinPoints: imposterWinPoints,
    selectedPackIds: selectedPackIds,
  );
}
