import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/imposter_mode.dart';

part 'imposter_setup_preferences_entity.freezed.dart';

/// The host's last-used setup choices, persisted so New Game pre-fills
/// instead of starting blank.
@freezed
abstract class ImposterSetupPreferencesEntity
    with _$ImposterSetupPreferencesEntity {
  const factory ImposterSetupPreferencesEntity({
    @Default(<String>[]) List<String> playerNames,
    @Default(1) int imposterCount,
    @Default(ImposterMode.blank) ImposterMode imposterMode,
    @Default(false) bool categoryHintEnabled,
    @Default(false) bool secretVoting,
    @Default(3) int discussionMinutes,
    @Default(1) int civilianWinPoints,
    @Default(2) int imposterWinPoints,
    // Ids of the last-chosen packs; some may no longer exist (e.g. a deleted
    // custom pack), so consumers must fall back gracefully.
    @Default(<String>[]) List<String> selectedPackIds,
  }) = _ImposterSetupPreferencesEntity;

  static const empty = ImposterSetupPreferencesEntity();
}
