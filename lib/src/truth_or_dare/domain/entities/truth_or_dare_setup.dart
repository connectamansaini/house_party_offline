import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';

part 'truth_or_dare_setup.freezed.dart';

/// Validated input to a Truth or Dare match: the roster and settings.
@freezed
abstract class TruthOrDareSetup with _$TruthOrDareSetup {
  const factory TruthOrDareSetup({
    required List<TruthOrDarePlayer> players,
    required TruthOrDareConfig config,
  }) = _TruthOrDareSetup;
}
