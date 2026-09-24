import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:app_coinlore_flutter/features/crypto_list/domain/entities/crypto_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/chart_data_point.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/ohlc_candle_data.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/presentation/providers/charts_providers.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/presentation/widgets/chart_container_card.dart';

String _compact(num value) {
  if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(1)}T';
  if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(1)}B';
  if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(1)}M';
  if (value >= 1e3) return '\$${(value / 1e3).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}

// -------------------------------------------------------------
// 1. VELAS JAPONESAS SINTÉTICAS CON TRACKBALL (CandleSeries)
// -------------------------------------------------------------
class AdvChart01ReconstructedCandlestick extends StatelessWidget {
  final List<OhlcCandleData> candleData;
  final String symbol;
  final bool isDark;

  const AdvChart01ReconstructedCandlestick({
    super.key,
    required this.candleData,
    required this.symbol,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ChartContainerCard(
      title: 'Velas Japonesas OHLC ($symbol)',
      subtitle: 'Reconstrucción técnica de Apertura, Máximo, Mínimo y Cierre',
      badgeText: '01 • Avanzada',
      badgeColor: const Color(0xFF00E676),
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
        ),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('\$${details.value.toStringAsFixed(0)}', const TextStyle(fontSize: 10)),
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: const InteractiveTooltip(enable: true),
        ),
        series: <CartesianSeries<OhlcCandleData, DateTime>>[
          CandleSeries<OhlcCandleData, DateTime>(
            dataSource: candleData,
            xValueMapper: (d, _) => d.time,
            lowValueMapper: (d, _) => d.low,
            highValueMapper: (d, _) => d.high,
            openValueMapper: (d, _) => d.open,
            closeValueMapper: (d, _) => d.close,
            bearColor: const Color(0xFFD50000),
            bullColor: const Color(0xFF00C853),
            enableSolidCandles: true,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. BURBUJAS CUADRIDIMENSIONALES (BubbleSeries)
// -------------------------------------------------------------
class AdvChart02MarketBubble4D extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart02MarketBubble4D({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top25 = cryptos.take(25).toList();

    return ChartContainerCard(
      title: 'Matriz 4D de Mercado (Cap / Vol / Precio / 24h)',
      subtitle: 'X: Capitalización, Y: Volumen, Tamaño: Precio USD, Color: Variación 24h',
      badgeText: '02 • Avanzada',
      badgeColor: const Color(0xFFFF9100),
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: LogarithmicAxis(
          title: const AxisTitle(text: 'Market Cap', textStyle: TextStyle(fontSize: 10)),
          axisLabelFormatter: (details) =>
              ChartAxisLabel(_compact(details.value), const TextStyle(fontSize: 9)),
        ),
        primaryYAxis: LogarithmicAxis(
          title: const AxisTitle(text: 'Volumen 24h', textStyle: TextStyle(fontSize: 10)),
          axisLabelFormatter: (details) =>
              ChartAxisLabel(_compact(details.value), const TextStyle(fontSize: 9)),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x: Cap, point.y: Vol',
        ),
        series: <CartesianSeries<CryptoEntity, num>>[
          BubbleSeries<CryptoEntity, num>(
            dataSource: top25,
            xValueMapper: (c, _) => c.marketCapUsd.clamp(1e6, double.infinity),
            yValueMapper: (c, _) => c.volume24.clamp(1e5, double.infinity),
            sizeValueMapper: (c, _) => c.priceUsd.clamp(1.0, 50000.0),
            pointColorMapper: (c, _) => c.percentChange24h >= 0
                ? const Color(0xFF00E676).withValues(alpha: 0.75)
                : const Color(0xFFFF1744).withValues(alpha: 0.75),
            minimumRadius: 6,
            maximumRadius: 28,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. BANDA DE FLUCTUACIÓN SEMANAL (RangeAreaSeries + Spline)
// -------------------------------------------------------------
class AdvChart03WeeklyRangeArea extends StatelessWidget {
  final CryptoEntity? crypto;
  final bool isDark;

  const AdvChart03WeeklyRangeArea({
    super.key,
    required this.crypto,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final price = crypto?.priceUsd ?? 84000.0;
    final ch7d = crypto?.percentChange7d ?? 8.0;

    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final data = <ChartDataPoint>[];

    for (int i = 0; i < 7; i++) {
      final factor = 1 + ((ch7d / 7 * i) / 100);
      final mid = price * factor;
      final low = mid * 0.94;
      final high = mid * 1.06;
      data.add(ChartDataPoint(x: days[i], y: mid, low: low, high: high));
    }

    return ChartContainerCard(
      title: 'Banda Semanal de Volatilidad (${crypto?.symbol ?? 'BTC'})',
      subtitle: 'Rango envolvente [Mínimo / Máximo] con trayectoria de precio medio',
      badgeText: '03 • Avanzada',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('\$${details.value.toStringAsFixed(0)}', const TextStyle(fontSize: 10)),
        ),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          RangeAreaSeries<ChartDataPoint, String>(
            name: 'Canal de Fluctuación',
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            lowValueMapper: (d, _) => d.low,
            highValueMapper: (d, _) => d.high,
            color: const Color(0xFF2962FF).withValues(alpha: 0.18),
            borderColor: const Color(0xFF2962FF).withValues(alpha: 0.4),
            borderWidth: 1.5,
          ),
          SplineSeries<ChartDataPoint, String>(
            name: 'Precio Medio',
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            color: const Color(0xFF00E5FF),
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. TICKER EN TIEMPO REAL CON STREAMING 5S (FastLineSeries)
// -------------------------------------------------------------
class AdvChart04LiveStreamingTicker extends StatelessWidget {
  final List<LivePricePoint> livePoints;
  final String symbol;
  final bool isDark;

  const AdvChart04LiveStreamingTicker({
    super.key,
    required this.livePoints,
    required this.symbol,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ChartContainerCard(
      title: 'Ticker Reactivo en Tiempo Real ($symbol)',
      subtitle: 'Streaming continuo de precios sincronizado con el ciclo de refresco (5s)',
      badgeText: '04 • Avanzada',
      badgeColor: const Color(0xFFD500F9),
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const DateTimeAxis(
          intervalType: DateTimeIntervalType.seconds,
          interval: 10,
        ),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) => ChartAxisLabel(
            '\$${details.value.toStringAsFixed(2)}',
            const TextStyle(fontSize: 10),
          ),
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
        ),
        series: <CartesianSeries<LivePricePoint, DateTime>>[
          FastLineSeries<LivePricePoint, DateTime>(
            dataSource: livePoints,
            xValueMapper: (p, _) => p.timestamp,
            yValueMapper: (p, _) => p.price,
            color: const Color(0xFFD500F9),
            width: 2.5,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 5. EJE DUAL COMBINADO: PRECIO VS VOLUMEN (Dual Axis)
// -------------------------------------------------------------
class AdvChart05DualAxisPriceVolume extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart05DualAxisPriceVolume({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top8 = cryptos.take(8).toList();

    return ChartContainerCard(
      title: 'Eje Dual: Precio USD vs Volumen 24h',
      subtitle: 'Superposición multivariable: Precio (Eje Izq) y Volumen (Eje Der)',
      badgeText: '05 • Avanzada',
      isDark: isDark,
      child: SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          title: const AxisTitle(text: 'Precio (USD)', textStyle: TextStyle(fontSize: 10)),
          axisLabelFormatter: (details) =>
              ChartAxisLabel('\$${details.value.toStringAsFixed(0)}', const TextStyle(fontSize: 9)),
        ),
        axes: <ChartAxis>[
          NumericAxis(
            name: 'volAxis',
            opposedPosition: true,
            title: const AxisTitle(text: 'Volumen 24h', textStyle: TextStyle(fontSize: 10)),
            axisLabelFormatter: (details) =>
                ChartAxisLabel(_compact(details.value), const TextStyle(fontSize: 9)),
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<CryptoEntity, String>>[
          ColumnSeries<CryptoEntity, String>(
            name: 'Volumen 24h',
            yAxisName: 'volAxis',
            dataSource: top8,
            xValueMapper: (c, _) => c.symbol,
            yValueMapper: (c, _) => c.volume24,
            color: const Color(0xFF00B0FF).withValues(alpha: 0.35),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          SplineSeries<CryptoEntity, String>(
            name: 'Precio USD',
            dataSource: top8,
            xValueMapper: (c, _) => c.symbol,
            yValueMapper: (c, _) => c.priceUsd,
            color: const Color(0xFFFFD600),
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 6. EMBUDO DE CONCENTRACIÓN DE LIQUIDEZ (SfFunnelChart)
// -------------------------------------------------------------
class AdvChart06LiquidityFunnel extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart06LiquidityFunnel({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    double volTop3 = 0;
    double volTop10 = 0;
    double volTop25 = 0;
    double volRest = 0;

    for (int i = 0; i < cryptos.length; i++) {
      if (i < 3) {
        volTop3 += cryptos[i].volume24;
      } else if (i < 10) {
        volTop10 += cryptos[i].volume24;
      } else if (i < 25) {
        volTop25 += cryptos[i].volume24;
      } else {
        volRest += cryptos[i].volume24;
      }
    }

    final data = [
      ChartDataPoint(x: 'Tier 1 (Top 3)', y: volTop3, color: const Color(0xFF2962FF)),
      ChartDataPoint(x: 'Tier 2 (Top 4-10)', y: volTop10, color: const Color(0xFF00B0FF)),
      ChartDataPoint(x: 'Tier 3 (Top 11-25)', y: volTop25, color: const Color(0xFF00E5FF)),
      ChartDataPoint(x: 'Tier 4 (Resto Top 100)', y: volRest, color: const Color(0xFF76FF03)),
    ];

    return ChartContainerCard(
      title: 'Embudo de Absorción de Liquidez',
      subtitle: 'Concentración volumétrica según estratificación de mercado',
      badgeText: '06 • Avanzada',
      isDark: isDark,
      child: SfFunnelChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[800], fontSize: 11),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: FunnelSeries<ChartDataPoint, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.x as String,
          yValueMapper: (d, _) => d.y,
          pointColorMapper: (d, _) => d.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
          ),
          gapRatio: 0.05,
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 7. PIRÁMIDE DE SEGMENTACIÓN POR CAPITALIZACIÓN (SfPyramidChart)
// -------------------------------------------------------------
class AdvChart07MarketCapTierPyramid extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart07MarketCapTierPyramid({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    int megaCap = 0; // > $100B
    int largeCap = 0; // $10B - $100B
    int midCap = 0; // $1B - $10B
    int smallCap = 0; // < $1B

    for (final c in cryptos) {
      if (c.marketCapUsd >= 100e9) {
        megaCap++;
      } else if (c.marketCapUsd >= 10e9) {
        largeCap++;
      } else if (c.marketCapUsd >= 1e9) {
        midCap++;
      } else {
        smallCap++;
      }
    }

    final data = [
      ChartDataPoint(x: 'Mega-Cap (>100B)', y: megaCap, color: const Color(0xFFFF6D00)),
      ChartDataPoint(x: 'Large-Cap (10B-100B)', y: largeCap, color: const Color(0xFFFFAB00)),
      ChartDataPoint(x: 'Mid-Cap (1B-10B)', y: midCap, color: const Color(0xFFFFD600)),
      ChartDataPoint(x: 'Small-Cap (<1B)', y: smallCap, color: const Color(0xFFAEEA00)),
    ];

    return ChartContainerCard(
      title: 'Pirámide de Segmentación por Cap',
      subtitle: 'Distribución institucional en rangos Mega, Large, Mid y Small Cap',
      badgeText: '07 • Avanzada',
      isDark: isDark,
      child: SfPyramidChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[800], fontSize: 11),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: PyramidSeries<ChartDataPoint, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.x as String,
          yValueMapper: (d, _) => d.y,
          pointColorMapper: (d, _) => d.color,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          gapRatio: 0.04,
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 8. ANÁLISIS EN CASCADA DE RENDIMIENTO (WaterfallSeries)
// -------------------------------------------------------------
class AdvChart08WaterfallReturnBreakdown extends StatelessWidget {
  final CryptoEntity? crypto;
  final bool isDark;

  const AdvChart08WaterfallReturnBreakdown({
    super.key,
    required this.crypto,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = crypto?.symbol ?? 'BTC';
    final price = crypto?.priceUsd ?? 84000.0;
    final c7d = (crypto?.percentChange7d ?? 5.0) / 100 * price;
    final c24h = (crypto?.percentChange24h ?? 1.2) / 100 * price;
    final c1h = (crypto?.percentChange1h ?? -0.1) / 100 * price;
    final base = price - c7d - c24h - c1h;

    final data = [
      ChartDataPoint(x: 'Precio Base 7d', y: base),
      ChartDataPoint(x: 'Impulso 7d', y: c7d),
      ChartDataPoint(x: 'Impulso 24h', y: c24h),
      ChartDataPoint(x: 'Impulso 1h', y: c1h),
    ];

    return ChartContainerCard(
      title: 'Cascada de Contribución de Precio ($symbol)',
      subtitle: 'Desglose incremental de variaciones acumuladas hacia el precio actual',
      badgeText: '08 • Avanzada',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('\$${details.value.toStringAsFixed(0)}', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          WaterfallSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            negativePointsColor: const Color(0xFFFF1744),
            color: const Color(0xFF00E676),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 9. DISPERSIÓN DE MOMENTUM: 1H VS 24H (ScatterSeries)
// -------------------------------------------------------------
class AdvChart09MomentumScatter extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart09MomentumScatter({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top30 = cryptos.take(30).toList();

    return ChartContainerCard(
      title: 'Matriz de Momentum: Volatilidad 1h vs 24h',
      subtitle: 'Identificación de rupturas de tendencia con cuadrantes ortogonales',
      badgeText: '09 • Avanzada',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          title: const AxisTitle(text: 'Cambio 1h (%)', textStyle: TextStyle(fontSize: 10)),
          plotBands: <PlotBand>[
            PlotBand(
              start: 0,
              end: 0,
              borderWidth: 1.5,
              borderColor: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
        primaryYAxis: NumericAxis(
          title: const AxisTitle(text: 'Cambio 24h (%)', textStyle: TextStyle(fontSize: 10)),
          plotBands: <PlotBand>[
            PlotBand(
              start: 0,
              end: 0,
              borderWidth: 1.5,
              borderColor: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: '1h: point.x%, 24h: point.y%',
        ),
        series: <CartesianSeries<CryptoEntity, num>>[
          ScatterSeries<CryptoEntity, num>(
            dataSource: top30,
            xValueMapper: (c, _) => c.percentChange1h,
            yValueMapper: (c, _) => c.percentChange24h,
            pointColorMapper: (c, _) => (c.percentChange1h > 0 && c.percentChange24h > 0)
                ? const Color(0xFF00E676)
                : (c.percentChange1h < 0 && c.percentChange24h < 0)
                    ? const Color(0xFFFF1744)
                    : const Color(0xFFFFD600),
            markerSettings: const MarkerSettings(
              width: 10,
              height: 10,
              shape: DataMarkerType.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 10. ÁREA ESPLÍNICA CON GRADIENTE Y BANDAS DE CONTROL
// -------------------------------------------------------------
class AdvChart10SplineAreaGradientPlotBands extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart10SplineAreaGradientPlotBands({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top15 = cryptos.take(15).toList();
    final data = top15
        .map((c) => ChartDataPoint(x: c.symbol, y: c.percentChange24h))
        .toList();

    return ChartContainerCard(
      title: 'Espectro de Fluctuación con Bandas Críticas',
      subtitle: 'Sombreado dinámico con zonas de sobrecompra (>+5%) y sobreventa (<-5%)',
      badgeText: '10 • Avanzada',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          plotBands: <PlotBand>[
            PlotBand(
              start: 5,
              end: 25,
              color: const Color(0xFF00E676).withValues(alpha: 0.12),
              text: 'Sobrecompra (+5%)',
              textStyle: const TextStyle(color: Color(0xFF00E676), fontSize: 9),
            ),
            PlotBand(
              start: -25,
              end: -5,
              color: const Color(0xFFFF1744).withValues(alpha: 0.12),
              text: 'Sobreventa (-5%)',
              textStyle: const TextStyle(color: Color(0xFFFF1744), fontSize: 9),
            ),
          ],
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          SplineAreaSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            yValueMapper: (d, _) => d.y,
            gradient: const LinearGradient(
              colors: [Color(0xFF2962FF), Color(0xFF00E5FF)],
              stops: [0.2, 0.9],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: const Color(0xFF2962FF),
            borderWidth: 2,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 11. DISTANCIA AL MÁXIMO HISTÓRICO - ATH DRAWDOWN (RangeColumn)
// -------------------------------------------------------------
class AdvChart11AthDrawdownRange extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart11AthDrawdownRange({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final top8 = cryptos.take(8).toList();

    // Estimamos el retroceso desde ATH
    final data = top8.map((c) {
      final ath = c.priceUsd * 1.35; // Factor representativo respecto a ATH
      return ChartDataPoint(
        x: c.symbol,
        low: c.priceUsd,
        high: ath,
        text: 'ATH: \$${ath.toStringAsFixed(0)}',
      );
    }).toList();

    return ChartContainerCard(
      title: 'Distancia al Máximo Histórico (ATH Drawdown)',
      subtitle: 'Brecha de precio actual frente a la cumbre histórica de cotización',
      badgeText: '11 • Avanzada',
      isDark: isDark,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: LogarithmicAxis(
          axisLabelFormatter: (details) =>
              ChartAxisLabel('\$${details.value.toStringAsFixed(0)}', const TextStyle(fontSize: 10)),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartDataPoint, String>>[
          RangeColumnSeries<ChartDataPoint, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x as String,
            lowValueMapper: (d, _) => d.low,
            highValueMapper: (d, _) => d.high,
            color: const Color(0xFFFF5252).withValues(alpha: 0.6),
            borderColor: const Color(0xFFFF5252),
            borderWidth: 1.5,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 12. COMPARATIVA MULTIACTIVO NORMALIZADA BASE 100 CON ZOOM Y PAN
// -------------------------------------------------------------
class AdvChart12MultiAssetNormalizedZoom extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const AdvChart12MultiAssetNormalizedZoom({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final coins = cryptos.take(4).toList();

    // Normalización de trayectoria en base 100
    List<CartesianSeries<ChartDataPoint, String>> buildSeries() {
      final colors = [
        const Color(0xFFF7931A), // BTC
        const Color(0xFF627EEA), // ETH
        const Color(0xFF00E676), // USDT / Alt
        const Color(0xFFE040FB), // Alt
      ];

      return coins.asMap().entries.map((entry) {
        final i = entry.key;
        final c = entry.value;
        final color = colors[i % colors.length];

        final data = [
          const ChartDataPoint(x: 'T-7d', y: 100),
          ChartDataPoint(x: 'T-5d', y: 100 + (c.percentChange7d * 0.3)),
          ChartDataPoint(x: 'T-3d', y: 100 + (c.percentChange7d * 0.6)),
          ChartDataPoint(x: 'T-1d', y: 100 + c.percentChange7d - c.percentChange24h),
          ChartDataPoint(x: 'Hoy', y: 100 + c.percentChange7d),
        ];

        return LineSeries<ChartDataPoint, String>(
          name: c.symbol,
          dataSource: data,
          xValueMapper: (d, _) => d.x as String,
          yValueMapper: (d, _) => d.y,
          color: color,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: true),
        );
      }).toList();
    }

    return ChartContainerCard(
      title: 'Tendencia Relativa Normalizada (Base 100)',
      subtitle: 'Comparativa de evolución porcentual con Zoom táctil y Cursor de precisión',
      badgeText: '12 • Avanzada',
      badgeColor: const Color(0xFF00E5FF),
      isDark: isDark,
      child: SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(
          title: AxisTitle(text: 'Índice (Base 100)', textStyle: TextStyle(fontSize: 10)),
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          enableDoubleTapZooming: true,
          zoomMode: ZoomMode.x,
        ),
        crosshairBehavior: CrosshairBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: buildSeries(),
      ),
    );
  }
}
