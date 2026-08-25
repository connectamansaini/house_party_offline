// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imposter_setup_preferences_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImposterSetupPreferencesDto _$ImposterSetupPreferencesDtoFromJson(
  Map<String, dynamic> json,
) => ImposterSetupPreferencesDto(
  playerNames:
      (json['playerNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  imposterCount: (json['imposterCount'] as num?)?.toInt() ?? 1,
  imposterMode:
      $enumDecodeNullable(_$ImposterModeEnumMap, json['imposterMode']) ??
      ImposterMode.blank,
  categoryHintEnabled: json['categoryHintEnabled'] as bool? ?? false,
  secretVoting: json['secretVoting'] as bool? ?? false,
  discussionMinutes: (json['discussionMinutes'] as num?)?.toInt() ?? 3,
  civilianWinPoints: (json['civilianWinPoints'] as num?)?.toInt() ?? 1,
  imposterWinPoints: (json['imposterWinPoints'] as num?)?.toInt() ?? 2,
  selectedPackIds:
      (json['selectedPackIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$ImposterSetupPreferencesDtoToJson(
  ImposterSetupPreferencesDto instance,
) => <String, dynamic>{
  'playerNames': instance.playerNames,
  'imposterCount': instance.imposterCount,
  'imposterMode': _$ImposterModeEnumMap[instance.imposterMode]!,
  'categoryHintEnabled': instance.categoryHintEnabled,
  'secretVoting': instance.secretVoting,
  'discussionMinutes': instance.discussionMinutes,
  'civilianWinPoints': instance.civilianWinPoints,
  'imposterWinPoints': instance.imposterWinPoints,
  'selectedPackIds': instance.selectedPackIds,
};

const _$ImposterModeEnumMap = {
  ImposterMode.blank: 'blank',
  ImposterMode.undercover: 'undercover',
};
