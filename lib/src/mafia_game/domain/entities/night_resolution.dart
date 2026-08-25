import 'package:freezed_annotation/freezed_annotation.dart';

part 'night_resolution.freezed.dart';

/// The outcome of resolving one night: who (if anyone) died, and whether the
/// mafia's target was saved by the doctor.
@freezed
abstract class NightResolution with _$NightResolution {
  const factory NightResolution({
    /// The player who died overnight, or null if nobody did.
    String? killedId,

    /// The player the mafia targeted but the doctor protected, or null.
    String? savedId,
  }) = _NightResolution;

  const NightResolution._();

  bool get someoneDied => killedId != null;
  bool get someoneSaved => savedId != null;
}
