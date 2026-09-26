import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../charts/domain/models/chart_point.dart';
import '../../theme/chart_theme_tokens.dart';
import 'adapters/line_adapter.dart';

/// Gráfico de línea con tooltip flotante al seleccionar un punto.
/// El tooltip se renderiza como widget de Flutter (overlay), no en el canvas,
/// para poder usar layout nativo: sombras, bordes, tipografía, etc.
class CommunityMarkerView extends StatefulWidget {
  final ChartThemeTokens tokens;
  final List<ChartPoint> data;
  final double height;

  const CommunityMarkerView({
    super.key,
    required this.tokens,
    required this.data,
    this.height = 240,
  });

  @override
  State<CommunityMarkerView> createState() => _CommunityMarkerViewState();
}

class _CommunityMarkerViewState extends State<CommunityMarkerView> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final labels = widget.data.map((p) => p.x.toString()).toList();
    final selected =
        _selectedIndex != null ? widget.data[_selectedIndex!] : null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // El gráfico
        charts.LineChart(
          LineAdapter.singleNumeric(
            data: widget.data,
            color: tokens.primaryColor,
          ),
          animate: true,
          defaultRenderer: charts.LineRendererConfig(
            includeArea: false,
            includeLine: true,
            includePoints: true,
            radiusPx: 4,
          ),
          primaryMeasureAxis: LineAdapter.yAxisSpec(
            labelColor: tokens.axisLabelColor,
            gridColor: tokens.gridLineColor,
          ),
          domainAxis: LineAdapter.xAxisNumeric(
            labelColor: tokens.axisLabelColor,
            labels: labels,
          ),
          selectionModels: [
            charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: _onSelectionChanged,
            ),
          ],
        ),

        // Overlay del tooltip
        if (selected != null)
          Positioned(
            left: 12,
            top: 12,
            child: _TooltipBubble(
              tokens: tokens,
              label: selected.x.toString(),
              value: selected.y,
            ),
          ),
      ],
    );
  }

  void _onSelectionChanged(charts.SelectionModel model) {
    final selected = model.selectedDatum;
    if (selected.isEmpty) {
      setState(() => _selectedIndex = null);
      return;
    }
    // `selected.first.index` es el índice dentro de la serie.
    final idx = selected.first.index;
    if (idx != null && idx >= 0 && idx < widget.data.length) {
      setState(() => _selectedIndex = idx);
    }
  }
}

/// Burbuja de tooltip con layout Flutter nativo.
class _TooltipBubble extends StatelessWidget {
  final ChartThemeTokens tokens;
  final String label;
  final num value;

  const _TooltipBubble({
    required this.tokens,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: tokens.tooltipBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: tokens.primaryColor.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: tokens.tooltipTextColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$ ${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: tokens.tooltipTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
