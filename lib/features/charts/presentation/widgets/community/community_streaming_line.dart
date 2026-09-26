import 'dart:async';
import 'dart:math';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../charts/domain/models/chart_point.dart';
import '../../theme/chart_theme_tokens.dart';
import 'adapters/line_adapter.dart';

/// Gráfico de línea con streaming en tiempo real.
/// Añade un punto cada 500 ms y mantiene una ventana de 30 puntos visibles.
class CommunityStreamingLine extends StatefulWidget {
  final ChartThemeTokens tokens;
  final double height;
  final int windowSize;

  const CommunityStreamingLine({
    super.key,
    required this.tokens,
    this.height = 260,
    this.windowSize = 30,
  });

  @override
  State<CommunityStreamingLine> createState() => _CommunityStreamingLineState();
}

class _CommunityStreamingLineState extends State<CommunityStreamingLine> {
  static const int _maxPoints = 60; // historial total en memoria

  final List<ChartPoint> _data = [];
  final Random _random = Random();
  Timer? _timer;
  bool _isRunning = false;
  int _tick = 0;
  double _lastPrice = 84000;

  @override
  void initState() {
    super.initState();
    // Pre-poblamos con 20 puntos para que no empiece vacío.
    for (int i = 0; i < 20; i++) {
      _appendPoint();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _appendPoint() {
    // Caminata aleatoria simple: ±0.3% por punto.
    final shock = (_random.nextDouble() - 0.5) * 2 * 0.003;
    _lastPrice = _lastPrice * (1 + shock);
    _data.add(ChartPoint(
      x: _tick.toString(),
      y: _lastPrice,
    ));
    _tick++;
    // Recortamos el historial para no crecer indefinidamente.
    if (_data.length > _maxPoints) {
      _data.removeAt(0);
    }
  }

  void _start() {
    if (_isRunning) return;
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(_appendPoint);
    });
    setState(() => _isRunning = true);
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    setState(() => _isRunning = false);
  }

  void _reset() {
    _pause();
    setState(() {
      _data.clear();
      _tick = 0;
      _lastPrice = 84000;
      for (int i = 0; i < 20; i++) {
        _appendPoint();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;

    // Ventana visible: los últimos `windowSize` puntos.
    final visibleStart =
        _data.length > widget.windowSize ? _data.length - widget.windowSize : 0;
    final visible = _data.sublist(visibleStart);

    final labels = visible.map((p) => p.x.toString()).toList();

    return Column(
      children: [
        // Controles
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón Iniciar / Pausar
              FilledButton.icon(
                onPressed: _isRunning ? _pause : _start,
                icon: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  size: 16,
                ),
                label: Text(
                  _isRunning ? 'Pausar' : 'Iniciar',
                  style: const TextStyle(fontSize: 12),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      _isRunning ? tokens.bearishColor : tokens.bullishColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Botón Reiniciar
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text(
                  'Reiniciar',
                  style: TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: tokens.axisLabelColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Indicador de estado
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRunning
                          ? tokens.bullishColor
                          : tokens.axisLabelColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isRunning ? 'En vivo' : 'En pausa',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _isRunning
                          ? tokens.bullishColor
                          : tokens.axisLabelColor,
                    ),
                  ),
                ],
              ),
              Text(
                '${_data.length} puntos • ventana ${widget.windowSize}',
                style: TextStyle(
                  fontSize: 11,
                  color: tokens.axisLabelColor,
                ),
              ),
            ],
          ),
        ),
        // Gráfico
        Expanded(
          child: charts.LineChart(
            LineAdapter.singleNumeric(
              data: visible,
              color: tokens.primaryColor,
              includeArea: true,
            ),
            animate:
                false, // Sin animación: en streaming queremos actualización instantánea.
            defaultRenderer: charts.LineRendererConfig(
              includeArea: true,
              includeLine: true,
              includePoints: false,
            ),
            primaryMeasureAxis: LineAdapter.yAxisSpec(
              labelColor: tokens.axisLabelColor,
              gridColor: tokens.gridLineColor,
            ),
            domainAxis: LineAdapter.xAxisNumeric(
              labelColor: tokens.axisLabelColor,
              labels: labels,
            ),
          ),
        ),
      ],
    );
  }
}
