import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_motion.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';

/// A tappable menu entry shaped like an admission ticket — a punched notch
/// on each edge and a perforation line separating the icon "stub" from the
/// body. Neutral surface with a hairline edge; the game's accent shows only
/// on the stub icon. Presses squash the card very slightly.
class TicketCard extends StatefulWidget {
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

  /// Only its first stop is used, as the accent (see [AppColors.accentOf]).
  final Gradient gradient;
  final String? trailingLabel;
  final bool enabled;

  static const _height = 96.0;
  static const _stubWidth = 92.0;
  static const _notchRadius = 11.0;
  static const double _cardRadius = AppRadii.x5l;

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = widget.enabled;
    final accent = AppColors.accentOf(widget.gradient);
    final iconColor = enabled
        ? AppColors.legible(accent, theme.brightness)
        : scheme.onSurfaceVariant;
    final iconFill = enabled
        ? AppColors.tint(accent, scheme)
        : scheme.surfaceContainerHigh;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: SizedBox(
          height: TicketCard._height,
          child: CustomPaint(
            painter: _TicketPainter(
              fill: scheme.surfaceContainerLow,
              edge: scheme.outlineVariant.withValues(alpha: 0.7),
            ),
            child: ClipPath(
              clipper: const _TicketClipper(),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: enabled ? widget.onTap : null,
                  onTapDown: enabled ? (_) => _setPressed(true) : null,
                  onTapUp: (_) => _setPressed(false),
                  onTapCancel: () => _setPressed(false),
                  child: Row(
                    children: [
                      SizedBox(
                        width: TicketCard._stubWidth,
                        child: Center(
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: iconFill,
                              borderRadius: BorderRadius.circular(
                                AppRadii.x2l,
                              ),
                            ),
                            child: Icon(
                              widget.icon,
                              size: 22,
                              color: iconColor,
                            ),
                          ),
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
                                      widget.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(
                                            fontFamily: 'Unbounded',
                                          ).copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: scheme.onSurface,
                                          ),
                                    ),
                                  ),
                                  if (widget.trailingLabel != null) ...[
                                    const SizedBox(width: Spacing.sm),
                                    _TrailingChip(text: widget.trailingLabel!),
                                  ],
                                ],
                              ),
                              const SizedBox(height: Spacing.xs),
                              Text(
                                widget.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
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
                            painter: _ArrowPainter(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// The ticket outline: a rounded rect with a true circular notch punched out
/// of each side.
Path _ticketPath(Size size) {
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

/// Paints the fill, the hairline edge along the notched outline (so the
/// border follows the notches instead of being cut off by them), and the
/// dashed perforation between the stub and the body.
class _TicketPainter extends CustomPainter {
  const _TicketPainter({required this.fill, required this.edge});

  final Color fill;
  final Color edge;

  static const _dash = 4.0;
  static const _gap = 4.0;
  static const _perforationInset = 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _ticketPath(size);
    final stroke = Paint()
      ..color = edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas
      ..drawPath(path, Paint()..color = fill)
      ..drawPath(path, stroke);

    const x = TicketCard._stubWidth;
    var y = _perforationInset;
    final end = size.height - _perforationInset;
    while (y < end) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, (y + _dash).clamp(0, end)),
        stroke,
      );
      y += _dash + _gap;
    }
  }

  @override
  bool shouldRepaint(covariant _TicketPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.edge != edge;
}

/// Clips the ink ripple to the ticket outline.
class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper();

  @override
  Path getClip(Size size) => _ticketPath(size);

  @override
  bool shouldReclip(covariant _TicketClipper oldClipper) => false;
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.36, size.height * 0.2)
      ..lineTo(size.width * 0.68, size.height * 0.5)
      ..lineTo(size.width * 0.36, size.height * 0.8);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}
