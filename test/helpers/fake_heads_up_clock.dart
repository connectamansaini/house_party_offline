import 'dart:async';

import 'package:house_party_offline/src/heads_up/domain/heads_up_ticker.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';

/// A clock the test drives by hand: each [tick] hands back a fresh
/// controller's stream, and the test pushes seconds-remaining values into
/// [current] whenever it likes.
class ManualHeadsUpTicker implements HeadsUpTicker {
  StreamController<int>? current;
  final requested = <int>[];

  @override
  Stream<int> tick({required int seconds}) {
    requested.add(seconds);
    current = StreamController<int>();
    return current!.stream;
  }

  /// Emits every value from [from] down to 0 synchronously in order.
  void runDown({required int from}) {
    for (var s = from - 1; s >= 0; s--) {
      current!.add(s);
    }
  }
}

/// Tilt gestures the test injects.
class ManualTiltSensor implements HeadsUpTiltSensor {
  final controller = StreamController<HeadsUpTilt>.broadcast();

  @override
  Stream<HeadsUpTilt> get gestures => controller.stream;
}
