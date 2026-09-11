import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_coinlore_flutter/main.dart';

void main() {
  testWidgets('App starts and shows CoinLore title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump(const Duration(milliseconds: 300));
    // Verifica que el AppBar se muestra
    expect(find.text('CoinLore'), findsOneWidget);
  });
}
