/// The two gestures a player makes with the phone on their forehead.
enum HeadsUpTilt {
  /// Tilted face-down: they got it.
  correct,

  /// Tilted face-up: skip it.
  pass,
}

/// Turns device motion into [HeadsUpTilt] gestures. Abstracted so the bloc
/// can be driven without hardware, and so the on-screen buttons remain the
/// source of truth on devices without an accelerometer.
abstract interface class HeadsUpTiltSensor {
  Stream<HeadsUpTilt> get gestures;
}

/// No hardware: gestures never arrive; the buttons do the work.
class NoHeadsUpTiltSensor implements HeadsUpTiltSensor {
  const NoHeadsUpTiltSensor();

  @override
  Stream<HeadsUpTilt> get gestures => const Stream.empty();
}
