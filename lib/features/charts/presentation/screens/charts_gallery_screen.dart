import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/settings_provider.dart';
import '../../charts.dart'; // <-- barrel, para tener acceso a AppChartCard, ChartPoint, etc.

/// Catálogo y Centro de Visualización de Gráficos (Analytics Hub).
/// Muestra los 20 gráficos básicos y los 12 gráficos avanzados construidos
/// con la Gramática de Gráficos (Graphic 2.7.0).
class ChartsGalleryScreen extends ConsumerStatefulWidget {
  const ChartsGalleryScreen({super.key});

  @override
  ConsumerState<ChartsGalleryScreen> createState() =>
      _ChartsGalleryScreenState();
}

class _ChartsGalleryScreenState extends ConsumerState<ChartsGalleryScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Todos (32)',
    '📈 Líneas & Áreas (6)',
    '📊 Barras & Columnas (6)',
    '🍩 Circulares & Radiales (5)',
    '🎯 Puntos & Radar (2)',
    '🔬 Avanzados (12)',
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
              'Centro de Gráficos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Catálogo Gramatical Completo • 32 Gráficos',
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
          // Selector horizontal de categorías
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
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

          // Lista de Gráficos Filtrados
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildFilteredCharts(tokens),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CommunityChartsGalleryScreen(),
            ),
          );
        },
        icon: const Icon(Icons.auto_graph),
        label: const Text('Community'),
        tooltip: 'Ver los 32 gráficos con community_charts_flutter',
      ),
    );
  }

  List<Widget> _buildFilteredCharts(ChartThemeTokens tokens) {
    final widgets = <Widget>[];

    // 1. Líneas y Áreas (6)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 1) {
      widgets.add(_buildSectionHeader(
          '1. Líneas y Áreas (6)', 'Evolución continua y series temporales'));
      widgets.add(_chart1StandardLine(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart2SmoothArea(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart3StepLine(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart4GradientArea(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart5MultiLine(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart6BaselineArea(tokens));
      widgets.add(const SizedBox(height: 24));
    }

    // 2. Barras y Columnas (6)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 2) {
      widgets.add(_buildSectionHeader('2. Barras y Columnas (6)',
          'Comparativas categóricas y acumulaciones'));
      widgets.add(_chart7VerticalBar(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart8HorizontalBar(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart9GroupedBar(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart10StackedBar(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart11NormalizedBar(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart12RangeBar(tokens));
      widgets.add(const SizedBox(height: 24));
    }

    // 3. Circulares y Radiales (5)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 3) {
      widgets.add(_buildSectionHeader('3. Circulares y Radiales (5)',
          'Proporciones, dominancia y ángulos polares'));
      widgets.add(_chart13Pie(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart14Donut(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart15Gauge(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart16Rose(tokens));
      widgets.add(const SizedBox(height: 16));
    }

    // 4. Puntos y Radar (3)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 4) {
      widgets.add(_buildSectionHeader('4. Puntos y Radar (3)',
          'Dispersión multidimensional y perfiles polares'));
      widgets.add(_chart18Scatter(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart19Bubble(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart20Radar(tokens));
      widgets.add(const SizedBox(height: 24));
    }

    // 5. Avanzados (12)
    if (_selectedCategoryIndex == 0 || _selectedCategoryIndex == 5) {
      widgets.add(_buildSectionHeader(
          '5. Avanzados: Estadísticos y Densidad (4)',
          'Distribuciones y probabilidad'));
      widgets.add(_chart21Heatmap(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart22BoxPlot(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart23Histogram(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart24Violin(tokens));
      widgets.add(const SizedBox(height: 24));

      widgets.add(_buildSectionHeader(
          '6. Avanzados: Jerárquicos y Proporción (3)',
          'Relaciones parte-todo y flujos'));
      widgets.add(_chart25Treemap(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart26Sunburst(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart27Funnel(tokens));
      widgets.add(const SizedBox(height: 24));

      widgets.add(_buildSectionHeader(
          '7. Avanzados: Multidimensionales y Continuos (3)',
          'Correlaciones y bandas'));
      widgets.add(_chart28Parallel(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart29ScatterMatrix(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart30BandArea(tokens));
      widgets.add(const SizedBox(height: 24));

      widgets.add(_buildSectionHeader('8. Avanzados: Financieros y Flujo (2)',
          'Trading y evolución orgánica'));
      widgets.add(_chart31Candlestick(tokens));
      widgets.add(const SizedBox(height: 16));
      widgets.add(_chart32Streamgraph(tokens));
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

  // -------------------------------------------------------------
  // DEFINICIÓN DE LOS 32 GRÁFICOS
  // -------------------------------------------------------------

  Widget _chart1StandardLine(ChartThemeTokens tokens) {
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
      subtitle: 'LineMark() en RectCoord()',
      badgeText: 'Básico #1',
      height: 200,
      chart: AppStandardLineChart(data: points, color: tokens.primaryColor),
    );
  }

  Widget _chart2SmoothArea(ChartThemeTokens tokens) {
    const points = [
      ChartPoint(x: 'Lun', y: 81200),
      ChartPoint(x: 'Mar', y: 82500),
      ChartPoint(x: 'Mié', y: 81900),
      ChartPoint(x: 'Jue', y: 83400),
      ChartPoint(x: 'Vie', y: 82800),
      ChartPoint(x: 'Sáb', y: 84100),
      ChartPoint(x: 'Dom', y: 84600),
    ];
    return const AppChartCard(
      title: '2. Smooth Line & Area Chart',
      subtitle: 'AreaMark + LineMark con BasicAreaShape(smooth: true)',
      badgeText: '+4.18%',
      isPositiveBadge: true,
      height: 200,
      chart: AppSmoothAreaChart(data: points, isBullish: true),
    );
  }

  Widget _chart3StepLine(ChartThemeTokens tokens) {
    const stepData = [
      ChartPoint(x: '00:00', y: 83200),
      ChartPoint(x: '04:00', y: 83200),
      ChartPoint(x: '08:00', y: 83800),
      ChartPoint(x: '12:00', y: 84400),
      ChartPoint(x: '16:00', y: 84100),
      ChartPoint(x: '20:00', y: 84600),
    ];
    return AppChartCard(
      title: '3. Step Line Chart (Línea Escalonada)',
      subtitle: 'LineMark con BasicLineShape(stepped: true)',
      badgeText: 'Básico #3',
      height: 200,
      chart: AppStepLineChart(data: stepData, color: tokens.secondaryColor),
    );
  }

  Widget _chart4GradientArea(ChartThemeTokens tokens) {
    const points = [
      ChartPoint(x: 'Ene', y: 62000),
      ChartPoint(x: 'Feb', y: 69000),
      ChartPoint(x: 'Mar', y: 74000),
      ChartPoint(x: 'Abr', y: 84500),
    ];
    return const AppChartCard(
      title: '4. Gradient Area Chart',
      subtitle: 'AreaMark con GradientEncode lineal vertical',
      badgeText: 'Básico #4',
      isPositiveBadge: true,
      height: 200,
      chart: AppGradientAreaChart(data: points, isBullish: true),
    );
  }

  Widget _chart5MultiLine(ChartThemeTokens tokens) {
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
    return const AppChartCard(
      title: '5. Multi-Line Chart (Comparativa)',
      subtitle: "LineMark con Varset('x') * Varset('y') / Varset('series')",
      badgeText: '3 Series',
      height: 210,
      chart: AppMultiLineChart(data: multiData),
    );
  }

  Widget _chart6BaselineArea(ChartThemeTokens tokens) {
    const baselineData = [
      ChartPoint(x: '00:00', y: 83600),
      ChartPoint(x: '04:00', y: 83900),
      ChartPoint(x: '08:00', y: 84350),
      ChartPoint(x: '12:00', y: 84700),
      ChartPoint(x: '16:00', y: 84200),
      ChartPoint(x: '20:00', y: 83800),
      ChartPoint(x: '24:00', y: 84500),
    ];
    return const AppChartCard(
      title: '6. Baseline Area (Diferencia sobre Umbral)',
      subtitle:
          'Área condicional: verde sobre umbral (\$84.0k) y roja por debajo',
      badgeText: 'Umbral \$84k',
      isPositiveBadge: true,
      height: 200,
      chart: AppBaselineAreaChart(data: baselineData, baseline: 84000.0),
    );
  }

  Widget _chart7VerticalBar(ChartThemeTokens tokens) {
    const barData = [
      ChartPoint(x: 'BTC', y: 30.5),
      ChartPoint(x: 'ETH', y: 12.4),
      ChartPoint(x: 'USDT', y: 65.9),
      ChartPoint(x: 'BNB', y: 0.7),
      ChartPoint(x: 'SOL', y: 3.3),
    ];
    return AppChartCard(
      title: '7. Vertical Bar / Column Chart',
      subtitle: 'IntervalMark con RectCoord() - Volumen 24h (\$B)',
      badgeText: 'Básico #7',
      height: 200,
      chart: AppBarChart(data: barData, barColor: tokens.accentColor),
    );
  }

  Widget _chart8HorizontalBar(ChartThemeTokens tokens) {
    const rankData = [
      ChartPoint(x: 'BTC', y: 1680),
      ChartPoint(x: 'ETH', y: 327),
      ChartPoint(x: 'USDT', y: 183),
      ChartPoint(x: 'BNB', y: 107),
      ChartPoint(x: 'SOL', y: 63),
    ];
    return AppChartCard(
      title: '8. Horizontal Bar Chart (Ranking)',
      subtitle: 'IntervalMark con RectCoord(transposed: true)',
      badgeText: 'Top Cap',
      height: 210,
      chart: AppBarChart(
          data: rankData, isHorizontal: true, barColor: tokens.primaryColor),
    );
  }

  Widget _chart9GroupedBar(ChartThemeTokens tokens) {
    const groupedData = [
      {'category': 'BTC', 'group': 'Spot', 'value': 28},
      {'category': 'BTC', 'group': 'Derivados', 'value': 45},
      {'category': 'ETH', 'group': 'Spot', 'value': 12},
      {'category': 'ETH', 'group': 'Derivados', 'value': 24},
      {'category': 'SOL', 'group': 'Spot', 'value': 4},
      {'category': 'SOL', 'group': 'Derivados', 'value': 9},
    ];
    return const AppChartCard(
      title: '9. Grouped Bar Chart (Agrupadas)',
      subtitle: 'IntervalMark con DodgeModifier()',
      badgeText: 'Básico #9',
      height: 210,
      chart: AppGroupedBarChart(data: groupedData),
    );
  }

  Widget _chart10StackedBar(ChartThemeTokens tokens) {
    const stackedData = [
      {'category': 'Q1', 'type': 'DeFi', 'value': 35},
      {'category': 'Q1', 'type': 'CeFi', 'value': 65},
      {'category': 'Q2', 'type': 'DeFi', 'value': 45},
      {'category': 'Q2', 'type': 'CeFi', 'value': 55},
      {'category': 'Q3', 'type': 'DeFi', 'value': 52},
      {'category': 'Q3', 'type': 'CeFi', 'value': 48},
    ];
    return const AppChartCard(
      title: '10. Stacked Bar Chart (Apiladas)',
      subtitle: 'IntervalMark con StackModifier()',
      badgeText: 'Básico #10',
      height: 210,
      chart: AppStackedBarChart(data: stackedData),
    );
  }

  Widget _chart11NormalizedBar(ChartThemeTokens tokens) {
    const normData = [
      {'category': 'Minado', 'segment': 'Circulante', 'percent': 93.5},
      {'category': 'Minado', 'segment': 'Por Emitir', 'percent': 6.5},
      {'category': 'Staking', 'segment': 'Bloqueado', 'percent': 28.0},
      {'category': 'Staking', 'segment': 'Libre', 'percent': 72.0},
    ];
    return const AppChartCard(
      title: '11. Normalized Stacked Bar (100% Apilado)',
      subtitle: 'Barras proporcionales a escala 100% por categoría y segmento',
      badgeText: '100% Apilado',
      height: 200,
      chart: AppNormalizedBarChart(data: normData),
    );
  }

  Widget _chart12RangeBar(ChartThemeTokens tokens) {
    // Datos en variación % 24h para que todas las barras sean comparables
    const rangeData = [
      {'crypto': 'BTC', 'min': -1.4, 'max': 2.8},
      {'crypto': 'ETH', 'min': -2.1, 'max': 3.5},
      {'crypto': 'SOL', 'min': -3.2, 'max': 5.1},
      {'crypto': 'BNB', 'min': -1.0, 'max': 2.2},
      {'crypto': 'XRP', 'min': 0.5, 'max': 4.8},
    ];
    return const AppChartCard(
      title: '12. Range / Floating Bar Chart',
      subtitle:
          'IntervalMark() suspendido: rango de variación % 24h por activo',
      badgeText: 'Rangos %',
      height: 210,
      chart: AppRangeBarChart(data: rangeData),
    );
  }

  Widget _chart13Pie(ChartThemeTokens tokens) {
    const pieData = [
      ChartPoint(x: 'BTC', y: 58),
      ChartPoint(x: 'ETH', y: 15),
      ChartPoint(x: 'USDT', y: 12),
      ChartPoint(x: 'Otros', y: 15),
    ];
    return const AppChartCard(
      title: '13. Pie Chart (Torta Completa)',
      subtitle: 'IntervalMark + StackModifier en PolarCoord(startRadius: 0)',
      badgeText: 'Básico #13',
      height: 200,
      chart: AppPieChart(data: pieData),
    );
  }

  Widget _chart14Donut(ChartThemeTokens tokens) {
    const donutData = [
      ChartPoint(x: 'BTC (58%)', y: 58.2),
      ChartPoint(x: 'ETH (14%)', y: 14.1),
      ChartPoint(x: 'Stable (12%)', y: 12.0),
      ChartPoint(x: 'Alt (16%)', y: 15.7),
    ];
    return const AppChartCard(
      title: '14. Donut Chart (Dona)',
      subtitle: 'IntervalMark en PolarCoord con startRadius: 0.45',
      badgeText: 'Dominancia',
      height: 200,
      chart: AppDonutChart(data: donutData),
    );
  }

  Widget _chart15Gauge(ChartThemeTokens tokens) {
    return const AppChartCard(
      title: '15. Semicircle Gauge (Velocímetro)',
      subtitle: 'PolarCoord limitado a 180° [-pi, 0]',
      badgeText: 'Índice 68',
      isPositiveBadge: true,
      height: 180,
      chart: AppGaugeChart(score: 68),
    );
  }

  Widget _chart16Rose(ChartThemeTokens tokens) {
    const roseData = [
      ChartPoint(x: 'Seguridad', y: 92),
      ChartPoint(x: 'Liquidez', y: 85),
      ChartPoint(x: 'Descentralización', y: 78),
      ChartPoint(x: 'Rendimiento', y: 64),
      ChartPoint(x: 'Adopción', y: 88),
    ];
    return const AppChartCard(
      title: '16. Nightingale Rose Chart',
      subtitle:
          'Pétalos con radio proporcional al score delimitado estrictamente',
      badgeText: 'Básico #16',
      height: 220,
      chart: AppRoseChart(data: roseData),
    );
  }

  Widget _chart18Scatter(ChartThemeTokens tokens) {
    const scatterData = [
      {'label': 'BTC', 'x': 1680, 'y': 0.34, 'size': 12, 'group': 'Alta'},
      {'label': 'ETH', 'x': 327, 'y': 0.10, 'size': 10, 'group': 'Alta'},
      {'label': 'SOL', 'x': 63, 'y': 1.75, 'size': 10, 'group': 'Media'},
      {'label': 'TRX', 'x': 32, 'y': -1.39, 'size': 8, 'group': 'Baja'},
    ];
    return const AppChartCard(
      title: '18. Scatter Plot (Dispersión)',
      subtitle: 'PointMark() mapeando variables X e Y independientes',
      badgeText: 'Básico #18',
      height: 210,
      chart: AppScatterChart(data: scatterData),
    );
  }

  Widget _chart19Bubble(ChartThemeTokens tokens) {
    const bubbleData = [
      {'label': 'BTC', 'x': 1680, 'y': 0.34, 'size': 32, 'group': 'Top 1'},
      {'label': 'ETH', 'x': 327, 'y': 0.10, 'size': 20, 'group': 'Top 2'},
      {'label': 'XRP', 'x': 91, 'y': 2.42, 'size': 15, 'group': 'Top 5'},
      {'label': 'SOL', 'x': 63, 'y': 1.75, 'size': 16, 'group': 'Top 10'},
    ];
    return const AppChartCard(
      title: '19. Bubble Chart (Burbujas Financieras)',
      subtitle:
          '3 Dimensiones: Market Cap (X) vs Retorno 24h (Y) vs Volumen (Radio)',
      badgeText: '3 Dimensiones',
      height: 210,
      chart: AppBubbleChart(data: bubbleData),
    );
  }

  Widget _chart20Radar(ChartThemeTokens tokens) {
    const radarData = [
      {'metric': 'Volumen', 'value': 88},
      {'metric': 'Cap. Mercado', 'value': 96},
      {'metric': 'Cercanía ATH', 'value': 82},
      {'metric': 'Impulso 24h', 'value': 65},
      {'metric': 'Comunidad', 'value': 90},
    ];
    return const AppChartCard(
      title: '20. Radar / Spider Chart (Perfil Polar)',
      subtitle:
          'Polígono multidimensional cerrado dentro de su caja de límites',
      badgeText: 'Perfil #20',
      height: 220,
      chart: AppRadarChart(data: radarData),
    );
  }

  Widget _chart21Heatmap(ChartThemeTokens tokens) {
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
    return const AppChartCard(
      title: '21. Heatmap / Matriz de Calor',
      subtitle:
          'Matriz de retornos horarios por sesión con escala de color normalizada',
      badgeText: 'Avanzado #21',
      height: 210,
      chart: AppHeatmapChart(data: heatmapData),
    );
  }

  Widget _chart22BoxPlot(ChartThemeTokens tokens) {
    // Datos en variación % semanal para escala uniforme y visible
    const boxData = [
      {
        'asset': 'BTC',
        'min': -4.2,
        'q1': -1.8,
        'median': 0.5,
        'q3': 2.1,
        'max': 5.3
      },
      {
        'asset': 'ETH',
        'min': -6.1,
        'q1': -2.4,
        'median': 0.2,
        'q3': 3.0,
        'max': 7.8
      },
      {
        'asset': 'SOL',
        'min': -8.5,
        'q1': -3.2,
        'median': 1.1,
        'q3': 4.5,
        'max': 11.2
      },
    ];
    return const AppChartCard(
      title: '22. BoxPlot (Caja y Bigotes)',
      subtitle: 'Resumen de 5 puntos: variación % semanal por activo',
      badgeText: 'Estadístico #22',
      height: 220,
      chart: AppBoxPlotChart(data: boxData),
    );
  }

  Widget _chart23Histogram(ChartThemeTokens tokens) {
    const histData = [
      {'bin': '0-2%', 'frequency': 14},
      {'bin': '2-4%', 'frequency': 28},
      {'bin': '4-6%', 'frequency': 42},
      {'bin': '6-8%', 'frequency': 22},
      {'bin': '8-10%', 'frequency': 9},
    ];
    return const AppChartCard(
      title: '23. Histograma de Frecuencia',
      subtitle: 'Barras contiguas con frecuencias estadísticas sobre eje',
      badgeText: 'Avanzado #23',
      height: 200,
      chart: AppHistogramChart(data: histData),
    );
  }

  Widget _chart24Violin(ChartThemeTokens tokens) {
    const violinData = [
      {'level': '-3%', 'density': 10},
      {'level': '-2%', 'density': 25},
      {'level': '-1%', 'density': 50},
      {'level': '0%', 'density': 90},
      {'level': '+1%', 'density': 70},
      {'level': '+2%', 'density': 30},
      {'level': '+3%', 'density': 12},
    ];
    return const AppChartCard(
      title: '24. Violin Plot (Densidad Simétrica)',
      subtitle:
          'Curvas Bezier simétricas para densidad probabilística de retorno',
      badgeText: 'Probabilidad #24',
      height: 200,
      chart: AppViolinPlotChart(data: violinData),
    );
  }

  Widget _chart25Treemap(ChartThemeTokens tokens) {
    const treeData = [
      {
        'symbol': 'BTC',
        'name': 'Bitcoin',
        'value': 1680,
        'change': 0.34,
        'price': 84206.0
      },
      {
        'symbol': 'ETH',
        'name': 'Ethereum',
        'value': 327,
        'change': 0.10,
        'price': 2677.0
      },
      {
        'symbol': 'SOL',
        'name': 'Solana',
        'value': 63,
        'change': 1.75,
        'price': 116.6
      },
      {
        'symbol': 'USDT',
        'name': 'Tether',
        'value': 183,
        'change': -0.07,
        'price': 1.0
      },
      {
        'symbol': 'BNB',
        'name': 'Binance',
        'value': 107,
        'change': 0.69,
        'price': 773.2
      },
      {
        'symbol': 'XRP',
        'name': 'Ripple',
        'value': 91,
        'change': 2.42,
        'price': 1.53
      },
    ];
    return const AppChartCard(
      title: '25. Treemap / Mosaic Chart',
      subtitle:
          'Mosaico financiero proporcional al Market Cap y color por variación 24h',
      badgeText: 'Mapa Mercado #25',
      height: 210,
      chart: AppTreemapChart(data: treeData),
    );
  }

  Widget _chart26Sunburst(ChartThemeTokens tokens) {
    const sunData = [
      {'name': 'Capa 1', 'value': 55},
      {'name': 'DeFi', 'value': 22},
      {'name': 'Stablecoins', 'value': 13},
      {'name': 'IA & Datos', 'value': 10},
    ];
    return const AppChartCard(
      title: '26. Sunburst Chart (Anillos Jerárquicos)',
      subtitle:
          'Anillos concéntricos proporcionales estrictamente delimitados a la caja',
      badgeText: 'Jerárquico #26',
      height: 210,
      chart: AppSunburstChart(data: sunData),
    );
  }

  Widget _chart27Funnel(ChartThemeTokens tokens) {
    const funnelData = [
      {'stage': '1. Impresiones', 'value': 10000},
      {'stage': '2. Visitas Par', 'value': 6200},
      {'stage': '3. Órdenes Creadas', 'value': 3400},
      {'stage': '4. Trades Ejecutados', 'value': 2100},
    ];
    return const AppChartCard(
      title: '27. Funnel / Pyramid Chart (Embudo)',
      subtitle: 'Etapas de conversión financiera — trapezoides proporcionales',
      badgeText: 'Embudo #27',
      height: 260,
      chart: AppFunnelChart(data: funnelData),
    );
  }

  Widget _chart28Parallel(ChartThemeTokens tokens) {
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
    return const AppChartCard(
      title: '28. Parallel Coordinates (Coordenadas Paralelas)',
      subtitle: 'Líneas continuas multidimensionales comparando activos',
      badgeText: '4 Dimensiones #28',
      height: 220,
      chart: AppParallelCoordChart(data: parallelData),
    );
  }

  Widget _chart29ScatterMatrix(ChartThemeTokens tokens) {
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
    return const AppChartCard(
      title: '29. Scatter Plot Matrix (Matriz de Dispersión)',
      subtitle: 'Burbujas en cuadrícula cruzando correlaciones financieras',
      badgeText: 'Matriz #29',
      height: 220,
      chart: AppScatterMatrixChart(data: matrixData),
    );
  }

  Widget _chart30BandArea(ChartThemeTokens tokens) {
    const bandData = [
      {'time': '10:00', 'price': 84100, 'upper': 84700, 'lower': 83500},
      {'time': '12:00', 'price': 84350, 'upper': 84900, 'lower': 83700},
      {'time': '14:00', 'price': 83900, 'upper': 84600, 'lower': 83300},
      {'time': '16:00', 'price': 84500, 'upper': 85100, 'lower': 83900},
      {'time': '18:00', 'price': 84750, 'upper': 85400, 'lower': 84100},
    ];
    return const AppChartCard(
      title: '30. Range Area / Band Chart (Bandas Bollinger)',
      subtitle: 'AreaMark sombreada entre límites superior e inferior',
      badgeText: 'Volatilidad #30',
      height: 210,
      chart: AppBandAreaChart(data: bandData),
    );
  }

  Widget _chart31Candlestick(ChartThemeTokens tokens) {
    const ohlcData = [
      {
        'date': '09:00',
        'open': 83800,
        'close': 84200,
        'high': 84500,
        'low': 83600
      },
      {
        'date': '10:00',
        'open': 84200,
        'close': 84000,
        'high': 84350,
        'low': 83900
      },
      {
        'date': '11:00',
        'open': 84000,
        'close': 84450,
        'high': 84600,
        'low': 83950
      },
      {
        'date': '12:00',
        'open': 84450,
        'close': 84150,
        'high': 84500,
        'low': 84050
      },
      {
        'date': '13:00',
        'open': 84150,
        'close': 84650,
        'high': 84800,
        'low': 84100
      },
    ];
    return const AppChartCard(
      title: '31. Candlestick / OHLC Chart (Velas Japonesas)',
      subtitle: 'CustomMark con CandlestickShape (Open, Close, High, Low)',
      badgeText: 'Trading #31',
      isPositiveBadge: true,
      height: 220,
      chart: AppCandlestickChart(data: ohlcData),
    );
  }

  Widget _chart32Streamgraph(ChartThemeTokens tokens) {
    const streamData = [
      // BTC — volumen 24h en miles de millones (tendencia al alza)
      {'date': '00:00', 'type': 'BTC', 'value': 28},
      {'date': '03:00', 'type': 'BTC', 'value': 32},
      {'date': '06:00', 'type': 'BTC', 'value': 38},
      {'date': '09:00', 'type': 'BTC', 'value': 45},
      {'date': '12:00', 'type': 'BTC', 'value': 42},
      {'date': '15:00', 'type': 'BTC', 'value': 50},
      {'date': '18:00', 'type': 'BTC', 'value': 46},
      {'date': '21:00', 'type': 'BTC', 'value': 40},
      // ETH — volumen con pico a medio día
      {'date': '00:00', 'type': 'ETH', 'value': 14},
      {'date': '03:00', 'type': 'ETH', 'value': 18},
      {'date': '06:00', 'type': 'ETH', 'value': 22},
      {'date': '09:00', 'type': 'ETH', 'value': 28},
      {'date': '12:00', 'type': 'ETH', 'value': 26},
      {'date': '15:00', 'type': 'ETH', 'value': 30},
      {'date': '18:00', 'type': 'ETH', 'value': 24},
      {'date': '21:00', 'type': 'ETH', 'value': 18},
      // SOL — crecimiento sostenido durante el día
      {'date': '00:00', 'type': 'SOL', 'value': 5},
      {'date': '03:00', 'type': 'SOL', 'value': 8},
      {'date': '06:00', 'type': 'SOL', 'value': 10},
      {'date': '09:00', 'type': 'SOL', 'value': 14},
      {'date': '12:00', 'type': 'SOL', 'value': 16},
      {'date': '15:00', 'type': 'SOL', 'value': 18},
      {'date': '18:00', 'type': 'SOL', 'value': 15},
      {'date': '21:00', 'type': 'SOL', 'value': 12},
    ];
    return const AppChartCard(
      title: '32. Streamgraph (Río de Datos / Área de Flujo)',
      subtitle: 'AreaMark + StackModifier + SymmetricModifier — Volumen 24h',
      badgeText: 'Flujo Orgánico #32',
      height: 220,
      chart: AppStreamgraphChart(data: streamData),
    );
  }
}
