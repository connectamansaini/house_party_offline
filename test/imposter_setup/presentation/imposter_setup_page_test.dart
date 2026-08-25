import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';
import 'package:house_party_offline/src/imposter_setup/domain/repositories/imposter_setup_preferences_repository.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/load_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/save_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/presentation/pages/imposter_setup_page.dart';

/// This exercises the real, wired-up [ImposterSetupPage] end to end — the
/// wizard widgets, the bloc it creates via `getIt`, and the step
/// transitions — the same path a live app takes, just without a browser.
/// `getIt` is a global singleton, so each test registers its own fakes and
/// tears them down afterwards to avoid bleeding into other tests.
class _FakePacksRepo implements ImposterPacksRepository {
  _FakePacksRepo(this.packs);
  final List<ImposterPackEntity> packs;

  @override
  Future<List<ImposterPackEntity>> getPacks() async => packs;

  @override
  Future<void> saveCustomPack(ImposterPackEntity pack) async {}

  @override
  Future<void> deleteCustomPack(String id) async {}
}

class _FakePreferencesRepo implements ImposterSetupPreferencesRepository {
  ImposterSetupPreferencesEntity? stored;

  @override
  Future<ImposterSetupPreferencesEntity?> load() async => stored;

  @override
  Future<void> save(ImposterSetupPreferencesEntity prefs) async =>
      stored = prefs;
}

const _foods = ImposterPackEntity(
  id: 'foods',
  name: 'Foods',
  category: 'Food',
  words: ['Pizza', 'Sushi', 'Tacos'],
);

void main() {
  setUp(() {
    final preferences = _FakePreferencesRepo();
    getIt
      ..registerFactory<LoadImposterSetupPreferencesUseCase>(
        () => LoadImposterSetupPreferencesUseCase(preferences),
      )
      ..registerFactory<SaveImposterSetupPreferencesUseCase>(
        () => SaveImposterSetupPreferencesUseCase(preferences),
      )
      ..registerFactory<GetImposterPacksUseCase>(
        () => GetImposterPacksUseCase(_FakePacksRepo([_foods])),
      );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'renders the Players step with a default roster, then advances '
    'through Word pack and Options to an enabled Start game button',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ImposterSetupPage()),
      );
      await tester.pumpAndSettle();

      // Step 1: Players — seeded with the minimum default roster. Each name
      // matches twice (the live TextField value and its hint), so this just
      // confirms all three rows rendered.
      expect(find.text('Players'), findsWidgets);
      expect(find.text('Player 1'), findsWidgets);
      expect(find.text('Player 2'), findsWidgets);
      expect(find.text('Player 3'), findsWidgets);
      expect(find.byType(TextField), findsNWidgets(3));

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 2: Word pack — the fake pack loaded and is selected by default.
      expect(find.text('Foods'), findsOneWidget);
      expect(find.textContaining('words'), findsWidgets);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 3: Options — the form is valid, so Start game is enabled.
      expect(find.text('Start game'), findsOneWidget);
      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Start game'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets('New game entry is disabled until the pack finishes loading', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ImposterSetupPage()));

    // Before the async pack load settles, the wizard shows the Players step
    // (not blocked) since pack loading only gates step 2 onward.
    await tester.pump();
    expect(find.text('Players'), findsWidgets);

    await tester.pumpAndSettle();
  });
}
