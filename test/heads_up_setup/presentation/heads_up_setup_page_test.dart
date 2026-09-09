import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up_setup/presentation/pages/heads_up_setup_page.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';

import '../../helpers/fake_roster_repository.dart';

class _FakePacksRepo implements ImposterPacksRepository {
  @override
  Future<List<ImposterPackEntity>> getPacks() async => const [
    ImposterPackEntity(
      id: 'animals',
      name: 'Animals',
      category: 'Animal',
      words: ['Owl', 'Cat'],
    ),
  ];

  @override
  Future<void> saveCustomPack(ImposterPackEntity pack) async {}

  @override
  Future<void> deleteCustomPack(String id) async {}
}

/// Exercises the real, wired-up [HeadsUpSetupPage] end to end — roster,
/// pack chips, both options, and the Start button.
void main() {
  setUp(() {
    getIt
      ..registerSingleton<RosterRepository>(FakeRosterRepository())
      ..registerFactory<GetImposterPacksUseCase>(
        () => GetImposterPacksUseCase(_FakePacksRepo()),
      );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders roster, packs and options with Start enabled', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HeadsUpSetupPage()));
    await tester.pumpAndSettle();

    expect(find.text('Players'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(HeadsUpConfig.minPlayers));
    expect(find.text('Word packs'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Animals'), findsOneWidget);
    expect(find.text('2 words in the deck'), findsOneWidget);
    expect(find.text('Turn length'), findsOneWidget);
    expect(find.text('Turns each'), findsOneWidget);

    final startButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Start game'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(startButton.onPressed, isNotNull);
  });

  testWidgets('deselecting every pack disables Start', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HeadsUpSetupPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Animals'));
    await tester.pumpAndSettle();

    expect(find.text('Pick at least one pack.'), findsOneWidget);
    final startButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Start game'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(startButton.onPressed, isNull);
  });
}
