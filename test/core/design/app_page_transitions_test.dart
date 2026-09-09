import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/themes/app_theme.dart';
import 'package:house_party_offline/core/design/app_page_transitions.dart';

/// Sends one message on the channel the Android embedding uses to report a
/// system back gesture in progress.
Future<void> backGesture(
  WidgetTester tester,
  String method, [
  Map<String, Object?>? args,
]) async {
  final message = const StandardMethodCodec().encodeMethodCall(
    MethodCall(method, args),
  );
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/backgesture',
    message,
    (_) {},
  );
  await tester.pump();
}

void main() {
  Future<void> pumpTwoPages(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(body: Text('page b')),
                ),
              ),
              child: const Text('push'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('push'));
    await tester.pumpAndSettle();
    expect(find.text('page b'), findsOneWidget);
  }

  testWidgets('pushes and pops use the fade-and-rise', (tester) async {
    await pumpTwoPages(tester);
    expect(find.byType(FadeRisePageTransition), findsWidgets);
    expect(find.byType(PredictiveBackPeek), findsNothing);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(PredictiveBackPeek), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('page b'), findsNothing);
  });

  testWidgets('a back swipe peeks the page and commits into a pop', (
    tester,
  ) async {
    await pumpTwoPages(tester);
    final restWidth = tester.getRect(find.text('page b')).width;

    await backGesture(tester, 'startBackGesture', {
      'touchOffset': [5.0, 300.0],
      'progress': 0.0,
      'swipeEdge': 0,
    });
    await backGesture(tester, 'updateBackGestureProgress', {
      'x': 100.0,
      'y': 320.0,
      'progress': 0.5,
      'swipeEdge': 0,
    });

    expect(find.byType(PredictiveBackPeek), findsOneWidget);
    final peek = tester.getRect(find.text('page b'));
    expect(peek.width, lessThan(restWidth));
    expect(peek.left, greaterThan(0));

    await backGesture(tester, 'commitBackGesture');
    await tester.pumpAndSettle();
    expect(find.text('page b'), findsNothing);
    expect(find.text('push'), findsOneWidget);
  });

  testWidgets('a cancelled back swipe eases the page back', (tester) async {
    await pumpTwoPages(tester);
    final rest = tester.getRect(find.text('page b'));

    await backGesture(tester, 'startBackGesture', {
      'touchOffset': [5.0, 300.0],
      'progress': 0.0,
      'swipeEdge': 0,
    });
    await backGesture(tester, 'updateBackGestureProgress', {
      'x': 60.0,
      'y': 300.0,
      'progress': 0.3,
      'swipeEdge': 0,
    });
    expect(tester.getRect(find.text('page b')).width, lessThan(rest.width));

    await backGesture(tester, 'cancelBackGesture');
    await tester.pumpAndSettle();
    expect(find.text('page b'), findsOneWidget);
    expect(tester.getRect(find.text('page b')), rest);
  });

  testWidgets('a route that vetoes pops does not peek', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PopScope(
                    canPop: false,
                    child: Scaffold(body: Text('page b')),
                  ),
                ),
              ),
              child: const Text('push'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('push'));
    await tester.pumpAndSettle();

    await backGesture(tester, 'startBackGesture', {
      'touchOffset': [5.0, 300.0],
      'progress': 0.0,
      'swipeEdge': 0,
    });
    await backGesture(tester, 'updateBackGestureProgress', {
      'x': 100.0,
      'y': 300.0,
      'progress': 0.5,
      'swipeEdge': 0,
    });
    expect(find.byType(PredictiveBackPeek), findsNothing);
    expect(find.text('page b'), findsOneWidget);
  });
}
