import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';

/// The app's "what is this" — three facts a first-time host needs.
Future<void> showAboutSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _AboutSheet(),
  );
}

class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final count = GameCatalog.games.length;

    return SafeArea(
      top: false,
      // Scrollable so a short screen (or landscape) clips nothing: the sheet
      // sizes to its content but is capped at a fraction of the viewport.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Spacing.x7l,
          0,
          Spacing.x7l,
          Spacing.x7l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appTitle,
              style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                color: scheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              AppStrings.homeTagline,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.x6l),
            const _Fact(
              icon: Icons.wifi_off_rounded,
              title: 'Works fully offline',
              body: 'No account, no internet, nothing to sign up for.',
            ),
            const _Fact(
              icon: Icons.phone_android_rounded,
              title: 'One phone for the room',
              body: 'Pass it around or let the host run the show.',
            ),
            _Fact(
              icon: Icons.celebration_rounded,
              title: '$count games and counting',
              body: 'Bluffing, deduction, confessions and votes.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(AppColors.brandGradient);

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.x3l),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.tint(accent, scheme),
              borderRadius: BorderRadius.circular(AppRadii.xl),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.legible(accent, theme.brightness),
            ),
          ),
          const SizedBox(width: Spacing.x3l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: Spacing.xxs),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
