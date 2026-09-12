import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';

/// One beat of a host-run night, in the order the host calls them out.
///
/// In host mode the phone never leaves the host: they read each line to the
/// room, watch what the waking players point at, and tap it in. Steps whose
/// role has been killed are skipped (see `MafiaEngine.nightSteps`).
enum MafiaNightStep {
  /// The opening beat: the town closes its eyes.
  sleep,
  mafia,
  doctor,
  detective;

  /// The role that wakes for this step, or null for [sleep].
  MafiaRole? get role => switch (this) {
    MafiaNightStep.sleep => null,
    MafiaNightStep.mafia => MafiaRole.mafia,
    MafiaNightStep.doctor => MafiaRole.doctor,
    MafiaNightStep.detective => MafiaRole.detective,
  };

  /// What the host says out loud.
  String get announcement => switch (this) {
    MafiaNightStep.sleep => 'Everyone, close your eyes.',
    MafiaNightStep.mafia => 'Mafia, open your eyes.',
    MafiaNightStep.doctor => 'Doctor, open your eyes.',
    MafiaNightStep.detective => 'Detective, open your eyes.',
  };

  /// What the host asks the waking players to do.
  String get instruction => switch (this) {
    MafiaNightStep.sleep =>
      'Wait until the room is quiet, then start the night.',
    MafiaNightStep.mafia => 'Agree on a victim silently and point at them.',
    MafiaNightStep.doctor => 'Point at the person you want to save.',
    MafiaNightStep.detective => 'Point at the person you want to check.',
  };

  /// The button label before the host has tapped anyone.
  String get confirmLabel => switch (this) {
    MafiaNightStep.sleep => 'Start the night',
    _ => 'Tap who they pointed at',
  };

  /// The button label once [name] is picked — it names the consequence, so
  /// the host can't record the wrong person by muscle memory.
  String confirmWith(String name) =>
      role?.nightVerb == null ? confirmLabel : '${role!.nightVerb} $name';
}
