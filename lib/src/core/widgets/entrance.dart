import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_motion.dart';

/// Fades and rises its child into place once, on first build. Give sibling
/// items an increasing [index] for a soft stagger.
///
/// The stagger is baked into a single animation via [Interval] rather than a
/// delayed start, so there's never a pending timer — widget tests can pump
/// without settling and still tear down cleanly.
class Entrance extends StatefulWidget {
  const Entrance({required this.child, super.key, this.index = 0});

  final Widget child;
  final int index;

  static const _stagger = Duration(milliseconds: 40);

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    final delay = Entrance._stagger * widget.index;
    final total = AppMotion.slow + delay;
    _controller = AnimationController(vsync: this, duration: total)..forward();
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: AppMotion.curve,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Honour the OS "remove animations" setting: land in place immediately.
    if (MediaQuery.disableAnimationsOf(context)) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _progress,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(_progress),
        child: widget.child,
      ),
    );
  }
}
