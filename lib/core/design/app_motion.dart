import 'package:flutter/widgets.dart';

/// Motion tokens. Three durations and one curve are enough for an app this
/// size — using the same few values everywhere is what makes motion feel
/// like one system instead of a pile of one-off tweens.
abstract final class AppMotion {
  /// Press feedback, selection toggles.
  static const fast = Duration(milliseconds: 160);

  /// Page and phase transitions.
  static const base = Duration(milliseconds: 260);

  /// Entrances and reveals.
  static const slow = Duration(milliseconds: 420);

  static const Curve curve = Curves.easeOutCubic;
  static const Curve reverseCurve = Curves.easeInCubic;

  /// Shared [AnimatedSwitcher.transitionBuilder]: a fade plus a very short
  /// rise, so phase changes read as "the next thing arriving" rather than a
  /// hard cut or a plain crossfade.
  static Widget fadeRise(Widget child, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: curve);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
