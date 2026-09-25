import 'dart:math';

import '../../../crypto_detail/domain/entities/crypto_detail_entity.dart';
import '../../../crypto_list/domain/entities/crypto_entity.dart';
import '../models/chart_point.dart';

/// Mapper especializado para transformar entidades de negocio de cripto
/// en puntos de datos desacoplados listos para alimentar los gráficos de syncfusion_flutter_charts.
class CryptoChartMapper {
  /// Genera una serie temporal suave de precios basada en los cambios porcentuales (7d, 24h, 1h, actual)
  static List<ChartPoint> generateTrendPoints(CryptoDetailEntity detail) {
    final currentPrice = detail.price;

    // Precios base calculados a partir de los cambios porcentuales
    final price7d = currentPrice / (1 + (detail.change7d / 100));
    final price24h = currentPrice / (1 + (detail.change24h / 100));
    final price1h = currentPrice / (1 + (detail.change1h / 100));

    // Generamos una serie de puntos interpolados con ligera variación natural
    // para formar una curva realista de 7 días
    final points = <ChartPoint>[];

    // Punto día -7
    points.add(ChartPoint(
      x: 'Hace 7d',
      y: double.parse(price7d.toStringAsFixed(2)),
      label: 'Día -7',
    ));

    // Puntos intermedios interpolados con una semilla fija basada en el ID
    final randomSeed = detail.id.hashCode;
    final random = Random(randomSeed);

    final midPrice4d = price7d + (price24h - price7d) * 0.45 + (random.nextDouble() - 0.5) * (currentPrice * 0.02);
    points.add(ChartPoint(
      x: 'Hace 4d',
      y: double.parse(midPrice4d.toStringAsFixed(2)),
      label: 'Día -4',
    ));

    final midPrice2d = price7d + (price24h - price7d) * 0.75 + (random.nextDouble() - 0.5) * (currentPrice * 0.015);
    points.add(ChartPoint(
      x: 'Hace 2d',
      y: double.parse(midPrice2d.toStringAsFixed(2)),
      label: 'Día -2',
    ));

    // Punto día -1 (24h)
    points.add(ChartPoint(
      x: 'Hace 24h',
      y: double.parse(price24h.toStringAsFixed(2)),
      label: 'Día -1',
    ));

    // Punto hace 1h
    points.add(ChartPoint(
      x: 'Hace 1h',
      y: double.parse(price1h.toStringAsFixed(2)),
      label: '1 Hora',
    ));

    // Punto actual
    points.add(ChartPoint(
      x: 'Ahora',
      y: double.parse(currentPrice.toStringAsFixed(2)),
      label: 'Precio Actual',
    ));

    return points;
  }

  /// Transforma una lista de criptomonedas para gráficos de comparación (Bar, Treemap, Pie)
  static List<ChartPoint> topMarketCapComparison(List<CryptoEntity> cryptos, {int limit = 6}) {
    final sorted = List<CryptoEntity>.from(cryptos)
      ..sort((a, b) => b.marketCapUsd.compareTo(a.marketCapUsd));

    final topList = sorted.take(limit).toList();

    return topList.map((c) {
      return ChartPoint(
        x: c.symbol,
        y: c.marketCapUsd,
        label: c.name,
        extra: {
          'change24h': c.percentChange24h,
          'price': c.priceUsd,
        },
      );
    }).toList();
  }

  /// Mapea la distribución de suministro circulante vs restante para gráficos de Torta o Donut
  static List<ChartPoint> supplyDistribution(CryptoDetailEntity detail) {
    final circulating = double.tryParse(detail.circulatingSupply) ?? 0.0;
    final total = double.tryParse(detail.totalSupply) ?? 0.0;
    final remaining = (total > circulating) ? (total - circulating) : 0.0;

    return [
      ChartPoint(
        x: 'Circulante',
        y: circulating,
        label: '${(circulating / (total > 0 ? total : 1) * 100).toStringAsFixed(1)}%',
      ),
      if (remaining > 0)
        ChartPoint(
          x: 'Por emitir',
          y: remaining,
          label: '${(remaining / total * 100).toStringAsFixed(1)}%',
        ),
    ];
  }

  /// Mapea métricas clave a un formato apto para Radar / Spider Chart
  static List<Map<String, dynamic>> radarMetrics(CryptoDetailEntity detail) {
    // Normalizamos valores entre 0 y 100 para una escala de radar uniforme
    final volScore = min(100.0, max(10.0, log(max(1.0, detail.volume)) * 4.5));
    final mcapScore = min(100.0, max(10.0, log(max(1.0, detail.marketCap)) * 4.2));
    final athDistance = detail.ath > 0 ? ((detail.price / detail.ath) * 100).clamp(5.0, 100.0) : 50.0;
    final momentum24h = ((detail.change24h + 20) * 2.5).clamp(0.0, 100.0);
    final momentum7d = ((detail.change7d + 30) * 1.6).clamp(0.0, 100.0);

    return [
      {'metric': 'Volumen', 'value': volScore, 'category': detail.symbol},
      {'metric': 'Cap. Mercado', 'value': mcapScore, 'category': detail.symbol},
      {'metric': 'Cercanía ATH', 'value': athDistance, 'category': detail.symbol},
      {'metric': 'Impulso 24h', 'value': momentum24h, 'category': detail.symbol},
      {'metric': 'Tendencia 7d', 'value': momentum7d, 'category': detail.symbol},
    ];
  }
}
