import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/screens/charts_menu_screen.dart';

void main() {
  testWidgets('ChartsMenuScreen renders tabs and lists', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ChartsMenuScreen(),
        ),
      ),
    );

    // Verify AppBar title
    expect(find.text('MPAndroidChart'), findsOneWidget);

    // Verify tabs exist
    expect(find.text('Básicos (20)'), findsOneWidget);
    expect(find.text('Avanzados (12)'), findsOneWidget);

    // Verify first basic chart is visible (at least partly)
    expect(find.text('1. Línea simple'), findsOneWidget);
    
    // Tap on Advanced tab
    await tester.tap(find.text('Avanzados (12)'));
    await tester.pumpAndSettle();

    // Verify advanced charts are visible
    expect(find.text('1. Combined Chart'), findsOneWidget);
  });
}
