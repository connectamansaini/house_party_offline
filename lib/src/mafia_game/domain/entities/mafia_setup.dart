import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';

part 'mafia_setup.freezed.dart';

/// Validated input to a Mafia match: the roster and the chosen settings.
@freezed
abstract class MafiaSetup with _$MafiaSetup {
  const factory MafiaSetup({
    required List<MafiaPlayer> players,
    required MafiaConfig config,
  }) = _MafiaSetup;
}
