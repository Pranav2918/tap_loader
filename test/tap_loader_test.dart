import 'package:flutter/material.dart';
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
}
