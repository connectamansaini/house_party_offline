import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../game_bloc.dart';
import '../game_event.dart';
import '../game_state.dart';

/// A caught imposter's one chance to guess the secret word and steal the win.
class ImposterGuessingView extends StatefulWidget {
  const ImposterGuessingView({super.key, required this.state});

  final ImposterGuessing state;

  @override
  State<ImposterGuessingView> createState() => _ImposterGuessingViewState();
}

class _ImposterGuessingViewState extends State<ImposterGuessingView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    context
        .read<GameBloc>()
        .add(ImposterGuessSubmitted(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = _controller.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: AppColors.imposterGradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.imposterGradient.colors.first
                      .withValues(alpha: 0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.theater_comedy_rounded,
                    size: 56, color: AppColors.onGradient),
                const SizedBox(height: 12),
                Text(
                  'Caught!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.onGradient,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.state.guesser.name} was in the imposter.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.onGradient.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Guess the secret word to steal the win.',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            style: theme.textTheme.titleLarge,
            decoration: const InputDecoration(
              hintText: 'Your guess',
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (_controller.text.trim().isNotEmpty) _submit();
            },
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: hasText ? _submit : null,
            icon: const Icon(Icons.bolt_rounded),
            label: const Text('Submit guess'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () =>
                context.read<GameBloc>().add(const ImposterGuessSubmitted('')),
            child: const Text('Give up'),
          ),
        ],
      ),
    );
  }
}
