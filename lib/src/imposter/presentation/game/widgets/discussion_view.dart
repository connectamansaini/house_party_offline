import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game_bloc.dart';
import '../game_event.dart';
import '../game_state.dart';

/// The timed discussion phase: a countdown ring that shifts colour as time
/// runs low, plus a skip-to-vote.
class DiscussionView extends StatelessWidget {
  const DiscussionView({super.key, required this.state});

  final Discussion state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final total = state.session.config.discussionTime.inSeconds;
    final remaining = state.remaining.inSeconds;
    final progress = total == 0 ? 0.0 : remaining / total;

    // Green → amber → red as the clock winds down.
    final ringColor = Color.lerp(
      scheme.error,
      const Color(0xFF00C2A8),
      progress.clamp(0.0, 1.0),
    )!;
    final lowTime = remaining <= 10 && remaining > 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text('Discuss!', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Take turns giving one-word clues. Sniff out the imposter.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: progress, end: progress),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, value, _) => CircularProgressIndicator(
                          value: value,
                          strokeWidth: 14,
                          strokeCap: StrokeCap.round,
                          color: ringColor,
                          backgroundColor: scheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _format(state.remaining),
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: lowTime ? scheme.error : scheme.onSurface,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          'remaining',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () =>
                context.read<GameBloc>().add(const DiscussionSkipped()),
            icon: const Icon(Icons.how_to_vote_rounded),
            label: const Text('Skip to vote'),
          ),
        ],
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
