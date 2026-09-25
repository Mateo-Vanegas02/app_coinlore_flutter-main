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
      description: 'Barras + Línea + Scatter',
      icon: Icons.stacked_bar_chart,
      isAdvanced: true,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'combined',
          animateY: 1000,
          data: {
            // Pasamos datasets de barra, línea y scatter. Asumimos soporte o mock.
            'datasets': [
              {
                'type': 'bar',
                'label': 'Volumen',
                'color': '#4CAF50',
                'entries': List.generate(5, (i) => {'x': i, 'y': 100 + i*10}),
              },
              {
                'type': 'line',
                'label': 'Precio',
                'color': '#F44336',
                'entries': List.generate(5, (i) => {'x': i+0.2, 'y': 80 + i*15}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '2. Doble Eje Y',
      description: 'Escalas Izquierda/Derecha distintas',
      icon: Icons.compare_arrows,
      isAdvanced: true,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final p = cryptos.isNotEmpty ? cryptos.first.priceUsd : 100.0;
        final v = cryptos.isNotEmpty ? cryptos.first.volume24 : 50000.0;
        return ChartConfig(
          chartType: 'line',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'Precio (Izq)',
                'color': '#2196F3',
                'axisDependency': 'left',
                'entries': List.generate(10, (i) => {'x': i, 'y': p + i * 5}),
              },
              {
                'label': 'Volumen (Der)',
                'color': '#FFC107',
                'axisDependency': 'right',
                'entries': List.generate(10, (i) => {'x': i, 'y': v - i * 1000}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '3. Tiempo Real (Streaming)',
      description: 'Línea en tiempo real con scroll',
      icon: Icons.stream,
      isAdvanced: true,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'line',
          animateX: 500,
          data: {
            'datasets': [
              {
                'label': 'Live Data',
                'color': '#E91E63',
                'entries': List.generate(20, (i) => {'x': i, 'y': 50 + sin(i.toDouble()) * 10}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '4. Dataset Grande (Zoom/Pan)',
      description: 'Más de 5,000 puntos',
      icon: Icons.zoom_in,
      isAdvanced: true,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'scatter',
          animateX: 0,
          data: {
            'datasets': [
              {
                'label': 'Puntos Históricos',
                'color': '#9C27B0',
                'entries': List.generate(5000, (i) => {'x': i, 'y': 100 + (sin(i*0.1) * 20) + (Random().nextDouble() * 10)}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '5. MarkerView Personalizado',
      description: 'Tooltip nativo con info',
      icon: Icons.info_outline,
      isAdvanced: true,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(5).toList();
        return ChartConfig(
          chartType: 'bar',
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Market Cap',
                'color': '#00BCD4',
                'entries': take.asMap().entries.map((e) => {'x': e.key, 'y': e.value.marketCapUsd}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '6. Pirámide (Barras apiladas H)',
      description: 'Gainers vs Losers H',
      icon: Icons.align_horizontal_center,
      isAdvanced: true,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'horizontal_bar',
          animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Positivo / Negativo',
                'colors': ['#4CAF50', '#F44336'],
                'entries': [
                  {'x': 0, 'yVals': [-5.0, 10.0]},
                  {'x': 1, 'yVals': [-2.0, 8.0]},
                  {'x': 2, 'yVals': [-8.0, 3.0]},
                ]
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '7. Radar Comparativo',
      description: 'BTC vs ETH Múltiples variables',
      icon: Icons.radar,
      isAdvanced: true,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final btc = cryptos.isNotEmpty ? cryptos.first : null;
        final eth = cryptos.length > 1 ? cryptos[1] : null;
        return ChartConfig(
          chartType: 'radar',
          animateX: 1000, animateY: 1000,
          data: {
            'datasets': [
              if (btc != null)
              {
                'label': btc.symbol,
                'color': '#FF9800',
                'entries': [{'value': btc.percentChange1h.abs()}, {'value': btc.percentChange24h.abs()}, {'value': btc.percentChange7d.abs()}]
              },
              if (eth != null)
              {
                'label': eth.symbol,
                'color': '#9E9E9E',
                'entries': [{'value': eth.percentChange1h.abs()}, {'value': eth.percentChange24h.abs()}, {'value': eth.percentChange7d.abs()}]
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '8. Gradiente Relleno (Gradient)',
      description: 'Curva suavizada con gradiente',
      icon: Icons.gradient,
      isAdvanced: true,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'line',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'Tendencia',
                'color': '#3F51B5',
                'isFilled': true,
                'mode': 'cubic',
                'entries': List.generate(20, (i) => {'x': i, 'y': 20 + cos(i.toDouble()) * 10}),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '9. Candlestick + Volumen',
      description: 'Velas y barras de volumen',
      icon: Icons.candlestick_chart,
      isAdvanced: true,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'candlestick',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'OHLC',
                'color': '#8BC34A',
                'entries': List.generate(10, (i) => {
                  'x': i, 'high': 100+i*2, 'low': 90+i*2, 'open': 95+i*2, 'close': 98+i*2
                }),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '10. Gráfico Interactivo',
      description: 'Tocar para actualizar UI Flutter',
      icon: Icons.touch_app,
      isAdvanced: true,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(5).toList();
        return ChartConfig(
          chartType: 'pie',
          animateY: 500,
          drawHole: true,
          data: {
            'datasets': [
              {
                'label': 'Tap me',
                'colors': ['#FF5722', '#CDDC39', '#009688', '#795548', '#607D8B'],
                'entries': take.map((e) => {'label': e.symbol, 'value': e.priceUsd}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '11. Transiciones Animadas',
      description: 'Cambio dinámico de estado',
      icon: Icons.animation,
      isAdvanced: true,
      dataSource: 'Real',
      buildConfig: (cryptos) {
        final take = cryptos.take(4).toList();
        return ChartConfig(
          chartType: 'bubble',
          animateX: 1000, animateY: 1000,
          data: {
            'datasets': [
              {
                'label': 'Burbujas animadas',
                'color': '#03A9F4',
                'entries': take.map((e) => {'x': e.rank, 'y': e.percentChange24h, 'size': e.priceUsd/100}).toList(),
              }
            ]
          }
        );
      },
    ),
    ChartItem(
      title: '12. Gráficos Sincronizados',
      description: 'Zoom y pan sincronizado en X',
      icon: Icons.sync,
      isAdvanced: true,
      dataSource: 'Simulado',
      buildConfig: (cryptos) {
        return ChartConfig(
          chartType: 'line',
          animateX: 1000,
          data: {
            'datasets': [
              {
                'label': 'Gráfico Superior Sync',
                'color': '#673AB7',
                'entries': List.generate(50, (i) => {'x': i, 'y': sin(i*0.2)*50}),
              }
            ]
          }
        );
      },
    ),
  ];
}
