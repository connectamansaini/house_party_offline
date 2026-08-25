import 'package:flutter/material.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';

/// A selectable player row (avatar + name) used by night actions and the day
/// vote.
class MafiaPlayerTile extends StatelessWidget {
  const MafiaPlayerTile({
    required this.player,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final MafiaPlayer player;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: selected
                      ? scheme.onPrimary.withValues(alpha: 0.2)
                      : scheme.primaryContainer,
                  foregroundColor: selected
                      ? scheme.onPrimary
                      : scheme.onPrimaryContainer,
                  child: Text(
                    player.name.trim().isEmpty
                        ? '?'
                        : player.name.trim()[0].toUpperCase(),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    player.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: selected ? scheme.onPrimary : scheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
