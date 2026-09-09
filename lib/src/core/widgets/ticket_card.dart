import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/pressable.dart';

/// A tappable menu entry shaped like an admission ticket — a punched notch
/// on each edge and a perforation line separating the icon "stub" from the
/// body. Neutral surface with a hairline edge; the game's accent shows only
/// on the stub icon. Presses squash the card very slightly.
///
/// The ticket outline is a [ShapeBorder], so a single [Material] fills it,
/// strokes it and clips the ink ripple to it — no separate painter, clipper
/// or opacity layer.
class TicketCard extends StatelessWidget {
  const TicketCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.onTap,
    this.gradient = AppColors.brandGradient,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  /// Only its first stop is used, as the accent (see [AppColors.accentOf]).
  final Gradient gradient;

  static const _height = 96.0;
  static const _stubWidth = 92.0;
  static const _notchRadius = 11.0;
  static const double _cardRadius = AppRadii.x5l;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(gradient);
    final shape = _TicketBorder(
      edge: scheme.outlineVariant.withValues(alpha: 0.7),
    );

    return Pressable(
      child: SizedBox(
        height: _height,
        child: Material(
          color: scheme.surfaceContainerLow,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            customBorder: shape,
            child: Row(
              children: [
                SizedBox(
                  width: _stubWidth,
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.tint(accent, scheme),
                        borderRadius: BorderRadius.circular(AppRadii.x2l),
                      ),
                      child: Icon(
                        icon,
                        size: 22,
                        color: AppColors.legible(accent, theme.brightness),
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
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Unbounded')
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: scheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          subtitle,
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
                Padding(
                  padding: const EdgeInsets.only(right: Spacing.x3l),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The ticket outline: a rounded rect with a true circular notch punched out
/// of each side, plus a dashed perforation between stub and body. As a
/// [ShapeBorder] it doubles as the fill region, the clip and the edge.
class _TicketBorder extends ShapeBorder {
  const _TicketBorder({required this.edge});

  final Color edge;

  static const _dash = 4.0;
  static const _gap = 4.0;
  static const _perforationInset = 16.0;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final base = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(TicketCard._cardRadius),
        ),
      );
    final leftNotch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(rect.left, rect.center.dy),
          radius: TicketCard._notchRadius,
        ),
      );
    final rightNotch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(rect.right, rect.center.dy),
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
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final stroke = Paint()
      ..color = edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(getOuterPath(rect), stroke);

    final x = rect.left + TicketCard._stubWidth;
    final end = rect.bottom - _perforationInset;
    var y = rect.top + _perforationInset;
    while (y < end) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, (y + _dash).clamp(y, end)),
        stroke,
      );
      y += _dash + _gap;
    }
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  bool operator ==(Object other) =>
      other is _TicketBorder && other.edge == edge;

  @override
  int get hashCode => edge.hashCode;
}
