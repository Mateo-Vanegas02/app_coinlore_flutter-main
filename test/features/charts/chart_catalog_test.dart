import 'package:flutter_test/flutter_test.dart';
import 'package:app_coinlore_flutter/features/charts/data/datasources/chart_catalog.dart';
import 'package:app_coinlore_flutter/features/crypto_list/domain/entities/crypto_entity.dart';

void main() {
  group('ChartCatalog Tests', () {
    test('Should have 20 basic charts and 12 advanced charts', () {
      expect(ChartCatalog.basicCharts.length, 20);
      expect(ChartCatalog.advancedCharts.length, 12);
    });

    test('First basic chart should generate valid configuration', () {
      final mockCryptos = [
        CryptoEntity(
          id: '90',
          rank: 1,
          symbol: 'BTC',
          name: 'Bitcoin',
          nameid: 'bitcoin',
          priceUsd: 50000.0,
          percentChange24h: 2.5,
          percentChange1h: 0.1,
          percentChange7d: -1.2,
          marketCapUsd: 1000000000.0,
          volume24: 50000000.0,
        )
      ];

      final chartItem = ChartCatalog.basicCharts.first;
      final config = chartItem.buildConfig(mockCryptos);

      expect(config.chartType, 'line');
      expect(config.data.containsKey('datasets'), true);
      
      final datasets = config.data['datasets'] as List;
      expect(datasets.length, 1);
      
      final dataset = datasets.first as Map;
      expect(dataset['label'], 'Bitcoin');
      expect((dataset['entries'] as List).length, 30);
    });
    
    test('Sixth basic chart (Bar) should sort and take top 5 gainers', () {
      final mockCryptos = [
        CryptoEntity(id: '1', rank: 1, symbol: 'A', name: 'A', nameid: 'a', priceUsd: 1, percentChange24h: 1.0, percentChange1h: 0, percentChange7d: 0, marketCapUsd: 1, volume24: 1),
        CryptoEntity(id: '2', rank: 2, symbol: 'B', name: 'B', nameid: 'b', priceUsd: 1, percentChange24h: -5.0, percentChange1h: 0, percentChange7d: 0, marketCapUsd: 1, volume24: 1),
        CryptoEntity(id: '3', rank: 3, symbol: 'C', name: 'C', nameid: 'c', priceUsd: 1, percentChange24h: 10.0, percentChange1h: 0, percentChange7d: 0, marketCapUsd: 1, volume24: 1),
        CryptoEntity(id: '4', rank: 4, symbol: 'D', name: 'D', nameid: 'd', priceUsd: 1, percentChange24h: 2.0, percentChange1h: 0, percentChange7d: 0, marketCapUsd: 1, volume24: 1),
      ];
      
      final chartItem = ChartCatalog.basicCharts[5]; // 6th is index 5
      final config = chartItem.buildConfig(mockCryptos);
      
      expect(config.chartType, 'bar');
      expect(config.xAxis.labels, ['C', 'D', 'A', 'B']); // Sorted by gainers desc
      
      final entries = (config.data['datasets'][0]['entries'] as List);
      expect(entries[0]['y'], 10.0); // C
      expect(entries[3]['y'], -5.0); // B
    });
  });
}
