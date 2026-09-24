import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_coinlore_flutter/features/crypto_list/domain/entities/crypto_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_list/presentation/providers/crypto_list_provider.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/data/datasources/charts_remote_datasource.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/data/repositories/charts_repository_impl.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/global_stats_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/market_pair_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/ohlc_candle_data.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/repositories/charts_repository.dart';

// Datasource Provider
final chartsRemoteDatasourceProvider = Provider<ChartsRemoteDatasource>((ref) {
  final client = ref.watch(apiClientProvider);
  return ChartsRemoteDatasourceImpl(apiClient: client);
});

// Repository Provider
final chartsRepositoryProvider = Provider<ChartsRepository>((ref) {
  final datasource = ref.watch(chartsRemoteDatasourceProvider);
  return ChartsRepositoryImpl(remoteDatasource: datasource);
});

// Global Stats Provider (Macro Crypto Market Data)
final globalStatsProvider = FutureProvider<GlobalStatsEntity>((ref) async {
  final repo = ref.watch(chartsRepositoryProvider);
  return repo.getGlobalStats();
});

// Markets Provider per Coin
final coinMarketsProvider =
    FutureProvider.family<List<MarketPairEntity>, String>((ref, coinId) async {
  final repo = ref.watch(chartsRepositoryProvider);
  return repo.getCoinMarkets(coinId);
});

// Selected Coin for Individual Coin Charts
final selectedChartCoinProvider = StateProvider<CryptoEntity?>((ref) {
  final cryptosAsync = ref.watch(allCryptosProvider);
  return cryptosAsync.when(
    data: (list) => list.isNotEmpty ? list.first : null,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Live Ticker State Notifier: Records history every 5 seconds from allCryptosProvider
class LivePricePoint {
  final DateTime timestamp;
  final double price;

  const LivePricePoint({required this.timestamp, required this.price});
}

class LiveTickerNotifier extends StateNotifier<List<LivePricePoint>> {
  LiveTickerNotifier() : super([]) {
    _initializeSeedData();
  }

  void _initializeSeedData() {
    final now = DateTime.now();
    final random = Random();
    const basePrice = 84000.0;
    final initialList = <LivePricePoint>[];

    for (int i = 10; i >= 0; i--) {
      final variation = (random.nextDouble() - 0.49) * 200;
      initialList.add(
        LivePricePoint(
          timestamp: now.subtract(Duration(seconds: i * 5)),
          price: basePrice + variation,
        ),
      );
    }
    state = initialList;
  }

  void addPricePoint(double price) {
    final now = DateTime.now();
    final updated = List<LivePricePoint>.from(state)
      ..add(LivePricePoint(timestamp: now, price: price));

    // Mantener los últimos 25 puntos
    if (updated.length > 25) {
      updated.removeAt(0);
    }
    state = updated;
  }
}

final liveTickerProvider =
    StateNotifierProvider<LiveTickerNotifier, List<LivePricePoint>>((ref) {
  final notifier = LiveTickerNotifier();

  // Escuchar reactivamente los cambios del provider de cryptos con su timer de 5s
  ref.listen<AsyncValue<List<CryptoEntity>>>(allCryptosProvider, (prev, next) {
    next.whenData((cryptos) {
      if (cryptos.isNotEmpty) {
        final selected = ref.read(selectedChartCoinProvider) ?? cryptos.first;
        final currentCoin = cryptos.firstWhere(
          (c) => c.id == selected.id,
          orElse: () => cryptos.first,
        );
        notifier.addPricePoint(currentCoin.priceUsd);
      }
    });
  });

  return notifier;
});

// Generador de datos OHLC sintéticos para CandleSeries
final syntheticOhlcProvider =
    Provider.family<List<OhlcCandleData>, CryptoEntity>((ref, crypto) {
  final now = DateTime.now();
  final list = <OhlcCandleData>[];

  // Reconstrucción analítica basada en precio actual y porcentajes 7d, 24h, 1h
  final priceNow = crypto.priceUsd;
  final change7dRatio = 1 + (crypto.percentChange7d / 100);
  final price7dAgo = change7dRatio != 0 ? priceNow / change7dRatio : priceNow;

  final change24hRatio = 1 + (crypto.percentChange24h / 100);
  final price24hAgo =
      change24hRatio != 0 ? priceNow / change24hRatio : priceNow;

  // Generamos 7 velas diarias
  double currentAnchor = price7dAgo;
  final step = (priceNow - price7dAgo) / 7;

  for (int i = 6; i >= 0; i--) {
    final candleTime = now.subtract(Duration(days: i));
    final open = currentAnchor;
    double close;
    if (i == 0) {
      close = priceNow;
    } else if (i == 1) {
      close = price24hAgo;
    } else {
      close = currentAnchor + step * (0.8 + (i % 3) * 0.15);
    }

    final high = max(open, close) * 1.018;
    final low = min(open, close) * 0.982;
    final vol = crypto.volume24 * (0.7 + (i % 4) * 0.1);

    list.add(
      OhlcCandleData(
        time: candleTime,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: vol,
      ),
    );

    currentAnchor = close;
  }

  return list;
});
