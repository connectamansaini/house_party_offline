import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_party_offline/core/design/app_motion.dart';

/// The one page transition used everywhere: a short fade-and-rise, so
/// navigation feels like a single system instead of the platform's default
/// zoom.
///
/// On Android 13+ the system reports the back swipe as it happens (see
/// `enableOnBackInvokedCallback` in the manifest). While a route is being
/// dragged away this builder follows the finger instead of playing a canned
/// animation: the page shrinks a little, rounds its corners and slides with
/// the gesture, then springs back if the swipe is cancelled or fades out if
/// it is committed. Programmatic pops and the app bar's back button still
/// get the plain fade-and-rise.
///
/// Routes guarded by a [PopScope] with `canPop: false` (a game in progress)
/// never peek: the framework reports them as not poppable, so the system
/// hands the release straight to the "leave game?" dialog as before.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Duration get transitionDuration => AppMotion.base;

  @override
  Duration get reverseTransitionDuration => AppMotion.fast;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _BackGestureDetector(
      route: route,
      builder: (context, gesture) {
        if (gesture != null) {
          return PredictiveBackPeek(
            animation: animation,
            gesture: gesture,
            child: child,
          );
        }
        return FadeRisePageTransition(animation: animation, child: child);
      },
    );
  }
}

/// A fade plus a very short rise on push, reversed on pop.
class FadeRisePageTransition extends StatefulWidget {
  const FadeRisePageTransition({
    required this.animation,
    required this.child,
    super.key,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  State<FadeRisePageTransition> createState() => _FadeRisePageTransitionState();
}

class _FadeRisePageTransitionState extends State<FadeRisePageTransition> {
  late CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _curved = _curve(widget.animation);
  }

  @override
  void didUpdateWidget(FadeRisePageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) {
      _curved.dispose();
      _curved = _curve(widget.animation);
    }
  }

  @override
  void dispose() {
    _curved.dispose();
    super.dispose();
  }

  static CurvedAnimation _curve(Animation<double> parent) => CurvedAnimation(
    parent: parent,
    curve: AppMotion.curve,
    reverseCurve: AppMotion.reverseCurve,
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(_curved),
        child: widget.child,
      ),
    );
  }
}

/// Where a back gesture is in its life.
enum BackGesturePhase {
  /// The finger is down and moving; the route follows it.
  dragging,

  /// The finger lifted short of the threshold; the route eases back.
  cancelled,

  /// The finger lifted past the threshold; the route is popping.
  committed,
}

/// What [PredictiveBackPeek] needs to know about the current back gesture.
class BackGesture {
  const BackGesture({
    required this.phase,
    required this.start,
    required this.current,
    this.amountAtEnd = 0,
    this.yShiftAtEnd = 0,
  });

  final BackGesturePhase phase;
  final PredictiveBackEvent start;
  final PredictiveBackEvent current;

  /// How far the peek had progressed (0–1) when the finger lifted, so the
  /// cancel and commit animations start from where the drag left off.
  final double amountAtEnd;

  /// The vertical shift when the finger lifted, for the same reason.
  final double yShiftAtEnd;

  BackGesture copyWith({
    BackGesturePhase? phase,
    PredictiveBackEvent? current,
    double? amountAtEnd,
    double? yShiftAtEnd,
  }) {
    return BackGesture(
      phase: phase ?? this.phase,
      start: start,
      current: current ?? this.current,
      amountAtEnd: amountAtEnd ?? this.amountAtEnd,
      yShiftAtEnd: yShiftAtEnd ?? this.yShiftAtEnd,
    );
  }
}

/// The route as it looks mid-gesture: scaled down towards 90%, corners
/// rounded to the display's, nudged sideways away from the swipe edge and
/// up or down with the finger. Loosely follows Android's shared-element
/// predictive back spec, kept simpler than the framework's own version so
/// the fallback can stay our fade-and-rise.
class PredictiveBackPeek extends StatelessWidget {
  const PredictiveBackPeek({
    required this.animation,
    required this.gesture,
    required this.child,
    super.key,
  });

  final Animation<double> animation;
  final BackGesture gesture;
  final Widget child;

  static const _minScale = 0.9;
  static const _divisionFactor = 20.0;
  static const _margin = 8.0;
  static const _cornerRadius = 32.0;

