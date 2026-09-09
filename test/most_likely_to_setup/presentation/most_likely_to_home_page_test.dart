import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/pages/most_likely_to_home_page.dart';

/// Exercises a game landing page end to end — the hero, both ticket entries,
/// and navigation off a ticket. This is also the only place [TicketCard] is
/// rendered under test now that the hub uses grid cards.
void main() {
  Future<void> pumpLanding(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.mostLikelyTo,
      routes: [
        GoRoute(
          path: AppRoutes.mostLikelyTo,
          builder: (context, state) => const MostLikelyToHomePage(),
        ),
        GoRoute(
          path: AppRoutes.mostLikelyToSetup,
          builder: (context, state) => const Text('setup stub'),
        ),
        GoRoute(
          path: AppRoutes.mostLikelyToRules,
          builder: (context, state) => const Text('rules stub'),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the hero and all three ticket entries', (tester) async {
    await pumpLanding(tester);

    expect(find.text('Most Likely To'), findsOneWidget);
    expect(find.byType(TicketCard), findsNWidgets(3));
    expect(find.text('New game'), findsOneWidget);
    expect(find.text('Your prompts'), findsOneWidget);
    expect(find.text('How to play'), findsOneWidget);
  });

  testWidgets('tapping a ticket navigates', (tester) async {
    await pumpLanding(tester);

    await tester.tap(find.text('How to play'));
    await tester.pumpAndSettle();

    expect(find.text('rules stub'), findsOneWidget);
  });
}
