import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/entrance.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/prompt_deck.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';
import 'package:house_party_offline/src/custom_prompts/presentation/bloc/custom_prompts_bloc.dart';

/// The shared "Your prompts" editor: one section per deck in [spec], each
/// with its list, tap-to-edit, swipe-free delete, and an add field. Writes
/// through on every change.
class CustomPromptsPage extends StatelessWidget {
  const CustomPromptsPage({required this.spec, super.key});

  final PromptDeckSpec spec;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CustomPromptsBloc(getIt<CustomPromptsRepository>(), spec)
            ..add(const CustomPromptsStarted()),
      child: _PromptsView(spec: spec),
    );
  }
}

class _PromptsView extends StatelessWidget {
  const _PromptsView({required this.spec});

  final PromptDeckSpec spec;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your prompts')),
      body: SafeArea(
        top: false,
        child: BlocBuilder<CustomPromptsBloc, CustomPromptsState>(
          builder: (context, state) {
            return ListView(
              padding: AppPadding.page,
              children: [
                Entrance(
                  child: HeroBanner(
                    title: spec.gameTitle,
                    subtitle:
                        'Inside jokes, house rules, the thing that happened '
                        'last time — they go in the deck alongside the '
                        'bundled prompts.',
                    icon: Icons.edit_note_rounded,
                    gradient: spec.gradient,
                    compact: true,
                  ),
                ),
                const SizedBox(height: Spacing.x5l),
                for (var i = 0; i < spec.sections.length; i++) ...[
                  if (i > 0) const SizedBox(height: Spacing.x7l),
                  Entrance(
                    index: i + 1,
                    child: _DeckSection(
                      section: spec.sections[i],
                      prompts: state.promptsFor(spec.sections[i].deckId),
                      loaded: state.loaded,
                      accent: AppColors.accentOf(spec.gradient),
                    ),
                  ),
                ],
                const SizedBox(height: Spacing.x3l),
                Text(
                  "Turn them on or off per match from the game's setup.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DeckSection extends StatelessWidget {
  const _DeckSection({
    required this.section,
    required this.prompts,
    required this.loaded,
    required this.accent,
  });

  final PromptDeckSection section;
  final List<CustomPrompt> prompts;
  final bool loaded;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bloc = context.read<CustomPromptsBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(section.title, style: theme.textTheme.titleLarge),
            const SizedBox(width: Spacing.md),
            Text(
              '${prompts.length}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        if (loaded && prompts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.md),
            child: Text(
              'Nothing yet — add your first one below.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        for (final prompt in prompts)
          Card(
            key: ValueKey(prompt.id),
            child: ListTile(
              title: Text(prompt.text),
              onTap: () => _edit(context, bloc, prompt),
              trailing: IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => bloc.add(
                  CustomPromptRemoved(deckId: section.deckId, id: prompt.id),
                ),
              ),
            ),
          ),
        const SizedBox(height: Spacing.md),
        _AddRow(
          key: ValueKey('add-${section.deckId}'),
          hint: section.hint,
          onAdd: (text) =>
              bloc.add(CustomPromptAdded(deckId: section.deckId, text: text)),
        ),
      ],
    );
  }

  Future<void> _edit(
    BuildContext context,
    CustomPromptsBloc bloc,
    CustomPrompt prompt,
  ) async {
    final controller = TextEditingController(text: prompt.text);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit prompt'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          minLines: 1,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.trim().isEmpty) return;
    bloc.add(
      CustomPromptEdited(deckId: section.deckId, id: prompt.id, text: result),
    );
  }
}

/// The add field: type, then tap the button or press done.
class _AddRow extends StatefulWidget {
  const _AddRow({required this.hint, required this.onAdd, super.key});

  final String hint;
  final ValueChanged<String> onAdd;

  @override
  State<_AddRow> createState() => _AddRowState();
}

class _AddRowState extends State<_AddRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onAdd(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: widget.hint,
              contentPadding: AppPadding.section,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: Spacing.md),
        IconButton.filled(
          tooltip: 'Add prompt',
          onPressed: _submit,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
