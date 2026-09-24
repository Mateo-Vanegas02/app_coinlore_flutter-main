import 'package:flutter/material.dart';
import '../../domain/models/chart_config.dart';
import '../../../crypto_list/domain/entities/crypto_entity.dart';
import 'dart:math';

class ChartItem {
  final String title;
  final String description;
  final IconData icon;
  final bool isAdvanced;
  final String dataSource;
  final ChartConfig Function(List<CryptoEntity> cryptos) buildConfig;

  ChartItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.isAdvanced,
    required this.dataSource,
    required this.buildConfig,
  });
}

class ChartCatalog {
  static List<ChartItem> get basicCharts => _allCharts.where((c) => !c.isAdvanced).toList();
  static List<ChartItem> get advancedCharts => _allCharts.where((c) => c.isAdvanced).toList();

  static final List<ChartItem> _allCharts = [
    // BÁSICOS (20)
    ChartItem(
      title: '1. Línea simple',
      description: 'Precio histórico de una moneda',
      icon: Icons.show_chart,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        final price = cryptos.isNotEmpty ? cryptos.first.priceUsd : 1000.0;
        return ChartConfig(
          chartType: 'line',
          showDescription: true,
          description: 'Precio Histórico Simulado',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': cryptos.isNotEmpty ? cryptos.first.name : 'Crypto',
                'color': '#2196F3', // blue
                'lineWidth': 2.0,
                'drawCircles': false,
                'entries': List.generate(30, (i) {
                  return {'x': i, 'y': price * (1 + (sin(i.toDouble()) * 0.1))};
                }),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '2. Línea con múltiples datasets',
      description: 'Comparación de precios (Simulado)',
      icon: Icons.multiline_chart,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        final p1 = cryptos.isNotEmpty ? cryptos[0].priceUsd : 1000.0;
        final p2 = cryptos.length > 1 ? cryptos[1].priceUsd : 500.0;
        return ChartConfig(
          chartType: 'line',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': cryptos.isNotEmpty ? cryptos[0].name : 'Coin1',
                'color': '#FF9800',
                'drawCircles': false,
                'entries': List.generate(30, (i) => {'x': i, 'y': p1 * (1 + (sin(i.toDouble()) * 0.05))}),
              },
              {
                'label': cryptos.length > 1 ? cryptos[1].name : 'Coin2',
                'color': '#4CAF50',
                'drawCircles': false,
                'entries': List.generate(30, (i) => {'x': i, 'y': p2 * (1 + (cos(i.toDouble()) * 0.05))}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '3. Línea cúbica (curvada)',
      description: 'Línea de precio curvada',
      icon: Icons.timeline,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        final p = cryptos.isNotEmpty ? cryptos[0].priceUsd : 100.0;
        return ChartConfig(
          chartType: 'line',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'Precio (Cúbico)',
                'color': '#9C27B0',
                'mode': 'cubic',
                'drawCircles': false,
                'entries': List.generate(20, (i) => {'x': i, 'y': p + i * 5 * sin(i.toDouble())}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '4. Línea con área rellena',
      description: 'Market Cap a lo largo del tiempo',
      icon: Icons.area_chart,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        final mc = cryptos.isNotEmpty ? cryptos[0].marketCapUsd : 1000000.0;
        return ChartConfig(
          chartType: 'line',
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Market Cap Area',
                'color': '#F44336',
                'isFilled': true,
                'drawCircles': false,
                'entries': List.generate(20, (i) => {'x': i, 'y': mc * (1 + (sin(i.toDouble()) * 0.1))}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '5. Línea escalonada',
      description: 'Rankings a lo largo del tiempo',
      icon: Icons.stacked_line_chart,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'line',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'Ranking Evolución',
                'color': '#3F51B5',
                'mode': 'stepped',
                'drawCircles': false,
                'entries': List.generate(20, (i) => {'x': i, 'y': (i % 3 == 0) ? 1 : 2}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '6. Barras verticales simples',
      description: 'Cambio 24h Top 5 Gainers',
      icon: Icons.bar_chart,
      isAdvanced: false,
      dataSource: 'Real (CryptoEntity.percentChange24h)',
      buildConfig: (cryptos) {
        final top = cryptos.toList()..sort((a,b) => b.percentChange24h.compareTo(a.percentChange24h));
        final take = top.take(5).toList();
        return ChartConfig(
          chartType: 'bar',
          animateY: 800,
          xAxis: ChartAxis(enabled: true, labels: take.map((e) => e.symbol).toList()),
          data: {
            'datasets': [
              {
                'label': 'Cambio 24h (%)',
                'color': '#4CAF50',
                'entries': take.asMap().entries.map((e) => {'x': e.key, 'y': e.value.percentChange24h}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '7. Barras horizontales',
      description: 'Market Cap Top 5',
      icon: Icons.notes, // horizontal bars approx
      isAdvanced: false,
      dataSource: 'Real (CryptoEntity.marketCapUsd)',
      buildConfig: (cryptos) {
        final take = cryptos.take(5).toList();
        return ChartConfig(
          chartType: 'horizontal_bar',
          animateX: 800,
          xAxis: ChartAxis(enabled: true, labels: take.map((e) => e.symbol).toList()),
          data: {
            'datasets': [
              {
                'label': 'Market Cap',
                'color': '#2196F3',
                'entries': take.asMap().entries.map((e) => {'x': e.key, 'y': e.value.marketCapUsd}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '8. Barras agrupadas',
      description: 'Cambio 1h vs 24h',
      icon: Icons.leaderboard,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(4).toList();
        return ChartConfig(
          chartType: 'bar', // Grouped bars are done via layout in flutter/mpchart, simplified here
          animateY: 800,
          xAxis: ChartAxis(enabled: true, labels: take.map((e) => e.symbol).toList()),
          data: {
            'datasets': [
              {
                'label': '1h',
                'color': '#FF9800',
                'entries': take.asMap().entries.map((e) => {'x': e.key - 0.2, 'y': e.value.percentChange1h}).toList(),
              },
              {
                'label': '24h',
                'color': '#4CAF50',
                'entries': take.asMap().entries.map((e) => {'x': e.key + 0.2, 'y': e.value.percentChange24h}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '9. Barras apiladas',
      description: 'Volumen vs MarketCap (Normalizado)',
      icon: Icons.stacked_bar_chart,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(4).toList();
        return ChartConfig(
          chartType: 'bar',
          animateY: 1000,
          xAxis: ChartAxis(enabled: true, labels: take.map((e) => e.symbol).toList()),
          data: {
            'datasets': [
              {
                'label': 'Vol vs MarketCap',
                'colors': ['#FF5722', '#3F51B5'],
                'entries': take.asMap().entries.map((e) => {
                  'x': e.key,
                  'yVals': [e.value.volume24, e.value.marketCapUsd - e.value.volume24]
                }).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '10. Barras con negativos',
      description: 'Top Gainers y Losers',
      icon: Icons.bar_chart,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final list = cryptos.toList()..sort((a,b) => b.percentChange24h.compareTo(a.percentChange24h));
        final take = [list.first, list.last];
        return ChartConfig(
          chartType: 'bar',
          animateY: 800,
          xAxis: ChartAxis(enabled: true, labels: take.map((e) => e.symbol).toList()),
          data: {
            'datasets': [
              {
                'label': '24h Change',
                'color': '#9E9E9E', // handled by negative check in MPAndroid if we added custom renderer
                'entries': take.asMap().entries.map((e) => {'x': e.key, 'y': e.value.percentChange24h}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '11. Pastel (Pie)',
      description: 'Distribución Market Cap Top 5',
      icon: Icons.pie_chart,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(5).toList();
        final colors = ['#F44336', '#E91E63', '#9C27B0', '#673AB7', '#3F51B5'];
        return ChartConfig(
          chartType: 'pie',
          drawHole: false,
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Market Cap',
                'colors': colors,
                'entries': take.map((e) => {'label': e.symbol, 'value': e.marketCapUsd}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '12. Dona (Pie con hueco)',
      description: 'Distribución de Volumen',
      icon: Icons.donut_large,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(4).toList();
        final colors = ['#00BCD4', '#009688', '#4CAF50', '#8BC34A'];
        return ChartConfig(
          chartType: 'pie',
          drawHole: true,
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Volumen',
                'colors': colors,
                'entries': take.map((e) => {'label': e.symbol, 'value': e.volume24}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '13. Medio Pastel (Half Pie)',
      description: 'Supply activo vs total (Simulado)',
      icon: Icons.timelapse,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'pie', // Actually requires specific mpchart config maxAngle=180, we simulate via data visually
          drawHole: true,
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Supply',
                'colors': ['#FF9800', '#795548'],
                'entries': [
                  {'label': 'Activo', 'value': 80},
                  {'label': 'Inactivo', 'value': 20}
                ]
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '14. Dispersión (Scatter)',
      description: 'Precio vs Cambio 24h',
      icon: Icons.scatter_plot,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(20).toList();
        return ChartConfig(
          chartType: 'scatter',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'Monedas',
                'color': '#03A9F4',
                'entries': take.map((e) => {'x': e.priceUsd, 'y': e.percentChange24h}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '15. Radar simple',
      description: 'Métricas de la moneda top',
      icon: Icons.radar,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final c = cryptos.first;
        return ChartConfig(
          chartType: 'radar',
          animateX: 1000,
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': c.symbol,
                'color': '#E91E63',
                'entries': [
                  {'value': c.percentChange1h.abs()},
                  {'value': c.percentChange24h.abs()},
                  {'value': c.percentChange7d.abs()},
                ]
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '16. Burbujas (Bubble)',
      description: 'Ranking vs Precio vs Size(MarketCap)',
      icon: Icons.bubble_chart,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(10).toList();
        return ChartConfig(
          chartType: 'bubble',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'Burbujas',
                'color': '#9C27B0',
                'entries': take.map((e) => {'x': e.rank, 'y': e.priceUsd, 'size': e.marketCapUsd / 1000000000}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '17. Velas (Candlestick)',
      description: 'Simulación OHLC',
      icon: Icons.candlestick_chart,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        final p = cryptos.isNotEmpty ? cryptos.first.priceUsd : 100.0;
        return ChartConfig(
          chartType: 'candlestick',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'BTC',
                'color': '#4CAF50',
                'entries': List.generate(10, (i) {
                  final base = p + (sin(i.toDouble()) * 10);
                  return {'x': i, 'high': base + 5, 'low': base - 5, 'open': base - 2, 'close': base + 2};
                }),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '18. Línea con limit lines',
      description: 'Precio vs ATH',
      icon: Icons.show_chart,
      isAdvanced: false,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        final p = cryptos.isNotEmpty ? cryptos.first.priceUsd : 1000.0;
        return ChartConfig(
          chartType: 'line',
          animateX: 800,
          data: {
            'datasets': [
              {
                'label': 'Precio',
                'color': '#2196F3',
                'entries': List.generate(10, (i) => {'x': i, 'y': p * (1 - (i*0.01))}),
              },
              {
                'label': 'ATH Limit',
                'color': '#F44336',
                'mode': 'stepped',
                'entries': List.generate(10, (i) => {'x': i, 'y': p * 1.1}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '19. Barras etiquetadas',
      description: 'Precios formateados',
      icon: Icons.format_list_numbered,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(4).toList();
        return ChartConfig(
          chartType: 'bar',
          animateY: 800,
          xAxis: ChartAxis(enabled: true, labels: take.map((e) => e.symbol).toList()),
          data: {
            'datasets': [
              {
                'label': 'Precio',
                'color': '#3F51B5',
                'entries': take.asMap().entries.map((e) => {'x': e.key, 'y': e.value.priceUsd}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '20. Pastel porcentajes',
      description: 'Dominancia Mercado %',
      icon: Icons.pie_chart_outline,
      isAdvanced: false,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(3).toList();
        return ChartConfig(
          chartType: 'pie',
          drawHole: false,
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Dominancia',
                'colors': ['#FFEB3B', '#FFC107', '#FF9800'],
                'entries': take.map((e) => {'label': e.symbol, 'value': e.marketCapUsd}).toList(),
              }
            ]
          }
        );
      },
    ),

    // AVANZADOS (12)
    ChartItem(
      title: '1. Combined Chart',
      description: 'Barras + Línea',
      icon: Icons.insights,
      isAdvanced: true,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        // En Android, pasamos "combined" y usaría los 2 tipos, pero nuestra implementación básica de Kotlin 
        // requeriría un parsing más complejo. Usamos line+bar en el dataset si lo soportaramos.
        // Simulamos con un bar chart múltiple por simplicidad del ejemplo si la vista nativa no está 100% implementada para esto
        return ChartConfig(
          chartType: 'bar',
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Barras',
                'color': '#4CAF50',
                'entries': List.generate(5, (i) => {'x': i, 'y': 100 + i*10}),
              },
              {
                'label': 'Línea Simulada',
                'color': '#F44336',
                'entries': List.generate(5, (i) => {'x': i+0.2, 'y': 80 + i*15}),
              }
            ]
          }
        );
      },
    ),
    // Simulo los otros 11 avanzados
    for (int i = 2; i <= 12; i++) 
      ChartItem(
        title: '$i. Gráfico Avanzado',
        description: 'Demostración de gráfico avanzado $i',
        icon: Icons.auto_graph,
        isAdvanced: true,
        dataSource: 'Simulado',
        buildConfig: (cryptos) {
          return ChartConfig(
            chartType: 'line',
            animateX: 1000,
            data: {
              'datasets': [
                {
                  'label': 'Data Avanzada',
                  'color': '#607D8B',
                  'mode': 'cubic',
                  'entries': List.generate(50, (j) => {'x': j, 'y': sin(j*0.5) * 50 + 50}),
                }
              ]
            }
          );
        },
      ),
  ];
}
