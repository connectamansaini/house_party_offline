import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/save_custom_imposter_pack_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/presentation/editor/imposter_pack_editor_bloc.dart';

class ImposterPackEditorPage extends StatelessWidget {
  const ImposterPackEditorPage({super.key, this.pack});

  final ImposterPackEntity? pack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ImposterPackEditorBloc(getIt<SaveCustomImposterPackUseCase>())
            ..add(ImposterPackEditorStarted(pack)),
      child: const _ImposterPackEditorView(),
    );
  }
}

class _ImposterPackEditorView extends StatelessWidget {
  const _ImposterPackEditorView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImposterPackEditorBloc, ImposterPackEditorState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == ImposterPackEditorStatus.saved,
      listener: (context, state) => Navigator.of(context).pop(true),
      child: BlocBuilder<ImposterPackEditorBloc, ImposterPackEditorState>(
        builder: (context, state) {
          final bloc = context.read<ImposterPackEditorBloc>();

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
                  onChanged: (value) {
                    bloc.add(ImposterPackNameChanged(value));
                  },
                ),
                const SizedBox(height: Spacing.xl),
                TextFormField(
                  initialValue: state.category,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Category (imposter hint)',
                    hintText: 'e.g. Villain',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    bloc.add(ImposterPackCategoryChanged(value));
                  },
                ),
                const SizedBox(height: Spacing.x7l),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Words',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${state.cleanedWords.length} added',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                for (final word in state.words)
                  _WordRow(
                    key: ValueKey(word.id),
                    initialText: word.text,
                    onChanged: (value) {
                      bloc.add(
                        ImposterPackWordChanged(id: word.id, value: value),
                      );
                    },
                    onRemove: () {
                      bloc.add(ImposterPackWordRemoved(word.id));
                    },
                  ),
                const SizedBox(height: Spacing.md),
                OutlinedButton.icon(
                  onPressed: () => bloc.add(const ImposterPackWordAdded()),
                  icon: const Icon(Icons.add),
                  label: const Text('Add word'),
                ),
                const SizedBox(height: Spacing.md),
                if (state.cleanedWords.length <
                    ImposterPackEditorState.minWords)
                  Text(
                    'Add at least ${ImposterPackEditorState.minWords} words.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (state.status == ImposterPackEditorStatus.failure &&
                    state.errorMessage != null) ...[
                  const SizedBox(height: Spacing.xl),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
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
                onPressed:
                    state.canSave &&
                        state.status != ImposterPackEditorStatus.saving
                    ? () => bloc.add(const ImposterPackSaveRequested())
                    : null,
                child: state.status == ImposterPackEditorStatus.saving
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
    required this.initialText,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final String initialText;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  @override
  State<_WordRow> createState() => _WordRowState();
}

class _WordRowState extends State<_WordRow> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
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
