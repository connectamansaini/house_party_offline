import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/home/presentation/home_page.dart';

void main() {
  testWidgets('Home hub shows the Imposter game card', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('House Party'), findsOneWidget);
    expect(find.text('Imposter'), findsOneWidget);
    expect(find.text('Mafia'), findsOneWidget);
    expect(find.text('Never Have I Ever'), findsOneWidget);

    // The fourth card sits below the test viewport, and the hub's ListView
    // is lazy, so it isn't built until scrolled into view.
    await tester.dragUntilVisible(
      find.text('Most Likely To'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    expect(find.text('Most Likely To'), findsOneWidget);
  });
}
