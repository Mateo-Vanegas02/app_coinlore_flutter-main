import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/settings_provider.dart';
import '../../charts.dart';

/// Catálogo y Centro de Visualización de Gráficos (Analytics Hub).
/// Muestra los 32 gráficos con Syncfusion y los 32 gráficos con Graphic (64 gráficos en total).
class ChartsGalleryScreen extends ConsumerStatefulWidget {
  const ChartsGalleryScreen({super.key});

  @override
  ConsumerState<ChartsGalleryScreen> createState() => _ChartsGalleryScreenState();
}

class _ChartsGalleryScreenState extends ConsumerState<ChartsGalleryScreen> {
  // 0: Todos (64), 1: Syncfusion (32), 2: Graphic (32)
  int _selectedEngineIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Todos',
    '📈 Líneas & Áreas',
    '📊 Barras & Columnas',
    '🍩 Circulares & Radiales',
    '🎯 Puntos & Radar',
    '🔬 Avanzados',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final tokens = ChartThemeTokens.fromBrightness(isDark: isDark);

    final showSf = _selectedEngineIndex == 0 || _selectedEngineIndex == 1;
    final showGr = _selectedEngineIndex == 0 || _selectedEngineIndex == 2;

    String subtitleText;
    if (_selectedEngineIndex == 0) {
      subtitleText = 'Catálogo Completo • 64 Gráficos (32 Syncfusion + 32 Graphic)';
    } else if (_selectedEngineIndex == 1) {
      subtitleText = 'Catálogo Syncfusion Charts • 32 Gráficos Nativos';
    } else {
      subtitleText = 'Catálogo Graphic 2.7.0 • 32 Gráficos Gramaticales';
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Centro de Gráficos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitleText,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
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
          // Selector de Motor: Todos (64) | Syncfusion (32) | Graphic (32)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        label: Text('Todos (64)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.dashboard_customize_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Syncfusion (32)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.bolt_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: 2,
                        label: Text('Graphic (32)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.bar_chart_rounded, size: 16),
                      ),
                    ],
                    selected: {_selectedEngineIndex},
                    onSelectionChanged: (val) {
                      setState(() => _selectedEngineIndex = val.first);
                    },
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Selector horizontal de categorías
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: tokens.cardBorderColor,
                  width: 1,
                ),
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
                  backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9),
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
                      color: isSelected ? tokens.primaryColor : Colors.transparent,
                    ),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),

          // Lista de Gráficos Filtrados
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildFilteredCharts(tokens, showSf, showGr),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredCharts(ChartThemeTokens tokens, bool showSf, bool showGr) {
    final widgets = <Widget>[];

    // 1. Líneas y Áreas (6 tipos = hasta 12 gráficos)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 1) {
      widgets.add(_buildSectionHeader('1. Líneas y Áreas', 'Evolución continua y series temporales'));
      widgets.addAll(_chart1StandardLine(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart2SmoothArea(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart3StepLine(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart4GradientArea(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart5MultiLine(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart6BaselineArea(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));
    }

    // 2. Barras y Columnas (6 tipos = hasta 12 gráficos)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 2) {
      widgets.add(_buildSectionHeader('2. Barras y Columnas', 'Comparativas categóricas y acumulaciones'));
      widgets.addAll(_chart7VerticalBar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart8HorizontalBar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart9GroupedBar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart10StackedBar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart11NormalizedBar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart12RangeBar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));
    }

    // 3. Circulares y Radiales (5 tipos = hasta 10 gráficos)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 3) {
      widgets.add(_buildSectionHeader('3. Circulares y Radiales', 'Proporciones, dominancia y ángulos polares'));
      widgets.addAll(_chart13Pie(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart14Donut(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart15Gauge(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart16Rose(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart17RadialBar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));
    }

    // 4. Puntos y Radar (3 tipos = hasta 6 gráficos)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 4) {
      widgets.add(_buildSectionHeader('4. Puntos y Radar', 'Dispersión multidimensional y perfiles polares'));
      widgets.addAll(_chart18Scatter(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart19Bubble(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart20Radar(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));
    }

    // 5. Avanzados (12 tipos = hasta 24 gráficos)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 5) {
      widgets.add(_buildSectionHeader('5. Avanzados: Estadísticos y Densidad', 'Distribuciones y probabilidad'));
      widgets.addAll(_chart21Heatmap(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart22BoxPlot(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart23Histogram(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart24Violin(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));

      widgets.add(_buildSectionHeader('6. Avanzados: Jerárquicos y Proporción', 'Relaciones parte-todo y flujos'));
      widgets.addAll(_chart25Treemap(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart26Sunburst(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart27Funnel(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));

      widgets.add(_buildSectionHeader('7. Avanzados: Multidimensionales y Continuos', 'Correlaciones y bandas'));
      widgets.addAll(_chart28Parallel(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart29ScatterMatrix(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart30BandArea(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));

      widgets.add(_buildSectionHeader('8. Avanzados: Financieros y Flujo', 'Trading y evolución orgánica'));
      widgets.addAll(_chart31Candlestick(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 16));
      widgets.addAll(_chart32Streamgraph(tokens, showSf, showGr));
      widgets.add(const SizedBox(height: 24));
    }

    return widgets;
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: -0.3),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // DEFINICIONES DE LOS 32 GRÁFICOS (DUAL ENGINE: SYNCFUSION & GRAPHIC)
  // -------------------------------------------------------------

  List<Widget> _chart1StandardLine(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const points = [
      ChartPoint(x: '01:00', y: 83900),
      ChartPoint(x: '05:00', y: 84200),
      ChartPoint(x: '09:00', y: 83800),
      ChartPoint(x: '13:00', y: 84400),
      ChartPoint(x: '17:00', y: 84650),
      ChartPoint(x: '21:00', y: 84900),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(AppChartCard(
        title: '1. Line Chart (Syncfusion)',
        subtitle: 'FastLine / SplineSeries en SfCartesianChart',
        badgeText: '⚡ Syncfusion #1',
        height: 200,
        chart: AppStandardLineChart(data: points, color: tokens.primaryColor),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(AppChartCard(
        title: '1. Line Chart (Graphic)',
        subtitle: 'LineMark() puro en RectCoord() con Gramática de Gráficos',
        badgeText: '📊 Graphic #1',
        height: 200,
        chart: GraphicStandardLineChart(data: points, color: tokens.accentColor),
      ));
    }
    return items;
  }

  List<Widget> _chart2SmoothArea(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const smoothData = [
      ChartPoint(x: 'Lun', y: 82500),
      ChartPoint(x: 'Mar', y: 83400),
      ChartPoint(x: 'Mié', y: 82900),
      ChartPoint(x: 'Jue', y: 84100),
      ChartPoint(x: 'Vie', y: 83800),
      ChartPoint(x: 'Sáb', y: 84600),
      ChartPoint(x: 'Dom', y: 85200),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '2. Smooth Area Chart (Syncfusion)',
        subtitle: 'SplineAreaSeries con gradiente continuo',
        badgeText: '⚡ Syncfusion #2',
        height: 200,
        chart: AppSmoothAreaChart(data: smoothData, isBullish: true),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '2. Smooth Area Chart (Graphic)',
        subtitle: 'AreaMark() con interpolador Bezier suave',
        badgeText: '📊 Graphic #2',
        height: 200,
        chart: GraphicSmoothAreaChart(data: smoothData),
      ));
    }
    return items;
  }

  List<Widget> _chart3StepLine(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const stepData = [
      ChartPoint(x: '00:00', y: 84000),
      ChartPoint(x: '04:00', y: 84000),
      ChartPoint(x: '08:00', y: 84300),
      ChartPoint(x: '12:00', y: 84300),
      ChartPoint(x: '16:00', y: 83900),
      ChartPoint(x: '20:00', y: 84500),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '3. Step Line Chart (Syncfusion)',
        subtitle: 'StepLineSeries para cambios discretos de liquidez',
        badgeText: '⚡ Syncfusion #3',
        height: 200,
        chart: AppStepLineChart(data: stepData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '3. Step Line Chart (Graphic)',
        subtitle: 'LineMark con escalón HV (Horizontal-Vertical)',
        badgeText: '📊 Graphic #3',
        height: 200,
        chart: GraphicStepLineChart(data: stepData),
      ));
    }
    return items;
  }

  List<Widget> _chart4GradientArea(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const gradientData = [
      ChartPoint(x: '00:00', y: 81000),
      ChartPoint(x: '04:00', y: 82300),
      ChartPoint(x: '08:00', y: 81900),
      ChartPoint(x: '12:00', y: 83400),
      ChartPoint(x: '16:00', y: 84200),
      ChartPoint(x: '20:00', y: 84900),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '4. Gradient Area Chart (Syncfusion)',
        subtitle: 'SplineAreaSeries con degradado vertical',
        badgeText: '⚡ Syncfusion #4',
        height: 200,
        chart: AppGradientAreaChart(data: gradientData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '4. Gradient Area Chart (Graphic)',
        subtitle: 'AreaMark() con degradado semántico',
        badgeText: '📊 Graphic #4',
        height: 200,
        chart: GraphicGradientAreaChart(data: gradientData),
      ));
    }
    return items;
  }

  List<Widget> _chart5MultiLine(ChartThemeTokens tokens, bool showSf, bool showGr) {
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
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '5. Multi-Line Chart (Syncfusion)',
        subtitle: 'Multiples SplineSeries comparando activos',
        badgeText: '⚡ Syncfusion #5',
        height: 210,
        chart: AppMultiLineChart(data: multiData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '5. Multi-Line Chart (Graphic)',
        subtitle: "LineMark con Varset('x') * Varset('y') / Varset('series')",
        badgeText: '📊 Graphic #5',
        height: 210,
        chart: GraphicMultiLineChart(data: multiData),
      ));
    }
    return items;
  }

  List<Widget> _chart6BaselineArea(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const baselineData = [
      ChartPoint(x: '00:00', y: 83600),
      ChartPoint(x: '04:00', y: 83900),
      ChartPoint(x: '08:00', y: 84350),
      ChartPoint(x: '12:00', y: 84700),
      ChartPoint(x: '16:00', y: 84200),
      ChartPoint(x: '20:00', y: 83800),
      ChartPoint(x: '24:00', y: 84500),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '6. Baseline Area (Syncfusion)',
        subtitle: 'Área condicional verde sobre umbral (\$84.0k) y roja debajo',
        badgeText: '⚡ Syncfusion #6',
        isPositiveBadge: true,
        height: 200,
        chart: AppBaselineAreaChart(data: baselineData, baseline: 84000.0),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '6. Baseline Area (Graphic)',
        subtitle: 'Área condicional con CustomPainter y gradientes de umbral',
        badgeText: '📊 Graphic #6',
        isPositiveBadge: true,
        height: 200,
        chart: GraphicBaselineAreaChart(data: baselineData, baseline: 84000.0),
      ));
    }
    return items;
  }

  List<Widget> _chart7VerticalBar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const barData = [
      ChartPoint(x: 'BTC', y: 30.5),
      ChartPoint(x: 'ETH', y: 12.4),
      ChartPoint(x: 'USDT', y: 65.9),
      ChartPoint(x: 'BNB', y: 0.7),
      ChartPoint(x: 'SOL', y: 3.3),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(AppChartCard(
        title: '7. Vertical Bar / Column (Syncfusion)',
        subtitle: 'ColumnSeries nativo - Volumen 24h (\$B)',
        badgeText: '⚡ Syncfusion #7',
        height: 200,
        chart: AppBarChart(data: barData, barColor: tokens.accentColor),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(AppChartCard(
        title: '7. Vertical Bar / Column (Graphic)',
        subtitle: 'IntervalMark con RectCoord() - Volumen 24h (\$B)',
        badgeText: '📊 Graphic #7',
        height: 200,
        chart: GraphicBarChart(data: barData, barColor: tokens.accentColor),
      ));
    }
    return items;
  }

  List<Widget> _chart8HorizontalBar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const rankData = [
      ChartPoint(x: 'BTC', y: 1680),
      ChartPoint(x: 'ETH', y: 327),
      ChartPoint(x: 'USDT', y: 183),
      ChartPoint(x: 'BNB', y: 107),
      ChartPoint(x: 'SOL', y: 63),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(AppChartCard(
        title: '8. Horizontal Bar (Syncfusion)',
        subtitle: 'BarSeries horizontal con ejes correctamente vinculados',
        badgeText: '⚡ Syncfusion #8',
        height: 210,
        chart: AppBarChart(data: rankData, isHorizontal: true, barColor: tokens.primaryColor),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(AppChartCard(
        title: '8. Horizontal Bar (Graphic)',
        subtitle: 'IntervalMark con RectCoord(transposed: true)',
        badgeText: '📊 Graphic #8',
        height: 210,
        chart: GraphicBarChart(data: rankData, isHorizontal: true, barColor: tokens.primaryColor),
      ));
    }
    return items;
  }

  List<Widget> _chart9GroupedBar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const groupedData = [
      {'category': 'BTC', 'group': 'Spot', 'value': 28},
      {'category': 'BTC', 'group': 'Derivados', 'value': 45},
      {'category': 'ETH', 'group': 'Spot', 'value': 12},
      {'category': 'ETH', 'group': 'Derivados', 'value': 24},
      {'category': 'SOL', 'group': 'Spot', 'value': 4},
      {'category': 'SOL', 'group': 'Derivados', 'value': 9},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '9. Grouped Bar Chart (Syncfusion)',
        subtitle: 'ColumnSeries múltiples agrupadas por activo',
        badgeText: '⚡ Syncfusion #9',
        height: 210,
        chart: AppGroupedBarChart(data: groupedData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '9. Grouped Bar Chart (Graphic)',
        subtitle: 'IntervalMark con DodgeModifier()',
        badgeText: '📊 Graphic #9',
        height: 210,
        chart: GraphicGroupedBarChart(data: groupedData),
      ));
    }
    return items;
  }

  List<Widget> _chart10StackedBar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const stackedData = [
      {'category': 'Q1', 'type': 'DeFi', 'value': 35},
      {'category': 'Q1', 'type': 'CeFi', 'value': 65},
      {'category': 'Q2', 'type': 'DeFi', 'value': 45},
      {'category': 'Q2', 'type': 'CeFi', 'value': 55},
      {'category': 'Q3', 'type': 'DeFi', 'value': 52},
      {'category': 'Q3', 'type': 'CeFi', 'value': 48},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '10. Stacked Bar Chart (Syncfusion)',
        subtitle: 'StackedColumnSeries de acumulación',
        badgeText: '⚡ Syncfusion #10',
        height: 210,
        chart: AppStackedBarChart(data: stackedData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '10. Stacked Bar Chart (Graphic)',
        subtitle: 'IntervalMark con StackModifier()',
        badgeText: '📊 Graphic #10',
        height: 210,
        chart: GraphicStackedBarChart(data: stackedData),
      ));
    }
    return items;
  }

  List<Widget> _chart11NormalizedBar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const normData = [
      {'category': 'Minado', 'segment': 'Circulante', 'percent': 93.5, 'group': 'Circulante', 'value': 93.5},
      {'category': 'Minado', 'segment': 'Por Emitir', 'percent': 6.5, 'group': 'Por Emitir', 'value': 6.5},
      {'category': 'Staking', 'segment': 'Bloqueado', 'percent': 28.0, 'group': 'Bloqueado', 'value': 28.0},
      {'category': 'Staking', 'segment': 'Libre', 'percent': 72.0, 'group': 'Libre', 'value': 72.0},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '11. 100% Stacked Bar (Syncfusion)',
        subtitle: 'StackedColumn100Series normalizada al 100%',
        badgeText: '⚡ Syncfusion #11',
        height: 210,
        chart: AppNormalizedBarChart(data: normData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '11. 100% Stacked Bar (Graphic)',
        subtitle: 'IntervalMark normalizado al 100% por categoría y segmento',
        badgeText: '📊 Graphic #11',
        height: 210,
        chart: GraphicNormalizedBarChart(data: normData),
      ));
    }
    return items;
  }

  List<Widget> _chart12RangeBar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const rangeData = [
      {'crypto': 'BTC', 'asset': 'BTC', 'min': -1.4, 'max': 2.8, 'low': -1.4, 'high': 2.8},
      {'crypto': 'ETH', 'asset': 'ETH', 'min': -2.1, 'max': 3.5, 'low': -2.1, 'high': 3.5},
      {'crypto': 'SOL', 'asset': 'SOL', 'min': -3.2, 'max': 5.1, 'low': -3.2, 'high': 5.1},
      {'crypto': 'BNB', 'asset': 'BNB', 'min': -1.0, 'max': 2.2, 'low': -1.0, 'high': 2.2},
      {'crypto': 'XRP', 'asset': 'XRP', 'min': 0.5, 'max': 4.8, 'low': 0.5, 'high': 4.8},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '12. Range Bar Chart (Syncfusion)',
        subtitle: 'RangeColumnSeries flotante: rango de variación % 24h por activo',
        badgeText: '⚡ Syncfusion #12',
        height: 210,
        chart: AppRangeBarChart(data: rangeData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '12. Range Bar Chart (Graphic)',
        subtitle: 'IntervalMark suspendido: rango de variación % 24h por activo',
        badgeText: '📊 Graphic #12',
        height: 210,
        chart: GraphicRangeBarChart(data: rangeData),
      ));
    }
    return items;
  }

  List<Widget> _chart13Pie(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const pieData = [
      ChartPoint(x: 'BTC', y: 58.2),
      ChartPoint(x: 'ETH', y: 13.5),
      ChartPoint(x: 'USDT', y: 6.8),
      ChartPoint(x: 'BNB', y: 3.7),
      ChartPoint(x: 'Otros', y: 17.8),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '13. Pie Chart (Syncfusion)',
        subtitle: 'PieSeries nativo con proporciones del mercado',
        badgeText: '⚡ Syncfusion #13',
        height: 220,
        chart: AppPieChart(data: pieData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '13. Pie Chart (Graphic)',
        subtitle: 'IntervalMark con PolarCoord(transposed: true) - Torta completa',
        badgeText: '📊 Graphic #13',
        height: 220,
        chart: GraphicPieChart(data: pieData),
      ));
    }
    return items;
  }

  List<Widget> _chart14Donut(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const pieData = [
      ChartPoint(x: 'BTC', y: 58.2),
      ChartPoint(x: 'ETH', y: 13.5),
      ChartPoint(x: 'USDT', y: 6.8),
      ChartPoint(x: 'BNB', y: 3.7),
      ChartPoint(x: 'Otros', y: 17.8),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '14. Donut Chart (Syncfusion)',
        subtitle: 'DoughnutSeries con innerRadius para dona central',
        badgeText: '⚡ Syncfusion #14',
        height: 220,
        chart: AppDonutChart(data: pieData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '14. Donut Chart (Graphic)',
        subtitle: 'IntervalMark con PolarCoord(dimCount: 1, innerRadius: 0.55)',
        badgeText: '📊 Graphic #14',
        height: 220,
        chart: GraphicDonutChart(data: pieData),
      ));
    }
    return items;
  }

  List<Widget> _chart15Gauge(ChartThemeTokens tokens, bool showSf, bool showGr) {
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '15. Gauge Chart (Syncfusion)',
        subtitle: 'RadialBarSeries semicircular de Miedo & Codicia (78.5)',
        badgeText: '⚡ Syncfusion #15',
        height: 210,
        chart: AppGaugeChart(score: 78.5),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '15. Gauge Chart (Graphic)',
        subtitle: 'PolarCoord(startAngle: -pi, endAngle: 0) - Miedo & Codicia (78.5)',
        badgeText: '📊 Graphic #15',
        height: 210,
        chart: GraphicGaugeChart(score: 78.5),
      ));
    }
    return items;
  }

  List<Widget> _chart16Rose(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const roseData = [
      ChartPoint(x: 'DeFi', y: 65),
      ChartPoint(x: 'Layer 1', y: 90),
      ChartPoint(x: 'Layer 2', y: 45),
      ChartPoint(x: 'Memes', y: 80),
      ChartPoint(x: 'AI Tech', y: 70),
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '16. Nightingale Rose (Syncfusion)',
        subtitle: 'RadialBarSeries angular proporcional por sector',
        badgeText: '⚡ Syncfusion #16',
        height: 220,
        chart: AppRoseChart(data: roseData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '16. Nightingale Rose (Graphic)',
        subtitle: 'CustomPainter polar delimitado estrictamente a la tarjeta',
        badgeText: '📊 Graphic #16',
        height: 220,
        chart: GraphicRoseChart(data: roseData),
      ));
    }
    return items;
  }

  List<Widget> _chart17RadialBar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const radialData = [
      {'name': 'Seguridad', 'value': 92},
      {'name': 'Liquidez', 'value': 78},
      {'name': 'Comunidad', 'value': 85},
      {'name': 'Adopción', 'value': 64},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '17. Radial Bar Chart (Syncfusion)',
        subtitle: 'RadialBarSeries concéntrico con esquinas redondeadas',
        badgeText: '⚡ Syncfusion #17',
        height: 220,
        chart: AppRadialBarChart(data: radialData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '17. Radial Bar Chart (Graphic)',
        subtitle: 'CustomPainter concéntrico de métricas clave',
        badgeText: '📊 Graphic #17',
        height: 220,
        chart: GraphicRadialBarChart(data: radialData),
      ));
    }
    return items;
  }

  List<Widget> _chart18Scatter(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const scatterData = [
      {'label': 'BTC', 'x': 1680, 'y': 0.34, 'size': 12, 'group': 'Alta'},
      {'label': 'ETH', 'x': 327, 'y': 0.10, 'size': 10, 'group': 'Alta'},
      {'label': 'SOL', 'x': 63, 'y': 1.75, 'size': 10, 'group': 'Media'},
      {'label': 'TRX', 'x': 32, 'y': -1.39, 'size': 8, 'group': 'Baja'},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '18. Scatter Plot (Syncfusion)',
        subtitle: 'ScatterSeries mapeando Market Cap vs Retorno 24h',
        badgeText: '⚡ Syncfusion #18',
        height: 210,
        chart: AppScatterChart(data: scatterData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '18. Scatter Plot (Graphic)',
        subtitle: 'PointMark() mapeando variables X e Y independientes',
        badgeText: '📊 Graphic #18',
        height: 210,
        chart: GraphicScatterChart(data: scatterData),
      ));
    }
    return items;
  }

  List<Widget> _chart19Bubble(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const bubbleData = [
      {'label': 'BTC', 'x': 1680, 'y': 0.34, 'size': 32, 'group': 'Top 1'},
      {'label': 'ETH', 'x': 327, 'y': 0.10, 'size': 20, 'group': 'Top 2'},
      {'label': 'XRP', 'x': 91, 'y': 2.42, 'size': 15, 'group': 'Top 5'},
      {'label': 'SOL', 'x': 63, 'y': 1.75, 'size': 16, 'group': 'Top 10'},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '19. Bubble Chart (Syncfusion)',
        subtitle: 'BubbleSeries de 3 dimensiones con tamaño por volumen',
        badgeText: '⚡ Syncfusion #19',
        height: 210,
        chart: AppBubbleChart(data: bubbleData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '19. Bubble Chart (Graphic)',
        subtitle: '3 Dimensiones: Market Cap (X) vs Retorno (Y) vs Volumen (Radio)',
        badgeText: '📊 Graphic #19',
        height: 210,
        chart: GraphicBubbleChart(data: bubbleData),
      ));
    }
    return items;
  }

  List<Widget> _chart20Radar(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const radarData = [
      {'metric': 'Volumen', 'value': 88},
      {'metric': 'Cap. Mercado', 'value': 96},
      {'metric': 'Cercanía ATH', 'value': 82},
      {'metric': 'Impulso 24h', 'value': 65},
      {'metric': 'Comunidad', 'value': 90},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '20. Radar / Spider Chart (Syncfusion)',
        subtitle: 'SplineAreaSeries polar delimitada al contenedor',
        badgeText: '⚡ Syncfusion #20',
        height: 220,
        chart: AppRadarChart(data: radarData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '20. Radar / Spider Chart (Graphic)',
        subtitle: 'Polígono multidimensional cerrado dentro de su caja de límites',
        badgeText: '📊 Graphic #20',
        height: 220,
        chart: GraphicRadarChart(data: radarData),
      ));
    }
    return items;
  }

  List<Widget> _chart21Heatmap(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const heatmapData = [
      {'x': 'Lun', 'y': 'Madrugada', 'value': -1.2},
      {'x': 'Lun', 'y': 'Mañana', 'value': 2.4},
      {'x': 'Lun', 'y': 'Tarde', 'value': 0.8},
      {'x': 'Mar', 'y': 'Madrugada', 'value': -0.4},
      {'x': 'Mar', 'y': 'Mañana', 'value': -1.8},
      {'x': 'Mar', 'y': 'Tarde', 'value': 3.1},
      {'x': 'Mié', 'y': 'Madrugada', 'value': 1.5},
      {'x': 'Mié', 'y': 'Mañana', 'value': 0.5},
      {'x': 'Mié', 'y': 'Tarde', 'value': 2.0},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '21. Heatmap / Matriz de Calor (Syncfusion Hub)',
        subtitle: 'Matriz horaria con escala de color semántica normalizada',
        badgeText: '⚡ Syncfusion #21',
        height: 210,
        chart: AppHeatmapChart(data: heatmapData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '21. Heatmap / Matriz de Calor (Graphic)',
        subtitle: 'PolygonMark() en RectCoord() con escala de color normalizada',
        badgeText: '📊 Graphic #21',
        height: 210,
        chart: GraphicHeatmapChart(data: heatmapData),
      ));
    }
    return items;
  }

  List<Widget> _chart22BoxPlot(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const boxData = [
      {'asset': 'BTC', 'min': -4.2, 'q1': -1.8, 'median': 0.5, 'q3': 2.1, 'max': 5.3},
      {'asset': 'ETH', 'min': -6.1, 'q1': -2.4, 'median': 0.2, 'q3': 3.0, 'max': 7.8},
      {'asset': 'SOL', 'min': -8.5, 'q1': -3.2, 'median': 1.1, 'q3': 4.5, 'max': 11.2},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '22. BoxPlot (Syncfusion)',
        subtitle: 'BoxAndWhiskerSeries nativo con resumen de 5 puntos',
        badgeText: '⚡ Syncfusion #22',
        height: 220,
        chart: AppBoxPlotChart(data: boxData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '22. BoxPlot (Graphic)',
        subtitle: 'CustomMark con BoxPlotShape en Gramática de Gráficos',
        badgeText: '📊 Graphic #22',
        height: 220,
        chart: GraphicBoxPlotChart(data: boxData),
      ));
    }
    return items;
  }

  List<Widget> _chart23Histogram(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const histData = [
      {'bin': '0-2%', 'frequency': 14},
      {'bin': '2-4%', 'frequency': 28},
      {'bin': '4-6%', 'frequency': 42},
      {'bin': '6-8%', 'frequency': 22},
      {'bin': '8-10%', 'frequency': 9},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '23. Histograma de Frecuencia (Syncfusion)',
        subtitle: 'Barras contiguas sin espacio entre clases estadísticas',
        badgeText: '⚡ Syncfusion #23',
        height: 200,
        chart: AppHistogramChart(data: histData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '23. Histograma de Frecuencia (Graphic)',
        subtitle: 'IntervalMark con clases contiguas y conteo estadístico',
        badgeText: '📊 Graphic #23',
        height: 200,
        chart: GraphicHistogramChart(data: histData),
      ));
    }
    return items;
  }

  List<Widget> _chart24Violin(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const violinData = [
      {'level': '-3%', 'density': 10},
      {'level': '-2%', 'density': 25},
      {'level': '-1%', 'density': 50},
      {'level': '0%', 'density': 90},
      {'level': '+1%', 'density': 70},
      {'level': '+2%', 'density': 30},
      {'level': '+3%', 'density': 12},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '24. Violin Plot (Syncfusion)',
        subtitle: 'Curvas SplineArea simétricas de densidad probabilística',
        badgeText: '⚡ Syncfusion #24',
        height: 200,
        chart: AppViolinPlotChart(data: violinData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '24. Violin Plot (Graphic)',
        subtitle: 'Curvas Bezier simétricas de densidad probabilística',
        badgeText: '📊 Graphic #24',
        height: 200,
        chart: GraphicViolinPlotChart(data: violinData),
      ));
    }
    return items;
  }

  List<Widget> _chart25Treemap(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const treeData = [
      {'symbol': 'BTC', 'name': 'Bitcoin', 'value': 1680, 'change': 0.34, 'price': 84206.0},
      {'symbol': 'ETH', 'name': 'Ethereum', 'value': 327, 'change': 0.10, 'price': 2677.0},
      {'symbol': 'SOL', 'name': 'Solana', 'value': 63, 'change': 1.75, 'price': 116.6},
      {'symbol': 'USDT', 'name': 'Tether', 'value': 183, 'change': -0.07, 'price': 1.0},
      {'symbol': 'BNB', 'name': 'Binance', 'value': 107, 'change': 0.69, 'price': 773.2},
      {'symbol': 'XRP', 'name': 'Ripple', 'value': 91, 'change': 2.42, 'price': 1.53},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '25. Treemap / Mosaic Chart (Syncfusion Hub)',
        subtitle: 'Mosaico proporcional a capitalización y variación 24h',
        badgeText: '⚡ Syncfusion #25',
        height: 210,
        chart: AppTreemapChart(data: treeData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '25. Treemap / Mosaic Chart (Graphic)',
        subtitle: 'Mosaico financiero proporcional al Market Cap con Graphic',
        badgeText: '📊 Graphic #25',
        height: 210,
        chart: GraphicTreemapChart(data: treeData),
      ));
    }
    return items;
  }

  List<Widget> _chart26Sunburst(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const sunData = [
      {'name': 'Capa 1', 'value': 55},
      {'name': 'DeFi', 'value': 22},
      {'name': 'Stablecoins', 'value': 13},
      {'name': 'IA & Datos', 'value': 10},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '26. Sunburst Chart (Syncfusion)',
        subtitle: 'RadialBarSeries concéntrico con jerarquía sectorial',
        badgeText: '⚡ Syncfusion #26',
        height: 210,
        chart: AppSunburstChart(data: sunData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '26. Sunburst Chart (Graphic)',
        subtitle: 'Anillos concéntricos proporcionales estrictamente delimitados',
        badgeText: '📊 Graphic #26',
        height: 210,
        chart: GraphicSunburstChart(data: sunData),
      ));
    }
    return items;
  }

  List<Widget> _chart27Funnel(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const funnelData = [
      {'stage': '1. Impresiones', 'value': 10000},
      {'stage': '2. Visitas Par', 'value': 6200},
      {'stage': '3. Órdenes Creadas', 'value': 3400},
      {'stage': '4. Trades Ejecutados', 'value': 2100},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '27. Funnel / Embudo (Syncfusion)',
        subtitle: 'SfFunnelChart nativo de conversión de órdenes',
        badgeText: '⚡ Syncfusion #27',
        height: 260,
        chart: AppFunnelChart(data: funnelData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '27. Funnel / Embudo (Graphic)',
        subtitle: 'Etapas de conversión financiera — trapezoides proporcionales',
        badgeText: '📊 Graphic #27',
        height: 260,
        chart: GraphicFunnelChart(data: funnelData),
      ));
    }
    return items;
  }

  List<Widget> _chart28Parallel(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const parallelData = [
      {'crypto': 'BTC', 'metric': 'Volumen', 'score': 95},
      {'crypto': 'BTC', 'metric': 'Cap', 'score': 100},
      {'crypto': 'BTC', 'metric': 'ATH', 'score': 88},
      {'crypto': 'BTC', 'metric': '24h', 'score': 60},
      {'crypto': 'ETH', 'metric': 'Volumen', 'score': 75},
      {'crypto': 'ETH', 'metric': 'Cap', 'score': 68},
      {'crypto': 'ETH', 'metric': 'ATH', 'score': 62},
      {'crypto': 'ETH', 'metric': '24h', 'score': 55},
      {'crypto': 'SOL', 'metric': 'Volumen', 'score': 50},
      {'crypto': 'SOL', 'metric': 'Cap', 'score': 45},
      {'crypto': 'SOL', 'metric': 'ATH', 'score': 70},
      {'crypto': 'SOL', 'metric': '24h', 'score': 85},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '28. Coordenadas Paralelas (Syncfusion)',
        subtitle: 'SplineSeries continuas multidimensionales',
        badgeText: '⚡ Syncfusion #28',
        height: 220,
        chart: AppParallelCoordChart(data: parallelData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '28. Coordenadas Paralelas (Graphic)',
        subtitle: 'Líneas continuas multidimensionales comparando activos',
        badgeText: '📊 Graphic #28',
        height: 220,
        chart: GraphicParallelCoordChart(data: parallelData),
      ));
    }
    return items;
  }

  List<Widget> _chart29ScatterMatrix(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const matrixData = [
      {'token': 'BTC', 'pair': 'Cap vs Vol', 'correlation': 0.88},
      {'token': 'BTC', 'pair': 'Vol vs 24h', 'correlation': 0.45},
      {'token': 'BTC', 'pair': 'Cap vs 24h', 'correlation': 0.62},
      {'token': 'ETH', 'pair': 'Cap vs Vol', 'correlation': 0.79},
      {'token': 'ETH', 'pair': 'Vol vs 24h', 'correlation': 0.38},
      {'token': 'ETH', 'pair': 'Cap vs 24h', 'correlation': 0.51},
      {'token': 'SOL', 'pair': 'Cap vs Vol', 'correlation': 0.65},
      {'token': 'SOL', 'pair': 'Vol vs 24h', 'correlation': 0.72},
      {'token': 'SOL', 'pair': 'Cap vs 24h', 'correlation': 0.69},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '29. Matriz de Dispersión (Syncfusion Hub)',
        subtitle: 'Matriz cruzando correlaciones con burbujas y escala de color',
        badgeText: '⚡ Syncfusion #29',
        height: 220,
        chart: AppScatterMatrixChart(data: matrixData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '29. Matriz de Dispersión (Graphic)',
        subtitle: 'Burbujas en cuadrícula cruzando correlaciones financieras',
        badgeText: '📊 Graphic #29',
        height: 220,
        chart: GraphicScatterMatrixChart(data: matrixData),
      ));
    }
    return items;
  }

  List<Widget> _chart30BandArea(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const bandData = [
      {'time': '10:00', 'price': 84100, 'upper': 84700, 'lower': 83500},
      {'time': '12:00', 'price': 84350, 'upper': 84900, 'lower': 83700},
      {'time': '14:00', 'price': 83900, 'upper': 84600, 'lower': 83300},
      {'time': '16:00', 'price': 84500, 'upper': 85100, 'lower': 83900},
      {'time': '18:00', 'price': 84750, 'upper': 85400, 'lower': 84100},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '30. Band Chart / Bollinger (Syncfusion)',
        subtitle: 'RangeAreaSeries entre bandas superior e inferior',
        badgeText: '⚡ Syncfusion #30',
        height: 210,
        chart: AppBandAreaChart(data: bandData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '30. Band Chart / Bollinger (Graphic)',
        subtitle: 'AreaMark sombreada entre límites superior e inferior',
        badgeText: '📊 Graphic #30',
        height: 210,
        chart: GraphicBandAreaChart(data: bandData),
      ));
    }
    return items;
  }

  List<Widget> _chart31Candlestick(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const ohlcData = [
      {'date': '09:00', 'open': 83800, 'close': 84200, 'high': 84500, 'low': 83600},
      {'date': '10:00', 'open': 84200, 'close': 84000, 'high': 84350, 'low': 83900},
      {'date': '11:00', 'open': 84000, 'close': 84450, 'high': 84600, 'low': 83950},
      {'date': '12:00', 'open': 84450, 'close': 84150, 'high': 84500, 'low': 84050},
      {'date': '13:00', 'open': 84150, 'close': 84650, 'high': 84800, 'low': 84100},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '31. Candlestick OHLC (Syncfusion)',
        subtitle: 'CandleSeries nativa con mechas y cuerpos de negociación',
        badgeText: '⚡ Syncfusion #31',
        isPositiveBadge: true,
        height: 220,
        chart: AppCandlestickChart(data: ohlcData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '31. Candlestick OHLC (Graphic)',
        subtitle: 'CustomMark con CandlestickShape (Open, Close, High, Low)',
        badgeText: '📊 Graphic #31',
        isPositiveBadge: true,
        height: 220,
        chart: GraphicCandlestickChart(data: ohlcData),
      ));
    }
    return items;
  }

  List<Widget> _chart32Streamgraph(ChartThemeTokens tokens, bool showSf, bool showGr) {
    const streamData = [
      {'date': '00:00', 'type': 'BTC', 'value': 28},
      {'date': '03:00', 'type': 'BTC', 'value': 32},
      {'date': '06:00', 'type': 'BTC', 'value': 38},
      {'date': '09:00', 'type': 'BTC', 'value': 45},
      {'date': '12:00', 'type': 'BTC', 'value': 42},
      {'date': '15:00', 'type': 'BTC', 'value': 50},
      {'date': '18:00', 'type': 'BTC', 'value': 46},
      {'date': '21:00', 'type': 'BTC', 'value': 40},
      {'date': '00:00', 'type': 'ETH', 'value': 14},
      {'date': '03:00', 'type': 'ETH', 'value': 18},
      {'date': '06:00', 'type': 'ETH', 'value': 22},
      {'date': '09:00', 'type': 'ETH', 'value': 28},
      {'date': '12:00', 'type': 'ETH', 'value': 26},
      {'date': '15:00', 'type': 'ETH', 'value': 30},
      {'date': '18:00', 'type': 'ETH', 'value': 24},
      {'date': '21:00', 'type': 'ETH', 'value': 18},
      {'date': '00:00', 'type': 'SOL', 'value': 5},
      {'date': '03:00', 'type': 'SOL', 'value': 8},
      {'date': '06:00', 'type': 'SOL', 'value': 10},
      {'date': '09:00', 'type': 'SOL', 'value': 14},
      {'date': '12:00', 'type': 'SOL', 'value': 16},
      {'date': '15:00', 'type': 'SOL', 'value': 18},
      {'date': '18:00', 'type': 'SOL', 'value': 15},
      {'date': '21:00', 'type': 'SOL', 'value': 12},
    ];
    final items = <Widget>[];
    if (showSf) {
      items.add(const AppChartCard(
        title: '32. Streamgraph (Syncfusion)',
        subtitle: 'StackedAreaSeries de flujo de volumen continuo 24h',
        badgeText: '⚡ Syncfusion #32',
        height: 220,
        chart: AppStreamgraphChart(data: streamData),
      ));
    }
    if (showGr) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(const AppChartCard(
        title: '32. Streamgraph (Graphic)',
        subtitle: 'AreaMark + StackModifier + SymmetricModifier — Volumen 24h',
        badgeText: '📊 Graphic #32',
        height: 220,
        chart: GraphicStreamgraphChart(data: streamData),
      ));
    }
    return items;
  }
}
