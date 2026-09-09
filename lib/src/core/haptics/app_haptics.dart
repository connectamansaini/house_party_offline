import 'dart:async';

import 'package:flutter/services.dart';

/// The app's four haptic "words". Using the same few everywhere is what
/// makes them read as feedback rather than noise:
///
/// - [select]: a row or option toggled.
/// - [confirm]: a turn or round resolved; the game moved on.
/// - [reveal]: something hidden is now on screen — a role, a prompt.
/// - [win]: the match is over.
///
/// Calls are fire-and-forget; on devices without a vibrator the platform
/// simply ignores them.
abstract final class AppHaptics {
  static void select() => unawaited(HapticFeedback.selectionClick());
  static void confirm() => unawaited(HapticFeedback.lightImpact());
  static void reveal() => unawaited(HapticFeedback.mediumImpact());
  static void win() => unawaited(HapticFeedback.heavyImpact());
}
