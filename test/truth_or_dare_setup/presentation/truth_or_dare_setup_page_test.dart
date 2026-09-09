import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare_setup/presentation/pages/truth_or_dare_setup_page.dart';
import '../../helpers/fake_custom_prompts_repository.dart';
import '../../helpers/fake_roster_repository.dart';

/// Exercises the real, wired-up [TruthOrDareSetupPage] end to end — the
/// roster, both options, and the Start button.
void main() {
  setUp(() {
    getIt
      ..registerSingleton<RosterRepository>(FakeRosterRepository())
      ..registerSingleton<CustomPromptsRepository>(
        FakeCustomPromptsRepository(),
      );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'renders the roster, rounds and spice level, with Start enabled',
    (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: TruthOrDareSetupPage()));
      await tester.pumpAndSettle();

      expect(find.text('Players'), findsOneWidget);
      expect(
        find.byType(TextField),
        findsNWidgets(TruthOrDareConfig.minPlayers),
      );
      expect(find.text('Rounds'), findsOneWidget);
      expect(find.text('Spice level'), findsOneWidget);
      expect(find.text('Mild'), findsOneWidget);
      expect(find.text('Spicy'), findsOneWidget);

      final startButton = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Start game'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(startButton.onPressed, isNotNull);
    },
  );

  testWidgets('tapping Spicy selects it', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TruthOrDareSetupPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Spicy'));
    await tester.pumpAndSettle();

    final segmented = tester.widget<SegmentedButton<TruthOrDareLevel>>(
      find.byType(SegmentedButton<TruthOrDareLevel>),
    );
    expect(segmented.selected, {TruthOrDareLevel.spicy});
  });
}
