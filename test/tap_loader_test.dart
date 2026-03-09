import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tap_loader/tap_loader.dart';

void main() {
  testWidgets('TapLoaderButton displays text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TapLoaderButton(
            text: 'Test Button',
            onTap: () async {},
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
  });

  testWidgets('TapLoaderButton shows loading indicator on tap', (WidgetTester tester) async {
    bool tapCompleted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TapLoaderButton(
            text: 'Action',
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 100));
              tapCompleted = true;
            },
          ),
        ),
      ),
    );

    // Initial state
    expect(find.text('Action'), findsOneWidget);
    expect(find.byType(CupertinoActivityIndicator), findsNothing);

    // Tap and check loading
    await tester.tap(find.text('Action'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(milliseconds: 50)); // Middle of transition

    // Indicator should be present (though it might be fading in)
    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

    // Wait for completion
    await tester.pump(const Duration(milliseconds: 200)); 
    expect(tapCompleted, isTrue);
    
    // Check if it returns to normal state
    await tester.pumpAndSettle();
    expect(find.text('Action'), findsOneWidget);
    expect(find.byType(CupertinoActivityIndicator), findsNothing);
  });

  testWidgets('TapLoaderButton works with synchronous onTap', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TapLoaderButton(
            text: 'Sync',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Sync'));
    await tester.pump();
    expect(tapped, isTrue);
    // Should not stay in loading state because it was sync
    expect(find.byType(CupertinoActivityIndicator), findsNothing);
  });

  testWidgets('TapLoaderButton respects external isLoading', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TapLoaderButton(
            text: 'External',
            isLoading: true,
            onTap: null,
          ),
        ),
      ),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    expect(find.text('External'), findsNothing);
  });
}
