import 'package:house_party_offline/src/imposter_game/domain/entities/imposter_mode.dart';
import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'imposter_setup_preferences_dto.g.dart';

/// Serializable form of [ImposterSetupPreferencesEntity] for the Hive
/// settings box.
@JsonSerializable()
class ImposterSetupPreferencesDto {
  const ImposterSetupPreferencesDto({
    this.playerNames = const <String>[],
    this.imposterCount = 1,
    this.imposterMode = ImposterMode.blank,
    this.categoryHintEnabled = false,
    this.secretVoting = false,
    this.discussionMinutes = 3,
    this.civilianWinPoints = 1,
    this.imposterWinPoints = 2,
    this.selectedPackIds = const <String>[],
  });

  factory ImposterSetupPreferencesDto.fromJson(Map<String, dynamic> json) =>
      _$ImposterSetupPreferencesDtoFromJson(json);

  /// Tolerant of Hive's `Map<dynamic, dynamic>` reads. Migrates prefs saved
  /// by older versions: a single `selectedPackId` field (now plural) and
  /// prefs saved before [ImposterMode] existed.
  ///
  /// Hand-written rather than routed through
  /// [ImposterSetupPreferencesDto.fromJson]: the generated decoder expects
  /// exact field names and types, and can't express a field rename or an
  /// enum-name fallback.
  factory ImposterSetupPreferencesDto.fromMap(Map<dynamic, dynamic> map) {
    return ImposterSetupPreferencesDto(
      playerNames: (map['playerNames'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      imposterCount: map['imposterCount'] as int? ?? 1,
      imposterMode: _readMode(map['imposterMode']),
      categoryHintEnabled: map['categoryHintEnabled'] as bool? ?? false,
      secretVoting: map['secretVoting'] as bool? ?? false,
      discussionMinutes: map['discussionMinutes'] as int? ?? 3,
      civilianWinPoints: map['civilianWinPoints'] as int? ?? 1,
      imposterWinPoints: map['imposterWinPoints'] as int? ?? 2,
      selectedPackIds: _readPackIds(map),
    );
  }

  factory ImposterSetupPreferencesDto.fromEntity(
    ImposterSetupPreferencesEntity entity,
  ) {
    return ImposterSetupPreferencesDto(
      playerNames: entity.playerNames,
      imposterCount: entity.imposterCount,
      imposterMode: entity.imposterMode,
      categoryHintEnabled: entity.categoryHintEnabled,
      secretVoting: entity.secretVoting,
      discussionMinutes: entity.discussionMinutes,
      civilianWinPoints: entity.civilianWinPoints,
      imposterWinPoints: entity.imposterWinPoints,
      selectedPackIds: entity.selectedPackIds,
    );
  }

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

  Map<String, dynamic> toJson() => _$ImposterSetupPreferencesDtoToJson(this);

  ImposterSetupPreferencesEntity toEntity() => ImposterSetupPreferencesEntity(
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
