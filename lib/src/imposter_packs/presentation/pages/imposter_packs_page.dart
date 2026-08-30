import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/core/widgets/loader.dart';
import 'package:house_party_offline/core/widgets/page_failure_view.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
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
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, Spacing.md, 20, 0),
              child: HeroBanner(
                title: 'Word Packs',
                subtitle: 'Bundled packs, plus any you’ve created',
                icon: Icons.style_outlined,
                gradient: AppColors.civilianGradient,
                compact: true,
              ),
            ),
            Expanded(
              child: BlocBuilder<ImposterPacksBloc, ImposterPacksState>(
                builder: (context, state) {
                  if (state.status == ImposterPacksStatus.failure) {
                    return PageFailureView(
                      message:
                          state.errorMessage ?? 'Could not load word packs.',
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
            ),
          ],
        ),
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
      padding: const EdgeInsets.fromLTRB(20, Spacing.x6l, 20, 88),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final gradient = pack.isCustom
        ? AppColors.brandGradient
        : AppColors.civilianGradient;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.x3l),
        onTap: pack.isCustom ? () => _openEditor(context, pack: pack) : null,
        child: Padding(
          padding: AppPadding.allLg,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${pack.words.length}',
                  style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                    color: AppColors.onGradient,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.x3l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pack.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        if (pack.isCustom) ...[
                          const SizedBox(width: Spacing.sm),
                          const _CustomBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      '${pack.category} • ${pack.words.length} words',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (pack.isCustom)
                IconButton(
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
        ),
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

    if (!context.mounted || !(approved ?? false)) return;
    context.read<ImposterPacksBloc>().add(
      ImposterPackDeletedRequested(pack.id),
    );
  }
}

class _CustomBadge extends StatelessWidget {
  const _CustomBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Text(
        'Custom',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onTertiaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
