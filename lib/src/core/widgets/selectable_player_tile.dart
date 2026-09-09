import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_motion.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';

/// A tappable player row used everywhere someone picks a target — voting,
/// night actions, the day lynch. Selection reads as an accent hairline, a
/// filled avatar and a checkmark badge, all animated in, so the row never
/// jumps and the name stays legible in both states.
class SelectablePlayerTile extends StatelessWidget {
  const SelectablePlayerTile({
    required this.name,
    required this.selected,
    required this.onTap,
    super.key,
    this.accentGradient = AppColors.brandGradient,
    this.trailing,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  /// Source of the accent for the ring and the selected avatar fill (only
  /// its first stop is used — see [AppColors.accentOf]). Defaults to the
  /// brand; a screen can pass a contextual one (e.g. the mafia gradient for
  /// a kill-target picker).
  final Gradient accentGradient;

  /// Optional content after the name — e.g. a remaining-lives indicator.
  final Widget? trailing;

  static const _avatarSize = 44.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(accentGradient);
    final radius = BorderRadius.circular(AppRadii.x3l);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.curve,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.x3l,
            vertical: Spacing.lg,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.tint(accent, scheme)
                : scheme.surfaceContainerLow,
            borderRadius: radius,
            border: Border.all(
              color: selected
                  ? accent
                  : scheme.outlineVariant.withValues(alpha: 0.7),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              _Avatar(name: name, selected: selected, accent: accent),
              const SizedBox(width: Spacing.x3l),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: AppMotion.fast,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: scheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  child: Text(name),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.selected,
    required this.accent,
  });

  final String name;
  final bool selected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return SizedBox(
      width: SelectablePlayerTile._avatarSize,
      height: SelectablePlayerTile._avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.curve,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? accent : scheme.surfaceContainerHighest,
            ),
            alignment: Alignment.center,
            child: AnimatedDefaultTextStyle(
              duration: AppMotion.fast,
              style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                color: selected ? Colors.white : scheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              child: Text(initial),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: AnimatedScale(
              scale: selected ? 1 : 0,
              duration: AppMotion.fast,
              curve: AppMotion.curve,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent,
                  border: Border.all(color: scheme.surface, width: 2),
                ),
                child: const CustomPaint(painter: _CheckPainter()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.16, size.height * 0.52)
      ..lineTo(size.width * 0.4, size.height * 0.76)
      ..lineTo(size.width * 0.84, size.height * 0.24);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) => false;
}
