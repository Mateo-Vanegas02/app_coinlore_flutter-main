import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chart_catalog.dart';
import '../widgets/mp_chart_view.dart';
import '../../../crypto_list/presentation/providers/crypto_list_provider.dart';

class ChartDetailScreen extends ConsumerStatefulWidget {
  final ChartItem item;

  const ChartDetailScreen({super.key, required this.item});

  @override
  ConsumerState<ChartDetailScreen> createState() => _ChartDetailScreenState();
}

class _ChartDetailScreenState extends ConsumerState<ChartDetailScreen> {
  bool _generated = false;

  @override
  Widget build(BuildContext context) {
    final cryptosAsync = ref.watch(cryptoListProvider(0));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.item.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Fuente: ${widget.item.dataSource}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          if (!_generated)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _generated = true;
                });
              },
              child: const Text('Generar gráfico'),
            )
          else
            Expanded(
              child: cryptosAsync.when(
                data: (cryptos) {
                  final config = widget.item.buildConfig(cryptos);
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MpChartView(config: config),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Regenerar solo recrea el estado
                          setState(() {});
                        },
                        child: const Text('Regenerar'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
        ],
      ),
    );
  }
}
