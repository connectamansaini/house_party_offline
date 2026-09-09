import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_motion.dart';

/// Squashes its child very slightly while a pointer is down. Uses a
/// [Listener] so it never competes with the child's own tap handling — put
/// the [InkWell] inside, this outside.
class Pressable extends StatefulWidget {
  const Pressable({required this.child, super.key, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  var _pressed = false;

  void _set(bool value) {
    if (_pressed != value && widget.enabled) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppMotion.fast,
        curve: AppMotion.curve,
        child: widget.child,
      ),
    );
  }
}
