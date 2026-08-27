import 'package:flutter/material.dart';

/// A small, hand-drawn icon mark used inside a moment card. Deliberately not
/// Material icons — the app's dramatic beats (role reveals, wins, recaps)
/// get their own consistent, custom-drawn vocabulary instead.
enum MomentIcon {
  /// The imposter's identity — an eye behind a mask.
  mask,

  /// A civilian's secret word.
  key,

  /// The mafia role — a blade.
  dagger,

  /// The doctor role — protection.
  shieldCross,

  /// The detective role — investigation.
  magnifier,

  /// The villager role, or "the town" collectively.
  house,

  /// A win / celebration moment.
  laurel,

  /// A night-phase recap.
  moon,

  /// A daytime vote/lynch recap.
  gavel,
}

/// Renders a [MomentIcon] at [size] in [color].
class MomentGlyph extends StatelessWidget {
  const MomentGlyph({
    required this.icon,
    required this.color,
    this.size = 44,
    super.key,
  });

  final MomentIcon icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MomentIconPainter(icon: icon, color: color)),
    );
  }
}

class _MomentIconPainter extends CustomPainter {
  _MomentIconPainter({required this.icon, required this.color});

  final MomentIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (icon) {
      case MomentIcon.mask:
        final eye = Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.5),
          width: w * 0.86,
          height: h * 0.6,
        );
        canvas
          ..drawOval(eye, stroke)
          ..drawCircle(Offset(w * 0.5, h * 0.5), w * 0.15, fill);

      case MomentIcon.key:
        canvas
          ..drawCircle(Offset(w * 0.3, h * 0.5), w * 0.2, stroke)
          ..drawLine(
            Offset(w * 0.48, h * 0.5),
            Offset(w * 0.86, h * 0.5),
            stroke,
          )
          ..drawLine(
            Offset(w * 0.7, h * 0.5),
            Offset(w * 0.7, h * 0.68),
            stroke,
          )
          ..drawLine(
            Offset(w * 0.82, h * 0.5),
            Offset(w * 0.82, h * 0.62),
            stroke,
          );

      case MomentIcon.dagger:
        final blade = Path()
          ..moveTo(w * 0.5, h * 0.06)
          ..lineTo(w * 0.62, h * 0.42)
          ..lineTo(w * 0.5, h * 0.54)
          ..lineTo(w * 0.38, h * 0.42)
          ..close();
        canvas
          ..drawPath(blade, fill)
          ..drawLine(
            Offset(w * 0.26, h * 0.54),
            Offset(w * 0.74, h * 0.54),
            stroke,
          )
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(w * 0.44, h * 0.56, w * 0.12, h * 0.3),
              Radius.circular(w * 0.03),
            ),
            fill,
          )
          ..drawCircle(Offset(w * 0.5, h * 0.9), w * 0.06, fill);

      case MomentIcon.shieldCross:
        final shield = Path()
          ..moveTo(w * 0.5, h * 0.06)
          ..lineTo(w * 0.84, h * 0.2)
          ..lineTo(w * 0.84, h * 0.46)
          ..quadraticBezierTo(w * 0.84, h * 0.78, w * 0.5, h * 0.94)
          ..quadraticBezierTo(w * 0.16, h * 0.78, w * 0.16, h * 0.46)
          ..lineTo(w * 0.16, h * 0.2)
          ..close();
        canvas
          ..drawPath(shield, stroke)
          ..drawLine(
            Offset(w * 0.5, h * 0.36),
            Offset(w * 0.5, h * 0.64),
            stroke,
          )
          ..drawLine(
            Offset(w * 0.38, h * 0.5),
            Offset(w * 0.62, h * 0.5),
            stroke,
          );

      case MomentIcon.magnifier:
        canvas
          ..drawCircle(Offset(w * 0.42, h * 0.42), w * 0.26, stroke)
          ..drawLine(
            Offset(w * 0.6, h * 0.6),
            Offset(w * 0.86, h * 0.86),
            stroke,
          );

      case MomentIcon.house:
        final roof = Path()
          ..moveTo(w * 0.12, h * 0.5)
          ..lineTo(w * 0.5, h * 0.16)
          ..lineTo(w * 0.88, h * 0.5);
        canvas
          ..drawPath(roof, stroke)
          ..drawLine(
            Offset(w * 0.2, h * 0.46),
            Offset(w * 0.2, h * 0.86),
            stroke,
          )
          ..drawLine(
            Offset(w * 0.8, h * 0.46),
            Offset(w * 0.8, h * 0.86),
            stroke,
          )
          ..drawLine(
            Offset(w * 0.2, h * 0.86),
            Offset(w * 0.8, h * 0.86),
            stroke,
          )
          ..drawRect(
            Rect.fromLTWH(w * 0.44, h * 0.62, w * 0.12, h * 0.24),
            stroke,
          );

      case MomentIcon.laurel:
        canvas
          ..drawLine(
            Offset(w * 0.5, h * 0.1),
            Offset(w * 0.5, h * 0.62),
            stroke,
          )
          ..drawLine(
            Offset(w * 0.5, h * 0.1),
            Offset(w * 0.62, h * 0.24),
            stroke,
          )
          ..drawLine(
            Offset(w * 0.5, h * 0.1),
            Offset(w * 0.38, h * 0.24),
            stroke,
          )
          ..drawPath(
            Path()
              ..moveTo(w * 0.26, h * 0.9)
              ..quadraticBezierTo(w * 0.26, h * 0.66, w * 0.42, h * 0.54),
            stroke,
          )
          ..drawPath(
            Path()
              ..moveTo(w * 0.74, h * 0.9)
              ..quadraticBezierTo(w * 0.74, h * 0.66, w * 0.58, h * 0.54),
            stroke,
          )
          ..drawCircle(Offset(w * 0.26, h * 0.9), w * 0.06, fill)
          ..drawCircle(Offset(w * 0.74, h * 0.9), w * 0.06, fill);

      case MomentIcon.moon:
        canvas
          ..saveLayer(Rect.fromLTWH(0, 0, w, h), Paint())
          ..drawCircle(Offset(w * 0.46, h * 0.5), w * 0.36, fill)
          ..drawCircle(
            Offset(w * 0.6, h * 0.42),
            w * 0.32,
            Paint()..blendMode = BlendMode.clear,
          )
          ..restore();

      case MomentIcon.gavel:
        canvas
          ..save()
          ..translate(w * 0.36, h * 0.34)
          ..rotate(-0.6)
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: w * 0.34,
                height: h * 0.2,
              ),
              Radius.circular(w * 0.04),
            ),
            fill,
          )
          ..restore()
          ..drawLine(
            Offset(w * 0.42, h * 0.44),
            Offset(w * 0.72, h * 0.74),
            stroke,
          )
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(w * 0.16, h * 0.82, w * 0.5, h * 0.1),
              Radius.circular(w * 0.03),
            ),
            fill,
          );
    }
  }

  @override
  bool shouldRepaint(covariant _MomentIconPainter oldDelegate) =>
      oldDelegate.icon != icon || oldDelegate.color != color;
}
