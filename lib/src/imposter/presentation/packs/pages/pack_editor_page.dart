import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../domain/entities/word_pack.dart';
import '../../../domain/repositories/word_pack_repository.dart';
import '../pack_editor_cubit.dart';

/// Create or edit a custom word pack. Pass [pack] to edit, or null to create.
class PackEditorPage extends StatelessWidget {
  const PackEditorPage({super.key, this.pack});

  final WordPack? pack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PackEditorCubit(sl<WordPackRepository>())..start(pack),
      child: const _EditorView(),
    );
  }
}

class _EditorView extends StatelessWidget {
  const _EditorView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackEditorCubit, PackEditorState>(
      listenWhen: (prev, curr) => curr.status == PackEditorStatus.saved,
      listener: (context, state) => Navigator.of(context).pop(true),
      child: BlocBuilder<PackEditorCubit, PackEditorState>(
        builder: (context, state) {
          final cubit = context.read<PackEditorCubit>();
          return GradientScaffold(
            appBar: AppBar(
              title: Text(state.isEditing ? 'Edit pack' : 'New pack'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  initialValue: state.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Pack name',
                    hintText: 'e.g. Movie Villains',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: cubit.setName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.category,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Category (imposter hint)',
                    hintText: 'e.g. Villain',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: cubit.setCategory,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Words', style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      '${state.cleanedWords.length} added',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final word in state.words)
                  _WordRow(
                    key: ValueKey(word.id),
                    initialText: word.text,
                    onChanged: (text) => cubit.updateWord(word.id, text),
                    onRemove: () => cubit.removeWord(word.id),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: cubit.addWord,
                  icon: const Icon(Icons.add),
                  label: const Text('Add word'),
                ),
                const SizedBox(height: 8),
                if (state.cleanedWords.length < PackEditorState.minWords)
                  Text(
                    'Add at least ${PackEditorState.minWords} words.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                8 + MediaQuery.of(context).padding.bottom,
              ),
              child: FilledButton(
                onPressed: state.canSave && state.status != PackEditorStatus.saving
                    ? cubit.save
                    : null,
                child: state.status == PackEditorStatus.saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save pack'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WordRow extends StatefulWidget {
  const _WordRow({
    super.key,
    required this.initialText,
    required this.onChanged,
    required this.onRemove,
  });

  final String initialText;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  @override
  State<_WordRow> createState() => _WordRowState();
}

class _WordRowState extends State<_WordRow> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          IconButton(
            tooltip: 'Remove',
            onPressed: widget.onRemove,
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ],
      ),
    );
  }
}
