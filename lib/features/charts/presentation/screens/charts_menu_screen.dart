import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chart_catalog.dart';
import 'chart_detail_screen.dart';

class ChartsMenuScreen extends ConsumerWidget {
  const ChartsMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MPAndroidChart'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Básicos (20)'),
              Tab(text: 'Avanzados (12)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(context, ChartCatalog.basicCharts),
            _buildList(context, ChartCatalog.advancedCharts),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ChartItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(item.icon, color: Theme.of(context).primaryColor),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description),
                Text('Fuente: ${item.dataSource}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChartDetailScreen(item: item),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
