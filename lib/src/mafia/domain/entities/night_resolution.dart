import 'package:equatable/equatable.dart';

/// The outcome of resolving one night: who (if anyone) died, and whether the
/// mafia's target was saved by the doctor.
class NightResolution extends Equatable {
  const NightResolution({this.killedId, this.savedId});

  /// The player who died overnight, or null if nobody did.
  final String? killedId;

  /// The player the mafia targeted but the doctor protected, or null.
  final String? savedId;

  bool get someoneDied => killedId != null;
  bool get someoneSaved => savedId != null;

  @override
  List<Object?> get props => [killedId, savedId];
}
