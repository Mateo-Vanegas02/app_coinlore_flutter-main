import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_coinlore_flutter/core/utils/responsive.dart';
import 'package:app_coinlore_flutter/features/crypto_list/presentation/providers/crypto_list_provider.dart';
import 'package:app_coinlore_flutter/features/search/presentation/providers/search_provider.dart'
    show searchHistoryProvider;
import 'package:app_coinlore_flutter/features/settings/presentation/providers/settings_provider.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/presentation/providers/charts_providers.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/presentation/widgets/advanced_charts/advanced_charts_collection.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/presentation/widgets/basic_charts/basic_charts_collection.dart';

class CryptoChartsDashboardScreen extends ConsumerStatefulWidget {
  const CryptoChartsDashboardScreen({super.key});

  @override
  ConsumerState<CryptoChartsDashboardScreen> createState() =>
      _CryptoChartsDashboardScreenState();
}

class _CryptoChartsDashboardScreenState
    extends ConsumerState<CryptoChartsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cryptosAsync = ref.watch(allCryptosProvider);
    final globalStatsAsync = ref.watch(globalStatsProvider);
    final searchHistoryAsync = ref.watch(searchHistoryProvider);
    final livePoints = ref.watch(liveTickerProvider);
    final selectedCoin = ref.watch(selectedChartCoinProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    final globalStats = globalStatsAsync.valueOrNull;
    final searchHistory = searchHistoryAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analítica & Gráficos CoinLore',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '32 Gráficos con Syncfusion Charts (20 Básicos + 12 Avanzados)',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF2962FF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF2962FF),
          unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[600],
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Gráficos Básicos (20)'),
            Tab(text: 'Gráficos Avanzados (12)'),
            Tab(text: 'Todos los Gráficos (32)'),
          ],
        ),
        actions: [
          // Selector de moneda activa
          cryptosAsync.maybeWhen(
            data: (cryptos) {
              if (cryptos.isEmpty) return const SizedBox.shrink();
              final current = selectedCoin ?? cryptos.first;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: current.id,
                    dropdownColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    items: cryptos.take(15).map((c) {
                      return DropdownMenuItem<String>(
                        value: c.id,
                        child: Text('${c.symbol} • ${c.name}'),
                      );
                    }).toList(),
                    onChanged: (id) {
                      if (id != null) {
                        final found = cryptos.firstWhere((c) => c.id == id);
                        ref.read(selectedChartCoinProvider.notifier).state = found;
                      }
                    },
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          // Botón de refresco manual
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(allCryptosProvider);
              ref.invalidate(globalStatsProvider);
            },
            tooltip: 'Actualizar datos',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: cryptosAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando datos y generando gráficos...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar datos para los gráficos: $error',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(allCryptosProvider);
                  ref.invalidate(globalStatsProvider);
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (cryptos) {
          final activeCoin = selectedCoin ?? (cryptos.isNotEmpty ? cryptos.first : null);
          final candleData = activeCoin != null
              ? ref.watch(syntheticOhlcProvider(activeCoin))
              : <dynamic>[];
          final marketsAsync = activeCoin != null
              ? ref.watch(coinMarketsProvider(activeCoin.id))
              : null;
          final markets = marketsAsync?.valueOrNull ?? [];

          // Lista de 20 gráficos básicos
          final basicCharts = [
            BasicChart01TopMarketCap(cryptos: cryptos, isDark: isDark),
            BasicChart02GlobalDominance(stats: globalStats, isDark: isDark),
            BasicChart03TopVolume(cryptos: cryptos, isDark: isDark),
            BasicChart04TopGainers(cryptos: cryptos, isDark: isDark),
            BasicChart05TopLosers(cryptos: cryptos, isDark: isDark),
            BasicChart06Multitimeframe(cryptos: cryptos, isDark: isDark),
            BasicChart07WeeklyPerformance(cryptos: cryptos, isDark: isDark),
            BasicChart08CirculatingVsTotal(crypto: activeCoin, isDark: isDark),
            BasicChart09VolumeVsAdjusted(cryptos: cryptos, isDark: isDark),
            BasicChart10BtcRatioPrices(cryptos: cryptos, isDark: isDark),
            BasicChart11ReturnsHistogram(cryptos: cryptos, isDark: isDark),
            BasicChart12TopUnitPrices(cryptos: cryptos, isDark: isDark),
            BasicChart13MacroCapVsVolume(stats: globalStats, isDark: isDark),
            BasicChart14ParetoConcentration(cryptos: cryptos, isDark: isDark),
            BasicChart15LiquidityTurnover(cryptos: cryptos, isDark: isDark),
            BasicChart16ExchangeDistribution(
              markets: markets,
              coinSymbol: activeCoin?.symbol ?? 'BTC',
              isDark: isDark,
            ),
            BasicChart17MaxSupplyVsCirculating(cryptos: cryptos, isDark: isDark),
            BasicChart18SearchTrends(searchHistory: searchHistory, isDark: isDark),
            BasicChart19MarketThermometer(stats: globalStats, isDark: isDark),
            BasicChart20PriceDispersionCurve(cryptos: cryptos, isDark: isDark),
          ];

          // Lista de 12 gráficos avanzados
          final advancedCharts = [
            AdvChart01ReconstructedCandlestick(
              candleData: candleData.cast(),
              symbol: activeCoin?.symbol ?? 'BTC',
              isDark: isDark,
            ),
            AdvChart02MarketBubble4D(cryptos: cryptos, isDark: isDark),
            AdvChart03WeeklyRangeArea(crypto: activeCoin, isDark: isDark),
            AdvChart04LiveStreamingTicker(
              livePoints: livePoints,
              symbol: activeCoin?.symbol ?? 'BTC',
              isDark: isDark,
            ),
            AdvChart05DualAxisPriceVolume(cryptos: cryptos, isDark: isDark),
            AdvChart06LiquidityFunnel(cryptos: cryptos, isDark: isDark),
            AdvChart07MarketCapTierPyramid(cryptos: cryptos, isDark: isDark),
            AdvChart08WaterfallReturnBreakdown(crypto: activeCoin, isDark: isDark),
            AdvChart09MomentumScatter(cryptos: cryptos, isDark: isDark),
            AdvChart10SplineAreaGradientPlotBands(cryptos: cryptos, isDark: isDark),
            AdvChart11AthDrawdownRange(cryptos: cryptos, isDark: isDark),
            AdvChart12MultiAssetNormalizedZoom(cryptos: cryptos, isDark: isDark),
          ];

          return TabBarView(
            controller: _tabController,
            children: [
              _buildResponsiveGrid(context, basicCharts),
              _buildResponsiveGrid(context, advancedCharts),
              _buildResponsiveGrid(context, [...basicCharts, ...advancedCharts]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context, List<Widget> charts) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    final padding = Responsive.horizontalPadding(context);

    if (crossAxisCount == 1) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
        itemCount: charts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) => charts[index],
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 420,
      ),
      itemCount: charts.length,
      itemBuilder: (context, index) => charts[index],
    );
  }
}
