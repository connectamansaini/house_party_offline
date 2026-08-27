import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_bloc.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_event.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_state.dart';

/// A caught imposter's one chance to guess the secret word and steal the win.
class ImposterGuessingView extends StatefulWidget {
  const ImposterGuessingView({required this.state, super.key});

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
    context.read<GameBloc>().add(
      ImposterGuessSubmitted(_controller.text.trim()),
    );
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
          MomentCard(
            mood: MomentMood.recap,
            gradient: AppColors.imposterGradient,
            icon: MomentIcon.mask,
            eyebrow: 'Caught',
            headline: 'Caught!',
            subtitle: '${widget.state.guesser.name} was the imposter.',
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
