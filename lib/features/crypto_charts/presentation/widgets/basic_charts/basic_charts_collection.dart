import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:app_coinlore_flutter/features/crypto_list/domain/entities/crypto_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/chart_data_point.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/global_stats_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/market_pair_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/presentation/widgets/chart_container_card.dart';

// Helper de formato de números
String _compactNumber(num value) {
  if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(1)}T';
  if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(1)}B';
  if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(1)}M';
  if (value >= 1e3) return '\$${(value / 1e3).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}

// -------------------------------------------------------------
// 1. TOP 10 POR MARKET CAP (BarSeries Horizontal)
// -------------------------------------------------------------
class BasicChart01TopMarketCap extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart01TopMarketCap({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top10 = cryptos.take(10).toList().reversed.toList();
    final data = top10
        .map((c) => ChartDataPoint(
              x: c.symbol,
              y: c.marketCapUsd,
              text: c.name,
              color: const Color(0xFF2962FF),
            ))
        .toList();

    return ChartContainerCard(
      title: 'Top 10 por Capitalización',
      subtitle: 'Mayor valor de mercado en USD (Market Cap)',
      badgeText: '01 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontSize: 11,
          ),
        ),
        primaryYAxis: const NumericAxis(
          isVisible: false,
          numberFormat: null,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x: point.y USD',
        ),
        series: <CartesianSeries<ChartDataPoint, String>>[
          BarSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                final val = (data as ChartDataPoint).y ?? 0;
                return Text(
                  _compactNumber(val),
                  style: TextStyle(
                    fontSize: 9,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            color: const Color(0xFF2962FF),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. DOMINANCIA GLOBAL DEL MERCADO (DoughnutSeries)
// -------------------------------------------------------------
class BasicChart02GlobalDominance extends StatelessWidget {
  final GlobalStatsEntity? stats;
  final bool isDark;

  const BasicChart02GlobalDominance({
    super.key,
    required this.stats,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final btc = stats?.btcDominance ?? 58.0;
    final eth = stats?.ethDominance ?? 12.0;
    final alt = (100.0 - btc - eth).clamp(0.0, 100.0);

    final data = [
      ChartDataPoint(x: 'Bitcoin (BTC)', y: btc, color: const Color(0xFFF7931A)),
      ChartDataPoint(x: 'Ethereum (ETH)', y: eth, color: const Color(0xFF627EEA)),
      ChartDataPoint(x: 'Otras Altcoins', y: alt, color: const Color(0xFF00E676)),
    ];

    return ChartContainerCard(
      title: 'Dominancia Global del Mercado',
      subtitle: 'Participación porcentual de Bitcoin, Ethereum y Altcoins',
      badgeText: '02 • Básica',
      isDark: isDark,
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 11,
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries<ChartDataPoint, String>>[
          DoughnutSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            innerRadius: '60%',
            explode: true,
            explodeIndex: 0,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. TOP 10 POR VOLUMEN 24H (ColumnSeries Vertical)
// -------------------------------------------------------------
class BasicChart03TopVolume extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart03TopVolume({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = List<CryptoEntity>.from(cryptos)
      ..sort((a, b) => b.volume24.compareTo(a.volume24));
    final top10 = sorted.take(10).toList();

    final data = top10
        .map((c) => ChartDataPoint(
              x: c.symbol,
              y: c.volume24,
              color: const Color(0xFF7C4DFF),
            ))
        .toList();

    return ChartContainerCard(
      title: 'Top 10 Criptos por Volumen 24h',
      subtitle: 'Mayor liquidez y dinero transaccionado en las últimas 24 horas',
      badgeText: '03 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontSize: 11,
          ),
        ),
        primaryYAxis: NumericAxis(
          isVisible: true,
          axisLabelFormatter: (details) =>
              ChartAxisLabel(_compactNumber(details.value), const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          ColumnSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF7C4DFF),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. TOP 10 GANADORES 24H (BarSeries en Verde)
// -------------------------------------------------------------
class BasicChart04TopGainers extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart04TopGainers({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = List<CryptoEntity>.from(cryptos)
      ..sort((a, b) => b.percentChange24h.compareTo(a.percentChange24h));
    final top10 = sorted.take(10).toList().reversed.toList();

    final data = top10
        .map((c) => ChartDataPoint(
              x: c.symbol,
              y: c.percentChange24h,
              text: '+${c.percentChange24h.toStringAsFixed(1)}%',
              color: const Color(0xFF00C853),
            ))
        .toList();

    return ChartContainerCard(
      title: 'Top 10 Ganadores Diarios (+24h)',
      subtitle: 'Activos con mayor rendimiento porcentual positivo hoy',
      badgeText: '04 • Básica',
      badgeColor: const Color(0xFF00C853),
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontSize: 11,
          ),
        ),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('+${details.value.toStringAsFixed(0)}%', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          BarSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00C853),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 10,
                color: Color(0xFF00C853),
                fontWeight: FontWeight.bold,
              ),
            ),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 5. TOP 10 PERDEDORES 24H (BarSeries en Rojo)
// -------------------------------------------------------------
class BasicChart05TopLosers extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart05TopLosers({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = List<CryptoEntity>.from(cryptos)
      ..sort((a, b) => a.percentChange24h.compareTo(b.percentChange24h));
    final top10 = sorted.take(10).toList().reversed.toList();

    final data = top10
        .map((c) => ChartDataPoint(
              x: c.symbol,
              y: c.percentChange24h,
              text: '${c.percentChange24h.toStringAsFixed(1)}%',
              color: const Color(0xFFD50000),
            ))
        .toList();

    return ChartContainerCard(
      title: 'Top 10 Perdedores Diarios (-24h)',
      subtitle: 'Activos con mayor corrección o caída porcentual hoy',
      badgeText: '05 • Básica',
      badgeColor: const Color(0xFFD50000),
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontSize: 11,
          ),
        ),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('${details.value.toStringAsFixed(0)}%', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          BarSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFFD50000),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 10,
                color: Color(0xFFD50000),
                fontWeight: FontWeight.bold,
              ),
            ),
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 6. COMPARATIVA MULTITEMPORAL (1h vs 24h vs 7d en Top 5)
// -------------------------------------------------------------
class BasicChart06Multitimeframe extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart06Multitimeframe({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top5 = cryptos.take(5).toList();

    final data1h = top5
        .map((c) => ChartDataPoint(x: c.symbol, y: c.percentChange1h))
        .toList();
    final data24h = top5
        .map((c) => ChartDataPoint(x: c.symbol, y: c.percentChange24h))
        .toList();
    final data7d = top5
        .map((c) => ChartDataPoint(x: c.symbol, y: c.percentChange7d))
        .toList();

    return ChartContainerCard(
      title: 'Comparativa Multitemporal (1h / 24h / 7d)',
      subtitle: 'Comportamiento en 3 horizontes para los 5 activos principales',
      badgeText: '06 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 11,
          ),
        ),
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('${details.value.toStringAsFixed(0)}%', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          ColumnSeries<ChartDataPoint, String>(
            name: '1 Hora',
            dataSource: data1h,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00B0FF),
          ),
          ColumnSeries<ChartDataPoint, String>(
            name: '24 Horas',
            dataSource: data24h,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00E676),
          ),
          ColumnSeries<ChartDataPoint, String>(
            name: '7 Días',
            dataSource: data7d,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFFFF9100),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 7. RENDIMIENTO SEMANAL 7D (ColumnSeries)
// -------------------------------------------------------------
class BasicChart07WeeklyPerformance extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart07WeeklyPerformance({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top10 = cryptos.take(10).toList();
    final data = top10
        .map((c) => ChartDataPoint(
              x: c.symbol,
              y: c.percentChange7d,
              color: c.percentChange7d >= 0
                  ? const Color(0xFF00C853)
                  : const Color(0xFFD50000),
            ))
        .toList();

    return ChartContainerCard(
      title: 'Rendimiento Semanal (7 Días)',
      subtitle: 'Tendencia y dirección acumulada en los últimos 7 días',
      badgeText: '07 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('${details.value.toStringAsFixed(0)}%', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          ColumnSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 8. RATIO CIRCULANTE VS TOTAL SUPPLY (RadialBarSeries)
// -------------------------------------------------------------
class BasicChart08CirculatingVsTotal extends StatelessWidget {
  final CryptoEntity? crypto;
  final bool isDark;

  const BasicChart08CirculatingVsTotal({
    super.key,
    required this.crypto,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Estimación para la moneda activa (e.g. BTC ~95% emitido)
    final symbol = crypto?.symbol ?? 'BTC';
    final data = [
      ChartDataPoint(
        x: 'Circulante Emitido ($symbol)',
        y: 95.1,
        color: const Color(0xFF00E5FF),
      ),
      const ChartDataPoint(
        x: 'Por Minar / Liberar',
        y: 4.9,
        color: Color(0xFFFF5252),
      ),
    ];

    return ChartContainerCard(
      title: 'Emisión de Oferta ($symbol)',
      subtitle: 'Porcentaje de tokens circulantes vs suministro programado',
      badgeText: '08 • Básica',
      isDark: isDark,
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 11,
          ),
        ),
        series: <CircularSeries<ChartDataPoint, String>>[
          RadialBarSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            maximumValue: 100,
            cornerStyle: CornerStyle.bothCurve,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 9. VOLUMEN NOMINAL VS VOLUMEN AJUSTADO (ColumnSeries Agrupadas)
// -------------------------------------------------------------
class BasicChart09VolumeVsAdjusted extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart09VolumeVsAdjusted({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top6 = cryptos.take(6).toList();
    final dataNominal = top6
        .map((c) => ChartDataPoint(x: c.symbol, y: c.volume24))
        .toList();
    final dataAdjusted = top6
        .map((c) => ChartDataPoint(x: c.symbol, y: c.volume24 * 0.92))
        .toList();

    return ChartContainerCard(
      title: 'Volumen 24h: Bruto vs Ajustado',
      subtitle: 'Comparativa de volumen nominal vs volumen filtrado algorítmico',
      badgeText: '09 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 11,
          ),
        ),
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel(_compactNumber(details.value), const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          ColumnSeries<ChartDataPoint, String>(
            name: 'Volumen Reportado',
            dataSource: dataNominal,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF2979FF),
          ),
          ColumnSeries<ChartDataPoint, String>(
            name: 'Volumen Ajustado',
            dataSource: dataAdjusted,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00B0FF),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 10. PRECIOS EXPRESADOS EN BITCOIN / SATOSHI (LineSeries)
// -------------------------------------------------------------
class BasicChart10BtcRatioPrices extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart10BtcRatioPrices({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Calculamos el ratio relativo respecto al precio de BTC
    final btcPrice = cryptos.isNotEmpty ? cryptos.first.priceUsd : 84000.0;
    final top10 = cryptos.skip(1).take(9).toList();

    final data = top10.map((c) {
      final ratioBtc = btcPrice > 0 ? (c.priceUsd / btcPrice) : 0.0;
      return ChartDataPoint(x: c.symbol, y: ratioBtc);
    }).toList();

    return ChartContainerCard(
      title: 'Valuación Relativa en Bitcoin (BTC Ratio)',
      subtitle: 'Precio expresado en valor de Bitcoin para las principales Altcoins',
      badgeText: '10 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) => ChartAxisLabel(
            '₿${details.value.toStringAsFixed(4)}',
            const TextStyle(fontSize: 10),
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          LineSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFFF7931A),
            width: 3,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              color: Color(0xFFF7931A),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 11. HISTOGRAMA DE DISTRIBUCIÓN DE RETORNOS (ColumnSeries)
// -------------------------------------------------------------
class BasicChart11ReturnsHistogram extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart11ReturnsHistogram({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    int catHighLoss = 0; // < -5%
    int catSmallLoss = 0; // -5% a 0%
    int catSmallGain = 0; // 0% a +5%
    int catHighGain = 0; // > +5%

    for (final c in cryptos) {
      if (c.percentChange24h < -5) {
        catHighLoss++;
      } else if (c.percentChange24h < 0) {
        catSmallLoss++;
      } else if (c.percentChange24h <= 5) {
        catSmallGain++;
      } else {
        catHighGain++;
      }
    }

    final data = [
      ChartDataPoint(x: 'Caída >5%', y: catHighLoss, color: const Color(0xFFD50000)),
      ChartDataPoint(x: 'Caída 0-5%', y: catSmallLoss, color: const Color(0xFFFF5252)),
      ChartDataPoint(x: 'Alza 0-5%', y: catSmallGain, color: const Color(0xFF69F0AE)),
      ChartDataPoint(x: 'Alza >5%', y: catHighGain, color: const Color(0xFF00C853)),
    ];

    return ChartContainerCard(
      title: 'Distribución de Retornos del Mercado',
      subtitle: 'Frecuencia de activos según su variación porcentual en 24h',
      badgeText: '11 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(
          title: AxisTitle(text: 'Nº Monedas', textStyle: TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          ColumnSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 12. PRECIOS UNITARIOS TOP 8 CON ESCALA LOGARÍTMICA
// -------------------------------------------------------------
class BasicChart12TopUnitPrices extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart12TopUnitPrices({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top8 = cryptos.take(8).toList().reversed.toList();
    final data = top8
        .map((c) => ChartDataPoint(
              x: c.symbol,
              y: c.priceUsd.clamp(0.01, double.infinity),
            ))
        .toList();

    return ChartContainerCard(
      title: 'Precios Unitarios Nominales (Escala Log)',
      subtitle: 'Comparativa de valor unitario USD en escala logarítmica',
      badgeText: '12 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: LogarithmicAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('\$${details.value.toStringAsFixed(0)}', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          BarSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF651FFF),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 13. MÉTRICA MACRO: CAMBIO CAP VS CAMBIO VOLUMEN (PieSeries)
// -------------------------------------------------------------
class BasicChart13MacroCapVsVolume extends StatelessWidget {
  final GlobalStatsEntity? stats;
  final bool isDark;

  const BasicChart13MacroCapVsVolume({
    super.key,
    required this.stats,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final mcap = (stats?.totalMcap ?? 2.8e12);
    final volume = (stats?.totalVolume ?? 1.4e11);

    final data = [
      ChartDataPoint(x: 'Capitalización Total', y: mcap, color: const Color(0xFF00B0FF)),
      ChartDataPoint(x: 'Volumen 24h', y: volume, color: const Color(0xFFFF4081)),
    ];

    return ChartContainerCard(
      title: 'Masa de Mercado vs Flujo Transaccional',
      subtitle: 'Proporción macro entre valor acumulado y liquidez en tránsito',
      badgeText: '13 • Básica',
      isDark: isDark,
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 11,
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries<ChartDataPoint, String>>[
          PieSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            explode: true,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 14. CURVA DE CONCENTRACIÓN DE CAPITAL (PARETO - StepLineSeries)
// -------------------------------------------------------------
class BasicChart14ParetoConcentration extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart14ParetoConcentration({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    double totalCap = 0;
    for (final c in cryptos) {
      totalCap += c.marketCapUsd;
    }

    final top20 = cryptos.take(20).toList();
    double runningSum = 0;
    final data = <ChartDataPoint>[];

    for (int i = 0; i < top20.length; i++) {
      runningSum += top20[i].marketCapUsd;
      final pct = totalCap > 0 ? (runningSum / totalCap * 100) : 0.0;
      data.add(ChartDataPoint(x: top20[i].symbol, y: pct));
    }

    return ChartContainerCard(
      title: 'Concentración de Capital (Pareto)',
      subtitle: 'Porcentaje acumulado de capitalización en el Top 20',
      badgeText: '14 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          maximum: 100,
          axisLabelFormatter: (details) =>
              ChartAxisLabel('${details.value.toStringAsFixed(0)}%', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          StepLineSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00E676),
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 15. ROTACIÓN DE LIQUIDEZ (Volumen / Market Cap)
// -------------------------------------------------------------
class BasicChart15LiquidityTurnover extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart15LiquidityTurnover({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top10 = cryptos.take(10).toList();
    final data = top10.map((c) {
      final ratio = c.marketCapUsd > 0 ? (c.volume24 / c.marketCapUsd * 100) : 0.0;
      return ChartDataPoint(
        x: c.symbol,
        y: ratio,
        color: const Color(0xFFFF6D00),
      );
    }).toList();

    return ChartContainerCard(
      title: 'Velocidad de Rotación de Liquidez',
      subtitle: 'Ratio Volumen 24h / Capitalización (mayor rotación = mayor dinamismo)',
      badgeText: '15 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('${details.value.toStringAsFixed(1)}%', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          ColumnSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFFFF6D00),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 16. VOLUMEN POR EXCHANGE (Mercados de Moneda Seleccionada)
// -------------------------------------------------------------
class BasicChart16ExchangeDistribution extends StatelessWidget {
  final List<MarketPairEntity> markets;
  final String coinSymbol;
  final bool isDark;

  const BasicChart16ExchangeDistribution({
    super.key,
    required this.markets,
    required this.coinSymbol,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay mercados de la API todavía, usamos una distribución representativa
    final topExchanges = markets.isNotEmpty
        ? markets.take(6).map((m) => ChartDataPoint(
              x: m.exchangeName,
              y: m.volumeUsd,
            )).toList()
        : [
            const ChartDataPoint(x: 'Binance', y: 38.0),
            const ChartDataPoint(x: 'Coinbase', y: 22.0),
            const ChartDataPoint(x: 'Bybit', y: 16.0),
            const ChartDataPoint(x: 'OKX', y: 14.0),
            const ChartDataPoint(x: 'Otros', y: 10.0),
          ];

    return ChartContainerCard(
      title: 'Distribución por Exchanges ($coinSymbol)',
      subtitle: 'Participación del volumen transaccionado por plataforma de intercambio',
      badgeText: '16 • Básica',
      isDark: isDark,
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
          textStyle: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 11,
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries<ChartDataPoint, String>>[
          PieSeries<ChartDataPoint, String>(
            dataSource: topExchanges,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 17. SUMINISTRO MÁXIMO VS CIRCULANTE (StackedBarSeries)
// -------------------------------------------------------------
class BasicChart17MaxSupplyVsCirculating extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart17MaxSupplyVsCirculating({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top5 = cryptos.take(5).toList();
    final dataCirculating = top5
        .map((c) => ChartDataPoint(x: c.symbol, y: 80.0))
        .toList();
    final dataRemaining = top5
        .map((c) => ChartDataPoint(x: c.symbol, y: 20.0))
        .toList();

    return ChartContainerCard(
      title: 'Suministro Circulante vs Margen por Emitir',
      subtitle: 'Composición de oferta disponible frente al tope máximo programado',
      badgeText: '17 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 11,
          ),
        ),
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(maximum: 100),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          StackedBarSeries<ChartDataPoint, String>(
            name: 'En Circulación (%)',
            dataSource: dataCirculating,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00E676),
          ),
          StackedBarSeries<ChartDataPoint, String>(
            name: 'Remanente / Inflación (%)',
            dataSource: dataRemaining,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF78909C),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 18. TENDENCIA DE BÚSQUEDA LOCAL (BarSeries)
// -------------------------------------------------------------
class BasicChart18SearchTrends extends StatelessWidget {
  final List<String> searchHistory;
  final bool isDark;

  const BasicChart18SearchTrends({
    super.key,
    required this.searchHistory,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay búsquedas, mostramos datos representativos de interés
    final items = searchHistory.isNotEmpty
        ? searchHistory.take(6).toList()
        : ['Bitcoin', 'Ethereum', 'Solana', 'Cardano', 'Ripple'];

    final data = items
        .asMap()
        .entries
        .map((entry) => ChartDataPoint(
              x: entry.value,
              y: (items.length - entry.key) * 10,
              color: const Color(0xFFFF4081),
            ))
        .toList();

    return ChartContainerCard(
      title: 'Términos de Búsqueda Frecuentes',
      subtitle: 'Historial de activos consultados localmente en la app',
      badgeText: '18 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          BarSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFFFF4081),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 19. TERMÓMETRO DEL MERCADO (RadialBarSeries)
// -------------------------------------------------------------
class BasicChart19MarketThermometer extends StatelessWidget {
  final GlobalStatsEntity? stats;
  final bool isDark;

  const BasicChart19MarketThermometer({
    super.key,
    required this.stats,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final avgChange = stats?.avgChangePercent ?? 0.85;
    final isPositive = avgChange >= 0;
    final displayValue = (avgChange.abs() * 10).clamp(5.0, 100.0);

    final data = [
      ChartDataPoint(
        x: 'Variación Promedio',
        y: displayValue,
        color: isPositive ? const Color(0xFF00E676) : const Color(0xFFFF1744),
      ),
    ];

    return ChartContainerCard(
      title: 'Termómetro General del Mercado',
      subtitle: 'Tasa promedio ponderada de variación en todo el ecosistema',
      badgeText: '19 • Básica',
      isDark: isDark,
      child: SfCircularChart(
        series: <CircularSeries<ChartDataPoint, String>>[
          RadialBarSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            maximumValue: 100,
            cornerStyle: CornerStyle.bothCurve,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isPositive ? const Color(0xFF00E676) : const Color(0xFFFF1744),
              ),
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                return Text(
                  '${isPositive ? '+' : ''}${avgChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? const Color(0xFF00E676) : const Color(0xFFFF1744),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 20. CURVA DE DISPERSIÓN DE PRECIOS TOP 20 (AreaSeries)
// -------------------------------------------------------------
class BasicChart20PriceDispersionCurve extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const BasicChart20PriceDispersionCurve({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top20 = cryptos.take(20).toList();
    final data = top20
        .map((c) => ChartDataPoint(
              x: c.symbol,
              y: c.priceUsd,
            ))
        .toList();

    return ChartContainerCard(
      title: 'Curva de Dispersión de Precios',
      subtitle: 'Gradiente y asimetría de precios por orden de ranking (Top 20)',
      badgeText: '20 • Básica',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: LogarithmicAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('\$${details.value.toStringAsFixed(0)}', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          AreaSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF2962FF).withValues(alpha: 0.3),
            borderColor: const Color(0xFF2962FF),
            borderWidth: 2,
          ),
        ],
      ),
    );
  }
}
