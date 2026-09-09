import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_icon.dart';

export 'package:house_party_offline/src/core/widgets/moment_icon.dart'
    show MomentGlyph, MomentIcon;

/// The emotional register of a [MomentCard] — controls composition, not just
/// color. Each mood is a genuinely different shape, not the same card with a
/// different icon swapped in.
enum MomentMood {
  /// A private, secretive pass-and-play reveal (a role, a secret word).
  /// Bottom-anchored text, an asymmetric "peeled corner".
  reveal,

  /// An explosive, shared end-of-game moment. Centered, radiating energy.
  celebration,

  /// A quieter "here's what happened" beat shown to the whole group.
  recap,
}

/// The app's one shared language for every reveal, win, and recap moment.
/// A faintly accent-tinted card with a hairline edge: the [gradient] only
/// supplies the accent (see [AppColors.accentOf]), which colors the glyph,
/// the eyebrow and the background decoration — the words stay in ink.
class MomentCard extends StatelessWidget {
  const MomentCard({
    required this.mood,
    required this.gradient,
    required this.headline,
    this.icon,
    this.eyebrow,
    this.kicker,
    this.subtitle,
    this.hint,
    this.footnote,
    super.key,
  });

  final MomentMood mood;
  final Gradient gradient;

  /// Custom-drawn mark for this moment (see [MomentIcon]).
  final MomentIcon? icon;

  /// Small label above the icon. Mainly used by [MomentMood.reveal] and
  /// [MomentMood.recap].
  final String? eyebrow;

  /// Small line immediately above the headline (e.g. "You are").
  final String? kicker;

  final String headline;

  /// Body-sized line below the headline.
  final String? subtitle;

  /// A pill-style callout below the main content (a hint, teammates).
  final String? hint;

  /// A small muted line at the very end (e.g. a remaining-players count).
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(gradient);
    final ink = AppColors.legible(accent, theme.brightness);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.tint(accent, scheme),
        borderRadius: BorderRadius.circular(AppRadii.x6l),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Stack(
        children: [
          ..._decorations(accent),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.x8l,
              vertical: Spacing.x7l,
            ),
            child: _content(theme, accent: accent, ink: ink),
          ),
        ],
      ),
    );
  }

  List<Widget> _decorations(Color accent) {
    switch (mood) {
      case MomentMood.reveal:
        return [_PeelCorner(accent: accent)];
      case MomentMood.celebration:
        return [_Rays(accent: accent)];
      case MomentMood.recap:
        return [_Stars(accent: accent)];
    }
  }

  Widget _content(
    ThemeData theme, {
    required Color accent,
    required Color ink,
  }) {
    final scheme = theme.colorScheme;

    switch (mood) {
      case MomentMood.reveal:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (eyebrow != null) Text(eyebrow!, style: _eyebrowStyle(ink)),
            if (icon != null) ...[
              const SizedBox(height: Spacing.x4l),
              MomentGlyph(icon: icon!, color: ink),
            ],
            const SizedBox(height: Spacing.x6l),
            if (kicker != null) ...[
              Text(
                kicker!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: Spacing.sm),
            ],
            Text(headline, style: _headlineStyle(32, scheme.onSurface)),
            if (subtitle != null) ...[
              const SizedBox(height: Spacing.md),
              Text(
                subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (hint != null) ...[
              const SizedBox(height: Spacing.x6l),
              _HintChip(text: hint!, accent: accent),
            ],
          ],
        );

      case MomentMood.celebration:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              MomentGlyph(icon: icon!, size: 52, color: ink),
              const SizedBox(height: Spacing.x4l),
            ],
            Text(
              headline,
              textAlign: TextAlign.center,
              style: _headlineStyle(28, scheme.onSurface),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        );

      case MomentMood.recap:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (eyebrow != null) Text(eyebrow!, style: _eyebrowStyle(ink)),
            if (icon != null) ...[
              const SizedBox(height: Spacing.x4l),
              MomentGlyph(icon: icon!, size: 38, color: ink),
            ],
            const SizedBox(height: Spacing.x6l),
            Container(width: 30, height: 1, color: scheme.outlineVariant),
            const SizedBox(height: Spacing.x4l),
            Text(headline, style: _headlineStyle(23, scheme.onSurface)),
            if (subtitle != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (footnote != null) ...[
              const SizedBox(height: Spacing.x4l),
              Text(
                footnote!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        );
    }
  }

  TextStyle _headlineStyle(double size, Color color) {
    return const TextStyle(fontFamily: 'Unbounded').copyWith(
      color: color,
      fontSize: size,
      height: 1.08,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle _eyebrowStyle(Color color) {
    return const TextStyle(fontFamily: 'Unbounded').copyWith(
      color: color,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x3l,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: scheme.onSurface,
        ),
      ),
    );
  }
}

/// A folded-paper corner — something being peeled back to reveal a secret.
class _PeelCorner extends StatelessWidget {
  const _PeelCorner({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: CustomPaint(
        size: const Size(84, 84),
        painter: _PeelCornerPainter(foldColor: accent.withValues(alpha: 0.2)),
      ),
    );
  }
}

class _PeelCornerPainter extends CustomPainter {
  _PeelCornerPainter({required this.foldColor});

  final Color foldColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fold = Path()
      ..moveTo(w, 0)
      ..lineTo(0, 0)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(fold, Paint()..color = foldColor);

    final crease = Path()
      ..moveTo(w, 0)
      ..lineTo(w * 0.45, 0)
      ..lineTo(w, h * 0.45)
      ..close();
    canvas.drawPath(
      crease,
      Paint()..color = Colors.black.withValues(alpha: 0.06),
    );
  }

  @override
  bool shouldRepaint(covariant _PeelCornerPainter oldDelegate) =>
      oldDelegate.foldColor != foldColor;
}

/// Rays bursting from the bottom-right corner — an explosive win moment.
class _Rays extends StatelessWidget {
  const _Rays({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -50,
      bottom: -50,
      child: CustomPaint(
        size: const Size(220, 220),
        painter: _RaysPainter(color: accent.withValues(alpha: 0.14)),
      ),
    );
  }
}

class _RaysPainter extends CustomPainter {
  const _RaysPainter({required this.color});

  final Color color;

  static const _angles = [0, 30, 60, 90, 120, 150];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.92;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    for (final deg in _angles) {
      final rad = deg * math.pi / 180;
      final end =
          center + Offset(math.cos(rad) * radius, math.sin(rad) * radius);
      canvas.drawLine(center, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RaysPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// A few faint stars — a quiet night-time recap.
class _Stars extends StatelessWidget {
  const _Stars({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Star(top: 24, right: 32, size: 6, color: accent, opacity: 0.5),
        _Star(top: 50, right: 60, size: 4, color: accent, opacity: 0.35),
        _Star(top: 74, right: 38, size: 5, color: accent, opacity: 0.42),
      ],
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({
    required this.top,
    required this.right,
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double top;
  final double right;
  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
