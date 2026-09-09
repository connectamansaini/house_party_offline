import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';

part 'heads_up_setup.freezed.dart';

/// Validated input to a Heads Up match: the roster, settings, and the words
/// from every pack the host picked, already merged and de-duplicated.
@freezed
abstract class HeadsUpSetup with _$HeadsUpSetup {
  const factory HeadsUpSetup({
    required List<HeadsUpPlayer> players,
    required HeadsUpConfig config,
    required List<String> words,
  }) = _HeadsUpSetup;
}
