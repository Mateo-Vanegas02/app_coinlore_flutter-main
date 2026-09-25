import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_coinlore_flutter/features/charts/charts.dart';

void main() {
  testWidgets('Test Chart 11 & 12 Syncfusion and Graphic', (tester) async {
    const normData = [
      {'category': 'Minado', 'segment': 'Circulante', 'percent': 93.5},
      {'category': 'Minado', 'segment': 'Por Emitir', 'percent': 6.5},
      {'category': 'Staking', 'segment': 'Bloqueado', 'percent': 28.0},
      {'category': 'Staking', 'segment': 'Libre', 'percent': 72.0},
    ];

    const rangeData = [
      {'crypto': 'BTC', 'min': -1.4, 'max': 2.8},
      {'crypto': 'ETH', 'min': -2.1, 'max': 3.5},
      {'crypto': 'SOL', 'min': -3.2, 'max': 5.1},
      {'crypto': 'BNB', 'min': -1.0, 'max': 2.2},
      {'crypto': 'XRP', 'min': 0.5, 'max': 4.8},
    ];

    // 1. AppNormalizedBarChart (Syncfusion)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: AppNormalizedBarChart(data: normData),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppNormalizedBarChart), findsOneWidget);

    // 2. GraphicNormalizedBarChart (Graphic)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: GraphicNormalizedBarChart(data: normData),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(GraphicNormalizedBarChart), findsOneWidget);

    // 3. AppRangeBarChart (Syncfusion)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: AppRangeBarChart(data: rangeData),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppRangeBarChart), findsOneWidget);

    // 4. GraphicRangeBarChart (Graphic)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: GraphicRangeBarChart(data: rangeData),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(GraphicRangeBarChart), findsOneWidget);
  });
}
