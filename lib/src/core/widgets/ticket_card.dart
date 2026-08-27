import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';

/// A tappable menu entry shaped like an admission ticket — a punched notch
/// on each edge and a torn-perforation line separating the icon "stub" from
/// the body — instead of the generic icon-badge-plus-chevron row used
/// throughout most apps.
class TicketCard extends StatelessWidget {
  const TicketCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.onTap,
    this.gradient = AppColors.brandGradient,
    this.trailingLabel,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Gradient gradient;
  final String? trailingLabel;
  final bool enabled;

  static const _height = 104.0;
  static const _stubWidth = 96.0;
  static const _notchRadius = 12.0;
  static const double _cardRadius = AppRadii.x5l;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = enabled ? AppColors.onGradient : scheme.onSurfaceVariant;
    final fill = enabled
        ? gradient
        : LinearGradient(
            colors: [
              scheme.surfaceContainerHighest,
              scheme.surfaceContainerHighest,
            ],
          );

    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: gradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 9),
                  ),
                ]
              : null,
        ),
        child: ClipPath(
          clipper: const _TicketClipper(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onTap : null,
              child: Container(
                height: _height,
                decoration: BoxDecoration(gradient: fill),
                child: Row(
                  children: [
                    SizedBox(
                      width: _stubWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(icon, size: 30, color: fg),
                          Positioned(
                            right: 0,
                            top: 18,
                            bottom: 18,
                            child: CustomPaint(
                              size: const Size(1, double.infinity),
                              painter: _DashedLinePainter(
                                color: fg.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.x5l,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Unbounded',
                                    ).copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      color: fg,
                                    ),
                                  ),
                                ),
                                if (trailingLabel != null) ...[
                                  const SizedBox(width: Spacing.sm),
                                  _TrailingChip(text: trailingLabel!),
                                ],
                              ],
                            ),
                            const SizedBox(height: Spacing.xxs),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: fg.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (enabled)
                      Padding(
                        padding: const EdgeInsets.only(right: Spacing.x5l),
                        child: CustomPaint(
                          size: const Size(18, 18),
                          painter: _ArrowPainter(color: fg),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrailingChip extends StatelessWidget {
  const _TrailingChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.onGradient,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Cuts two true circular notches out of a rounded rect — a real hole
/// showing whatever sits behind the card, not a color-matched overlay.
class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper();

  @override
  Path getClip(Size size) {
    final base = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(TicketCard._cardRadius),
        ),
      );
    final leftNotch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(0, size.height / 2),
          radius: TicketCard._notchRadius,
        ),
      );
    final rightNotch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, size.height / 2),
          radius: TicketCard._notchRadius,
        ),
      );
    return Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, base, leftNotch),
      rightNotch,
    );
  }

  @override
  bool shouldReclip(covariant _TicketClipper oldClipper) => false;
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  static const _dash = 4.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4;
    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(0, y),
        Offset(0, (y + _dash).clamp(0, size.height)),
        paint,
      );
      y += _dash + _gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.32, size.height * 0.15)
      ..lineTo(size.width * 0.72, size.height * 0.5)
      ..lineTo(size.width * 0.32, size.height * 0.85);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}
