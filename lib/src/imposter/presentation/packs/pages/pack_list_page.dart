import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../domain/entities/word_pack.dart';
import '../../../domain/repositories/word_pack_repository.dart';
import '../pack_list_cubit.dart';

/// Lists all available word packs. Custom packs can be edited or deleted;
/// bundled packs are read-only.
class PackListPage extends StatelessWidget {
  const PackListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PackListCubit(sl<WordPackRepository>())..load(),
      child: const _PackListView(),
    );
  }
}

class _PackListView extends StatelessWidget {
  const _PackListView();

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Word Packs')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('New pack'),
      ),
      body: BlocBuilder<PackListCubit, PackListState>(
        builder: (context, state) {
          return switch (state) {
            PackListLoading() =>
              const Center(child: CircularProgressIndicator()),
            PackListError(:final message) => _ErrorView(
              message: message,
              onRetry: () => context.read<PackListCubit>().load(),
            ),
            PackListLoaded(:final packs) => _PackList(packs: packs),
          };
        },
      ),
    );
  }
}

/// Opens the editor (create or edit) and reloads the list if it saved.
Future<void> _openEditor(BuildContext context, {WordPack? pack}) async {
  final cubit = context.read<PackListCubit>();
  final saved = await context.push<bool>(Routes.imposterPackEditor, extra: pack);
  if (saved ?? false) await cubit.load();
}

class _PackList extends StatelessWidget {
  const _PackList({required this.packs});

  final List<WordPack> packs;

  @override
  Widget build(BuildContext context) {
    if (packs.isEmpty) {
      return const Center(child: Text('No word packs yet.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: packs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) => _PackTile(pack: packs[i]),
    );
  }
}

class _PackTile extends StatelessWidget {
  const _PackTile({required this.pack});

  final WordPack pack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: pack.isCustom ? () => _openEditor(context, pack: pack) : null,
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Text('${pack.words.length}'),
        ),
        title: Text(pack.name),
        subtitle: Text('${pack.category} • ${pack.words.length} words'),
        trailing: pack.isCustom
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Chip(
                    label: Text('Custom'),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(context, pack),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WordPack pack) async {
    final cubit = context.read<PackListCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${pack.name}"?'),
        content: const Text('This custom pack will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok ?? false) await cubit.deletePack(pack.id);
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
