import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../charts/domain/models/chart_point.dart';
import '../../theme/chart_theme_tokens.dart';
import 'adapters/line_adapter.dart';

/// Gráfico de línea que, al tocar un punto, actualiza un panel de detalle.
class CommunityInteractiveDetail extends StatefulWidget {
  final ChartThemeTokens tokens;
  final List<ChartPoint> data;
  final double height;

  const CommunityInteractiveDetail({
    super.key,
    required this.tokens,
    required this.data,
    this.height = 220,
  });

  @override
  State<CommunityInteractiveDetail> createState() =>
      _CommunityInteractiveDetailState();
}

class _CommunityInteractiveDetailState
    extends State<CommunityInteractiveDetail> {
  ChartPoint? _selected;

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final labels = widget.data.map((p) => p.x.toString()).toList();

    return Column(
      children: [
        // Gráfico
        Expanded(
          child: charts.LineChart(
            LineAdapter.singleNumeric(
              data: widget.data,
              color: tokens.primaryColor,
            ),
            animate: true,
            defaultRenderer: charts.LineRendererConfig(
              includeArea: false,
              includeLine: true,
              includePoints: true,
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
        ),
        const SizedBox(height: 8),
        // Panel de detalle
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: tokens.cardBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: tokens.cardBorderColor),
          ),
          child: _selected == null
              ? Text(
                  'Toca un punto del gráfico para ver el detalle',
                  style: TextStyle(
                    fontSize: 12,
                    color: tokens.axisLabelColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selected!.x.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: tokens.primaryColor,
                      ),
                    ),
                    Text(
                      '\$ ${_selected!.y.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: tokens.bullishColor,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void _onSelectionChanged(charts.SelectionModel model) {
    final selected = model.selectedDatum;
    if (selected.isEmpty) return;
    final point = selected.first.datum;
    setState(() => _selected = point);
  }
}