  /// The vertical nudge for a drag from [start] to [current] on a screen of
  /// [height]: eased and capped so the page never wanders far.
  static double yShift(
    PredictiveBackEvent start,
    PredictiveBackEvent current,
    double height,
  ) {
    final raw = (current.touchOffset?.dy ?? 0) - (start.touchOffset?.dy ?? 0);
    final max = height / _divisionFactor - _margin;
    final eased =
        Curves.easeOut.transform((raw.abs() / height).clamp(0.0, 1.0)) *
        raw.sign *
        max;
    return eased.clamp(-max, max);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final size = MediaQuery.sizeOf(context);
        final double amount;
        final double dy;
        var opacity = 1.0;
        switch (gesture.phase) {
          case BackGesturePhase.dragging:
            // The system drives the route's animation from 1 down towards 0
            // as the finger travels.
            amount = 1 - animation.value;
            dy = yShift(gesture.start, gesture.current, size.height);
          case BackGesturePhase.cancelled:
            // The animation runs back up to 1; ease the vertical nudge away
            // in step so nothing snaps.
            amount = 1 - animation.value;
            final remaining = gesture.amountAtEnd == 0
                ? 0.0
                : (amount / gesture.amountAtEnd).clamp(0.0, 1.0);
            dy = gesture.yShiftAtEnd * remaining;
          case BackGesturePhase.committed:
            // The pop restarts the animation from 1 and runs it to 0; hold
            // the geometry and use that run as a fade.
            amount = gesture.amountAtEnd;
            dy = gesture.yShiftAtEnd;
            opacity = Curves.easeIn.transform(animation.value.clamp(0.0, 1.0));
        }
        final xMax = size.width / _divisionFactor - _margin;
        final dx = switch (gesture.current.swipeEdge) {
          SwipeEdge.right => -xMax * amount,
          SwipeEdge.left => xMax * amount,
        };
        final corners = MediaQuery.displayCornerRadiiOf(context);
        return Transform.scale(
          scale: 1 - (1 - _minScale) * amount,
          child: Transform.translate(
            offset: Offset(dx, dy),
            child: Opacity(
              opacity: opacity,
              child: ClipRRect(
                borderRadius: corners == null
                    ? BorderRadius.circular(_cornerRadius * amount)
                    : BorderRadius.lerp(BorderRadius.zero, corners, amount)!,
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// Listens for the system's back-gesture events on behalf of one route and
/// forwards them to the route so it drives its own transition animation.
/// Reports the gesture to [builder] only while the navigator says one is in
/// progress, which lasts until the cancel or commit animation has settled.
class _BackGestureDetector extends StatefulWidget {
  const _BackGestureDetector({required this.route, required this.builder});

  final PageRoute<dynamic> route;
  final Widget Function(BuildContext context, BackGesture? gesture) builder;

  @override
  State<_BackGestureDetector> createState() => _BackGestureDetectorState();
}

class _BackGestureDetectorState extends State<_BackGestureDetector>
    with WidgetsBindingObserver {
  BackGesture? _gesture;

  bool get _enabled => widget.route.isCurrent && widget.route.popGestureEnabled;

  double get _amount => 1 - (widget.route.animation?.value ?? 1);

  void _set(BackGesture? gesture) {
    if (mounted) setState(() => _gesture = gesture);
  }

  BackGesture? _ended(BackGesturePhase phase) {
    final gesture = _gesture;
    if (gesture == null) return null;
    return gesture.copyWith(
      phase: phase,
      amountAtEnd: _amount,
      yShiftAtEnd: PredictiveBackPeek.yShift(
        gesture.start,
        gesture.current,
        MediaQuery.sizeOf(context).height,
      ),
    );
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    if (backEvent.isButtonEvent || !_enabled) return false;
    widget.route.handleStartBackGesture(progress: 1 - backEvent.progress);
    _set(
      BackGesture(
        phase: BackGesturePhase.dragging,
        start: backEvent,
        current: backEvent,
      ),
    );
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    widget.route.handleUpdateBackGestureProgress(
      progress: 1 - backEvent.progress,
    );
    _set(_gesture?.copyWith(current: backEvent));
  }

  @override
  void handleCancelBackGesture() {
    _set(_ended(BackGesturePhase.cancelled));
    widget.route.handleCancelBackGesture();
  }

  @override
  void handleCommitBackGesture() {
    _set(_ended(BackGesturePhase.committed));
    widget.route.handleCommitBackGesture();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gesture = widget.route.popGestureInProgress ? _gesture : null;
    return widget.builder(context, gesture);
  }
}
