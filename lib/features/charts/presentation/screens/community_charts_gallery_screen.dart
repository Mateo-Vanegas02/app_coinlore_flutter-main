import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../settings/presentation/providers/settings_provider.dart';
import '../../charts.dart';
import '../widgets/community/community_animated_transitions.dart';
import '../widgets/community/community_interactive_detail.dart';
import '../widgets/community/community_marker_view.dart';
import '../widgets/community/community_streaming_line.dart';
import '../widgets/community/community_synced_charts.dart';

class CommunityChartsGalleryScreen extends ConsumerStatefulWidget {
  const CommunityChartsGalleryScreen({super.key});

  @override
  ConsumerState<CommunityChartsGalleryScreen> createState() =>
      _CommunityChartsGalleryScreenState();
}

class _CommunityChartsGalleryScreenState
    extends ConsumerState<CommunityChartsGalleryScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = const [
    'Todos',
    '📈 Líneas (4)',
    '📊 Barras (6)',
    '🍩 Circulares (4)',
    '🎯 Puntos (2)',
    '✨ Avanzados (12)',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final tokens = ChartThemeTokens.fromBrightness(isDark: isDark);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Charts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'community_charts_flutter • 20 básicos',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () {
              ref.read(settingsProvider.notifier).update(
                    (s) => s.copyWith(
                      themeMode: isDark ? ThemeMode.light : ThemeMode.dark,
                    ),
                  );
            },
            tooltip: 'Cambiar tema',
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              border: Border(
                bottom: BorderSide(color: tokens.cardBorderColor, width: 1),
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final isSelected = _selectedCategoryIndex == i;
                return ChoiceChip(
                  label: Text(_categories[i]),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategoryIndex = i);
                  },
                  selectedColor: tokens.primaryColor,
                  backgroundColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF1F5F9),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey[300] : const Color(0xFF334155)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          isSelected ? tokens.primaryColor : Colors.transparent,
                    ),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildFilteredCharts(tokens, isDark),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredCharts(ChartThemeTokens tokens, bool isDark) {
    final widgets = <Widget>[];

    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 1) {
      widgets.add(_sectionHeader('1. Líneas y Áreas (4)',
          'Renderizadas con LineChart de community_charts_flutter'));
      widgets.add(_chartLineSimple(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartLineMulti(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartLineArea(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartLineStepped(tokens));
      widgets.add(const SizedBox(height: 24));
    }

    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 2) {
      widgets.add(_sectionHeader(
          '2. Barras y Columnas (6)', 'BarChart con agrupación y apilado'));
      widgets.add(_chartBarVertical(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartBarHorizontal(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartBarGrouped(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartBarStacked(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartBarNegative(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartBarWithLabels(tokens));
      widgets.add(const SizedBox(height: 24));
    }

    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 3) {
      widgets.add(_sectionHeader(
          '3. Circulares y Radiales (4)', 'PieChart con ArcRendererConfig'));
      widgets.add(_chartPieSimple(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartPieDonut(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartPieHalf(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartPieWithPercentages(tokens));
      widgets.add(const SizedBox(height: 24));
    }

    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 4) {
      widgets.add(_sectionHeader(
          '4. Puntos y Radar (3)', 'ScatterPlotChart y RadarChart'));
      widgets.add(_chartScatter(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartBubble(tokens));
      widgets.add(const SizedBox(height: 16));
    }

    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 5) {
      widgets.add(_sectionHeader(
        'Avanzados (12)',
        'Los 12 gráficos avanzados con community_charts_flutter',
      ));
      widgets.add(_chartCombined(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartDualAxis(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartPyramid(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartRadarMulti(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartAnimatedTransitions(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartLargeDataset(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartInteractiveDetail(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartMarkerView(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartStreamingLine(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartSyncedCharts(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartGradientArea(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chartCandlestick(tokens));
      widgets.add(const SizedBox(height: 24));
    }

    return widgets;
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: -0.3),
          ),
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // GRÁFICOS — datos idénticos a los de graphic para comparar 1:1
  // ---------------------------------------------------------------------

  Widget _chartLineSimple(ChartThemeTokens tokens) {
    const points = [
      ChartPoint(x: '01:00', y: 83900),
      ChartPoint(x: '05:00', y: 84200),
      ChartPoint(x: '09:00', y: 83800),
      ChartPoint(x: '13:00', y: 84400),
      ChartPoint(x: '17:00', y: 84650),
      ChartPoint(x: '21:00', y: 84900),
    ];
    return AppChartCard(
      title: '1. Line Chart (Línea Clásica)',
      subtitle: 'LineChart + LineRendererConfig',
      badgeText: 'Community #1',
      height: 220,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.lineSimple,
        data: points,
        tokens: tokens,
      ),
    );
  }

  Widget _chartLineMulti(ChartThemeTokens tokens) {
    const multiData = [
      ChartPoint(x: 'Ene', y: 42000, series: 'BTC'),
      ChartPoint(x: 'Feb', y: 52000, series: 'BTC'),
      ChartPoint(x: 'Mar', y: 68000, series: 'BTC'),
      ChartPoint(x: 'Abr', y: 84000, series: 'BTC'),
      ChartPoint(x: 'Ene', y: 2200, series: 'ETH'),
      ChartPoint(x: 'Feb', y: 2800, series: 'ETH'),
      ChartPoint(x: 'Mar', y: 3500, series: 'ETH'),
      ChartPoint(x: 'Abr', y: 2680, series: 'ETH'),
      ChartPoint(x: 'Ene', y: 95, series: 'SOL'),
      ChartPoint(x: 'Feb', y: 110, series: 'SOL'),
      ChartPoint(x: 'Mar', y: 180, series: 'SOL'),
      ChartPoint(x: 'Abr', y: 116, series: 'SOL'),
    ];
    return AppChartCard(
      title: '2. Multi-Line Chart',
      subtitle: 'Varias Series<ChartPoint, String>',
      badgeText: '3 Series',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.lineMulti,
        data: multiData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartLineArea(ChartThemeTokens tokens) {
    const points = [
      ChartPoint(x: 'Lun', y: 81200),
      ChartPoint(x: 'Mar', y: 82500),
      ChartPoint(x: 'Mié', y: 81900),
      ChartPoint(x: 'Jue', y: 83400),
      ChartPoint(x: 'Vie', y: 82800),
      ChartPoint(x: 'Sáb', y: 84100),
      ChartPoint(x: 'Dom', y: 84600),
    ];
    return AppChartCard(
      title: '3. Smooth Area Chart',
      subtitle: 'LineRendererConfig(includeArea: true)',
      badgeText: '+4.18%',
      isPositiveBadge: true,
      height: 220,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.lineArea,
        data: points,
        tokens: tokens,
      ),
    );
  }

  Widget _chartLineStepped(ChartThemeTokens tokens) {
    const stepData = [
      ChartPoint(x: '00:00', y: 83200),
      ChartPoint(x: '04:00', y: 83200),
      ChartPoint(x: '08:00', y: 83800),
      ChartPoint(x: '12:00', y: 84400),
      ChartPoint(x: '16:00', y: 84100),
      ChartPoint(x: '20:00', y: 84600),
    ];
    return AppChartCard(
      title: '4. Step Line Chart',
      subtitle: 'Línea con puntos por defecto',
      badgeText: 'Community #4',
      height: 220,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.lineStepped,
        data: stepData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartBarVertical(ChartThemeTokens tokens) {
    const barData = [
      ChartPoint(x: 'BTC', y: 30.5),
      ChartPoint(x: 'ETH', y: 12.4),
      ChartPoint(x: 'USDT', y: 65.9),
      ChartPoint(x: 'BNB', y: 0.7),
      ChartPoint(x: 'SOL', y: 3.3),
    ];
    return AppChartCard(
      title: '5. Vertical Bar Chart',
      subtitle: 'BarChart vertical con BarLabelDecorator',
      badgeText: 'Volumen \$B',
      height: 220,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.barVertical,
        data: barData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartBarHorizontal(ChartThemeTokens tokens) {
    const rankData = [
      ChartPoint(x: 'BTC', y: 1680),
      ChartPoint(x: 'ETH', y: 327),
      ChartPoint(x: 'USDT', y: 183),
      ChartPoint(x: 'BNB', y: 107),
      ChartPoint(x: 'SOL', y: 63),
    ];
    return AppChartCard(
      title: '6. Horizontal Bar Chart',
      subtitle: 'BarChart(vertical: false)',
      badgeText: 'Top Cap',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.barHorizontal,
        data: rankData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartBarGrouped(ChartThemeTokens tokens) {
    const groupedData = [
      ChartPoint(x: 'BTC', y: 28, series: 'Spot'),
      ChartPoint(x: 'BTC', y: 45, series: 'Derivados'),
      ChartPoint(x: 'ETH', y: 12, series: 'Spot'),
      ChartPoint(x: 'ETH', y: 24, series: 'Derivados'),
      ChartPoint(x: 'SOL', y: 4, series: 'Spot'),
      ChartPoint(x: 'SOL', y: 9, series: 'Derivados'),
    ];
    return AppChartCard(
      title: '7. Grouped Bar Chart',
      subtitle: 'BarGroupingType.grouped',
      badgeText: 'Agrupadas',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.barGrouped,
        data: groupedData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartBarStacked(ChartThemeTokens tokens) {
    const stackedData = [
      ChartPoint(x: 'Q1', y: 35, series: 'DeFi'),
      ChartPoint(x: 'Q1', y: 65, series: 'CeFi'),
      ChartPoint(x: 'Q2', y: 45, series: 'DeFi'),
      ChartPoint(x: 'Q2', y: 55, series: 'CeFi'),
      ChartPoint(x: 'Q3', y: 52, series: 'DeFi'),
      ChartPoint(x: 'Q3', y: 48, series: 'CeFi'),
    ];
    return AppChartCard(
      title: '8. Stacked Bar Chart',
      subtitle: 'BarGroupingType.stacked',
      badgeText: 'Apiladas',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.barStacked,
        data: stackedData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartBarNegative(ChartThemeTokens tokens) {
    const negData = [
      ChartPoint(x: 'BTC', y: 2.8),
      ChartPoint(x: 'ETH', y: -1.4),
      ChartPoint(x: 'SOL', y: 5.1),
      ChartPoint(x: 'XRP', y: -3.2),
      ChartPoint(x: 'BNB', y: 1.1),
    ];
    return AppChartCard(
      title: '9. Barras con valores negativos',
      subtitle: 'Variación % 24h — BarChart con dominio cruzando 0',
      badgeText: 'Rangos %',
      height: 220,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.barNegative,
        data: negData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartBarWithLabels(ChartThemeTokens tokens) {
    const barData = [
      ChartPoint(x: 'BTC', y: 30.5),
      ChartPoint(x: 'ETH', y: 12.4),
      ChartPoint(x: 'USDT', y: 65.9),
      ChartPoint(x: 'BNB', y: 0.7),
      ChartPoint(x: 'SOL', y: 3.3),
    ];
    return AppChartCard(
      title: '10. Barras con etiquetas internas',
      subtitle: 'BarLabelPosition.inside',
      badgeText: 'Labels',
      height: 220,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.barWithLabels,
        data: barData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartPieSimple(ChartThemeTokens tokens) {
    const pieData = [
      ChartPoint(x: 'BTC', y: 58),
      ChartPoint(x: 'ETH', y: 15),
      ChartPoint(x: 'USDT', y: 12),
      ChartPoint(x: 'Otros', y: 15),
    ];
    return AppChartCard(
      title: '11. Pie Chart',
      subtitle: 'PieChart + ArcRendererConfig',
      badgeText: 'Torta',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.pieSimple,
        data: pieData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartPieDonut(ChartThemeTokens tokens) {
    const pieData = [
      ChartPoint(x: 'BTC', y: 58.2),
      ChartPoint(x: 'ETH', y: 14.1),
      ChartPoint(x: 'Stable', y: 12.0),
      ChartPoint(x: 'Alt', y: 15.7),
    ];
    return AppChartCard(
      title: '12. Donut Chart',
      subtitle: 'ArcRendererConfig(arcWidth: 30)',
      badgeText: 'Dona',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.pieDonut,
        data: pieData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartPieHalf(ChartThemeTokens tokens) {
    const pieData = [
      ChartPoint(x: 'Alcista', y: 68),
      ChartPoint(x: 'Bajista', y: 32),
    ];
    return AppChartCard(
      title: '13. Half Pie (Semicírculo)',
      subtitle: 'startAngle: π, arcLength: π',
      badgeText: 'Medio',
      height: 220,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.pieHalf,
        data: pieData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartPieWithPercentages(ChartThemeTokens tokens) {
    const pieData = [
      ChartPoint(x: 'BTC', y: 58),
      ChartPoint(x: 'ETH', y: 15),
      ChartPoint(x: 'USDT', y: 12),
      ChartPoint(x: 'Otros', y: 15),
    ];
    return AppChartCard(
      title: '14. Pie con porcentajes',
      subtitle: 'labelAccessorFn con formato %',
      badgeText: 'Dominancia',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.pieWithPercentages,
        data: pieData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartScatter(ChartThemeTokens tokens) {
    const scatterData = [
      ChartPoint(x: 1680, y: 0.34),
      ChartPoint(x: 327, y: 0.10),
      ChartPoint(x: 63, y: 1.75),
      ChartPoint(x: 32, y: -1.39),
    ];
    return AppChartCard(
      title: '15. Scatter Plot',
      subtitle: 'ScatterPlotChart — X/Y independientes',
      badgeText: 'Dispersión',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.scatter,
        data: scatterData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartBubble(ChartThemeTokens tokens) {
    const bubbleData = [
      ChartPoint(x: 1680, y: 0.34, extra: {'size': 32}),
      ChartPoint(x: 327, y: 0.10, extra: {'size': 20}),
      ChartPoint(x: 91, y: 2.42, extra: {'size': 15}),
      ChartPoint(x: 63, y: 1.75, extra: {'size': 16}),
    ];
    return AppChartCard(
      title: '16. Bubble Chart',
      subtitle: 'radiusPxFn con size de extra',
      badgeText: '3 Dimensiones',
      height: 230,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.bubble,
        data: bubbleData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartCombined(ChartThemeTokens tokens) {
    // Convención: `series: 'bar'` = barras, `series: 'line'` = línea.
    const combinedData = [
      ChartPoint(x: 'Ene', y: 30, series: 'bar'),
      ChartPoint(x: 'Feb', y: 45, series: 'bar'),
      ChartPoint(x: 'Mar', y: 38, series: 'bar'),
      ChartPoint(x: 'Abr', y: 52, series: 'bar'),
      ChartPoint(x: 'Ene', y: 22, series: 'line'),
      ChartPoint(x: 'Feb', y: 35, series: 'line'),
      ChartPoint(x: 'Mar', y: 48, series: 'line'),
      ChartPoint(x: 'Abr', y: 42, series: 'line'),
    ];
    return AppChartCard(
      title: '18. CombinedChart (Barras + Línea)',
      subtitle: 'OrdinalComboChart con BarRenderer + LineRenderer',
      badgeText: 'Combo',
      height: 240,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.combinedChart,
        data: combinedData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartDualAxis(ChartThemeTokens tokens) {
    // Convención: `series: 'left'` = eje izquierdo, `series: 'right'` = eje derecho.
    const dualData = [
      ChartPoint(x: 'BTC', y: 1680, series: 'left'),
      ChartPoint(x: 'ETH', y: 327, series: 'left'),
      ChartPoint(x: 'SOL', y: 63, series: 'left'),
      ChartPoint(x: 'BTC', y: 2.8, series: 'right'),
      ChartPoint(x: 'ETH', y: -1.4, series: 'right'),
      ChartPoint(x: 'SOL', y: 5.1, series: 'right'),
    ];
    return AppChartCard(
      title: '19. Doble Eje Y (Escalas Independientes)',
      subtitle: 'Market Cap (izq) vs Variación % 24h (der)',
      badgeText: '2 Ejes',
      height: 240,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.dualAxis,
        data: dualData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartPyramid(ChartThemeTokens tokens) {
    // Compras (left) y Ventas (right) por exchange.
    const pyramidData = [
      ChartPoint(x: 'Binance', y: 340, series: 'left'),
      ChartPoint(x: 'Coinbase', y: 210, series: 'left'),
      ChartPoint(x: 'Kraken', y: 95, series: 'left'),
      ChartPoint(x: 'Binance', y: 280, series: 'right'),
      ChartPoint(x: 'Coinbase', y: 175, series: 'right'),
      ChartPoint(x: 'Kraken', y: 120, series: 'right'),
    ];
    return AppChartCard(
      title: '20. Pirámide (Barras Horizontales Apiladas ±)',
      subtitle: 'Compras vs Ventas por exchange — dominio cruzando 0',
      badgeText: 'Pirámide',
      height: 240,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.pyramid,
        data: pyramidData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartRadarMulti(ChartThemeTokens tokens) {
    // Cada cripto comparada sobre las mismas 5 métricas.
    const radarMultiData = [
      // BTC
      ChartPoint(x: 'Volumen', y: 95, series: 'BTC'),
      ChartPoint(x: 'Cap', y: 100, series: 'BTC'),
      ChartPoint(x: 'ATH', y: 88, series: 'BTC'),
      ChartPoint(x: '24h', y: 60, series: 'BTC'),
      ChartPoint(x: 'Comunidad', y: 92, series: 'BTC'),
      // ETH
      ChartPoint(x: 'Volumen', y: 75, series: 'ETH'),
      ChartPoint(x: 'Cap', y: 68, series: 'ETH'),
      ChartPoint(x: 'ATH', y: 62, series: 'ETH'),
      ChartPoint(x: '24h', y: 55, series: 'ETH'),
      ChartPoint(x: 'Comunidad', y: 88, series: 'ETH'),
      // SOL
      ChartPoint(x: 'Volumen', y: 50, series: 'SOL'),
      ChartPoint(x: 'Cap', y: 45, series: 'SOL'),
      ChartPoint(x: 'ATH', y: 70, series: 'SOL'),
      ChartPoint(x: '24h', y: 85, series: 'SOL'),
      ChartPoint(x: 'Comunidad', y: 80, series: 'SOL'),
    ];
    return AppChartCard(
      title: '21. Comparativa Multidimensional (Barras Agrupadas)',
      subtitle:
          'Radar multi-dataset adaptado — community_charts no tiene radar nativo',
      badgeText: '3 Entidades',
      height: 250,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.radarMulti,
        data: radarMultiData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartAnimatedTransitions(ChartThemeTokens tokens) {
    return AppChartCard(
      title: '22. Transiciones Animadas (Cambio de Filtro)',
      subtitle: 'Pulsa los chips para cambiar el rango y ver la interpolación',
      badgeText: 'Animado',
      height: 280,
      chart: CommunityAnimatedTransitions(tokens: tokens),
    );
  }

  Widget _chartLargeDataset(ChartThemeTokens tokens) {
    // 5.000 puntos generados determinísticamente con una caminata aleatoria.
    final points = _generateLargeDataset(5000);
    return AppChartCard(
      title: '23. Dataset Grande (5.000 puntos)',
      subtitle: 'LineChart sin animación — render fluido a gran escala',
      badgeText: '5k puntos',
      height: 240,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.largeDataset,
        data: points,
        tokens: tokens,
        animate: false,
      ),
    );
  }

  /// Caminata aleatoria determinista (semilla fija = 42).
  List<ChartPoint> _generateLargeDataset(int count) {
    final points = <ChartPoint>[];
    double price = 80000;
    int seed = 42;
    for (int i = 0; i < count; i++) {
      // PRNG xorshift
      seed ^= seed << 13;
      seed ^= seed >> 7;
      seed ^= seed << 17;
      final r = (seed & 0x7FFFFFFF) / 0x7FFFFFFF;
      final shock = (r - 0.5) * 2 * 0.01; // ±1%
      price = price * (1 + shock);
      points.add(ChartPoint(x: i.toString(), y: price));
    }
    return points;
  }

  Widget _chartInteractiveDetail(ChartThemeTokens tokens) {
    const interactiveData = [
      ChartPoint(x: '01:00', y: 83900),
      ChartPoint(x: '05:00', y: 84200),
      ChartPoint(x: '09:00', y: 83800),
      ChartPoint(x: '13:00', y: 84400),
      ChartPoint(x: '17:00', y: 84650),
      ChartPoint(x: '21:00', y: 84900),
    ];
    return AppChartCard(
      title: '24. Panel de Detalle Interactivo',
      subtitle: 'SelectionModel — toca un punto para ver el detalle',
      badgeText: 'Interactivo',
      height: 300,
      chart: CommunityInteractiveDetail(
        tokens: tokens,
        data: interactiveData,
      ),
    );
  }

  Widget _chartMarkerView(ChartThemeTokens tokens) {
    const markerData = [
      ChartPoint(x: '00:00', y: 83200),
      ChartPoint(x: '04:00', y: 83800),
      ChartPoint(x: '08:00', y: 84400),
      ChartPoint(x: '12:00', y: 84100),
      ChartPoint(x: '16:00', y: 84600),
      ChartPoint(x: '20:00', y: 84900),
    ];
    return AppChartCard(
      title: '25. MarkerView / Tooltip Personalizado',
      subtitle: 'Selección de punto con panel flotante de layout propio',
      badgeText: 'Tooltip',
      height: 260,
      chart: CommunityMarkerView(
        tokens: tokens,
        data: markerData,
      ),
    );
  }

  Widget _chartStreamingLine(ChartThemeTokens tokens) {
    return AppChartCard(
      title: '26. Streaming en Tiempo Real',
      subtitle: 'Un punto cada 500 ms — ventana deslizante de 30 puntos',
      badgeText: 'En vivo',
      height: 320,
      chart: CommunityStreamingLine(tokens: tokens),
    );
  }

  Widget _chartSyncedCharts(ChartThemeTokens tokens) {
    return AppChartCard(
      title: '27. Dos Gráficos Sincronizados (Zoom/Scroll Compartido)',
      subtitle: 'Mueve el RangeSlider: ambos gráficos cambian al unísono',
      badgeText: 'Sincronizados',
      height: 420,
      chart: CommunitySyncedCharts(tokens: tokens),
    );
  }

  Widget _chartGradientArea(ChartThemeTokens tokens) {
    const gradientData = [
      ChartPoint(x: 'Ene', y: 62000),
      ChartPoint(x: 'Feb', y: 69000),
      ChartPoint(x: 'Mar', y: 74000),
      ChartPoint(x: 'Abr', y: 78000),
      ChartPoint(x: 'May', y: 82000),
      ChartPoint(x: 'Jun', y: 84500),
    ];
    return AppChartCard(
      title: '28. Relleno con Gradiente (Renderer Custom)',
      subtitle: 'Área con gradiente vertical — aproximación con areaOpacity',
      badgeText: 'Gradiente',
      height: 240,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.gradientArea,
        data: gradientData,
        tokens: tokens,
      ),
    );
  }

  Widget _chartCandlestick(ChartThemeTokens tokens) {
    // Datos OHLC simulados: open/high/low/close en `extra`.
    const ohlcData = [
      ChartPoint(
          x: '09:00',
          y: 84000,
          extra: {'open': 83800, 'high': 84500, 'low': 83600, 'close': 84200}),
      ChartPoint(
          x: '10:00',
          y: 84100,
          extra: {'open': 84200, 'high': 84350, 'low': 83900, 'close': 84000}),
      ChartPoint(
          x: '11:00',
          y: 84200,
          extra: {'open': 84000, 'high': 84600, 'low': 83950, 'close': 84450}),
      ChartPoint(
          x: '12:00',
          y: 84300,
          extra: {'open': 84450, 'high': 84500, 'low': 84050, 'close': 84150}),
      ChartPoint(
          x: '13:00',
          y: 84400,
          extra: {'open': 84150, 'high': 84800, 'low': 84100, 'close': 84650}),
      ChartPoint(
          x: '14:00',
          y: 84500,
          extra: {'open': 84650, 'high': 84900, 'low': 84400, 'close': 84700}),
    ];
    return AppChartCard(
      title: '29. Candlestick + Volumen (Renderer Custom)',
      subtitle: kIsWeb
          ? 'No disponible en Web — bug de renderers custom'
          : 'OHLC con velas coloreadas por dirección — solo Android/Desktop',
      badgeText: kIsWeb ? 'Web: no' : 'Android: OK',
      height: 240,
      chart: CommunityChartRenderer.build(
        type: CommunityChartType.candlestickWithVolume,
        data: ohlcData,
        tokens: tokens,
      ),
    );
  }
}
