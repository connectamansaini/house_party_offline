import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';

/// A tappable player row used everywhere someone picks a target — voting,
/// night actions, the day lynch. Selection reads as a gradient ring and a
/// checkmark badge on the avatar, not a flat color flood across the whole
/// row, so the player's name stays legible in both states.
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

  /// Gradient used for the ring and the selected avatar fill. Defaults to
  /// the brand gradient; a screen can pass a contextual one (e.g. the mafia
  /// gradient for a kill-target picker).
  final Gradient accentGradient;

  /// Optional content after the name — e.g. a remaining-lives indicator.
  final Widget? trailing;

  static const _avatarSize = 48.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final surface = scheme.surfaceContainerHigh;
    const ringWidth = 2.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.x3l),
        child: Container(
          padding: EdgeInsets.all(selected ? ringWidth : 0),
          decoration: BoxDecoration(
            gradient: selected ? accentGradient : null,
            borderRadius: BorderRadius.circular(AppRadii.x3l),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: selected ? Spacing.x3l : Spacing.x4l,
              vertical: selected ? Spacing.md : Spacing.lg,
            ),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(
                AppRadii.x3l - (selected ? ringWidth : 0),
              ),
            ),
            child: Row(
              children: [
                _Avatar(
                  name: name,
                  selected: selected,
                  gradient: accentGradient,
                ),
                const SizedBox(width: Spacing.x3l),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : null,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
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
    required this.gradient,
  });

  final String name;
  final bool selected;
  final Gradient gradient;

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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected ? gradient : AppColors.civilianGradient,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                color: AppColors.onGradient,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          if (selected)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: gradient,
                  border: Border.all(
                    color: scheme.surfaceContainerHigh,
                    width: 2,
                  ),
                ),
                child: const CustomPaint(painter: _CheckPainter()),
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
        ..color = AppColors.onGradient
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) => false;
}
