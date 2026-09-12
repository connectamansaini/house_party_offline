import 'package:equatable/equatable.dart';

/// What the Mafia setup screen remembers about narrating between games:
/// whether a host runs the night, whether the job rotates, and who took it
/// last. Kept out of `MafiaConfig` because none of it is a rule of the
/// match — it only decides how the next setup screen opens.
class MafiaHostPreferences extends Equatable {
  const MafiaHostPreferences({
    this.enabled = false,
    this.rotate = false,
    this.lastHostName,
  });

  /// Whether the last game was narrated.
  final bool enabled;

  /// Whether the job moves to the next person on the roster each game.
  final bool rotate;

  /// Who narrated the last game, so rotation knows where it left off.
  final String? lastHostName;

  MafiaHostPreferences copyWith({
    bool? enabled,
    bool? rotate,
    String? lastHostName,
    bool clearLastHost = false,
  }) {
    return MafiaHostPreferences(
      enabled: enabled ?? this.enabled,
      rotate: rotate ?? this.rotate,
      lastHostName: clearLastHost ? null : (lastHostName ?? this.lastHostName),
    );
  }

  @override
  List<Object?> get props => [enabled, rotate, lastHostName];
}
