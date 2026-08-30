import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';

part 'never_have_i_ever_setup.freezed.dart';

/// Validated input to a Never Have I Ever match: the roster and settings.
@freezed
abstract class NeverHaveIEverSetup with _$NeverHaveIEverSetup {
  const factory NeverHaveIEverSetup({
    required List<NeverHaveIEverPlayer> players,
    required NeverHaveIEverConfig config,
  }) = _NeverHaveIEverSetup;
}
