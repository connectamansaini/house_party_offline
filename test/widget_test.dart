import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/home/presentation/home_page.dart';

void main() {
  testWidgets('Home hub shows the Imposter game card', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('House Party'), findsOneWidget);
    expect(find.text('Imposter'), findsOneWidget);
    expect(find.text('Mafia'), findsOneWidget);
  });
}
