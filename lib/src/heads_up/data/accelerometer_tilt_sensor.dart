import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// [HeadsUpTiltSensor] backed by the accelerometer.
///
/// With the phone held upright on the forehead, gravity runs along the
/// screen's plane and the z axis (out of the screen) reads near zero. Tilting
/// the screen toward the floor drives z strongly negative; toward the
/// ceiling, strongly positive. A gesture fires once past [_fireThreshold]
/// and re-arms only after the phone returns near upright, so one tilt is
/// one gesture no matter how long it's held.
class AccelerometerTiltSensor implements HeadsUpTiltSensor {
  AccelerometerTiltSensor({Stream<AccelerometerEvent>? events})
    : _events = events;

  final Stream<AccelerometerEvent>? _events;

  static const _fireThreshold = 7.0;
  static const _rearmThreshold = 4.0;

  @override
  Stream<HeadsUpTilt> get gestures async* {
    var armed = true;
    final source =
        _events ??
        accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval);
    await for (final event in source) {
      final z = event.z;
      if (armed) {
        if (z < -_fireThreshold) {
          armed = false;
          yield HeadsUpTilt.correct;
        } else if (z > _fireThreshold) {
          armed = false;
          yield HeadsUpTilt.pass;
        }
      } else if (z.abs() < _rearmThreshold) {
        armed = true;
      }
    }
  }
}
