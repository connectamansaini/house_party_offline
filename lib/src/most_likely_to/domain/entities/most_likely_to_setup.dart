import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';

part 'most_likely_to_setup.freezed.dart';

/// Validated input to a Most Likely To match: the roster and settings.
@freezed
abstract class MostLikelyToSetup with _$MostLikelyToSetup {
  const factory MostLikelyToSetup({
    required List<MostLikelyToPlayer> players,
    required MostLikelyToConfig config,
  }) = _MostLikelyToSetup;
}
