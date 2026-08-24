import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/core/widgets/loader.dart';
import 'package:house_party_offline/core/widgets/page_failure_view.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/status/imposter_packs_status.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/delete_custom_imposter_pack_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/presentation/bloc/imposter_packs_bloc.dart';

class ImposterPacksPage extends StatelessWidget {
  const ImposterPacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImposterPacksBloc(
        getIt<GetImposterPacksUseCase>(),
        getIt<DeleteCustomImposterPackUseCase>(),
      )..add(const ImposterPacksStarted()),
      child: const _ImposterPacksView(),
    );
  }
}

class _ImposterPacksView extends StatelessWidget {
  const _ImposterPacksView();

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Word Packs')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('New pack'),
      ),
      body: BlocBuilder<ImposterPacksBloc, ImposterPacksState>(
        builder: (context, state) {
          if (state.status == ImposterPacksStatus.failure) {
            return PageFailureView(
              message: state.errorMessage ?? 'Could not load word packs.',
              onRetry: () {
                context.read<ImposterPacksBloc>().add(
                  const ImposterPacksRefreshRequested(),
                );
              },
            );
          }

          if (state.status == ImposterPacksStatus.empty) {
            return const Center(child: Text('No word packs yet.'));
          }

          if (state.status == ImposterPacksStatus.success) {
            return _PackList(packs: state.packs);
          }

          return const Loader(label: 'Loading word packs...');
        },
      ),
    );
  }
}

Future<void> _openEditor(
  BuildContext context, {
  ImposterPackEntity? pack,
}) async {
  final bloc = context.read<ImposterPacksBloc>();
  final saved = await context.push<bool>(
    AppRoutes.imposterPackEditor,
    extra: pack,
  );
  if (saved ?? false) {
    bloc.add(const ImposterPacksRefreshRequested());
  }
}

class _PackList extends StatelessWidget {
  const _PackList({required this.packs});

  final List<ImposterPackEntity> packs;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: packs.length,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
      itemBuilder: (context, i) => _PackTile(pack: packs[i]),
    );
  }
}

class _PackTile extends StatelessWidget {
  const _PackTile({required this.pack});

  final ImposterPackEntity pack;

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
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final approved = await showDialog<bool>(
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

    if (approved ?? false) {
      context.read<ImposterPacksBloc>().add(
        ImposterPackDeletedRequested(pack.id),
      );
    }
  }
}
