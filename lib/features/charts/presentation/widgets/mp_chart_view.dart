import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/chart_config.dart';

class MpChartView extends StatefulWidget {
  final ChartConfig config;
  final Function(MethodChannel)? onChannelCreated;

  const MpChartView({
    super.key,
    required this.config,
    this.onChannelCreated,
  });

  @override
  State<MpChartView> createState() => _MpChartViewState();
}

class _MpChartViewState extends State<MpChartView> {
  MethodChannel? _channel;

  @override
  void didUpdateWidget(covariant MpChartView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_channel != null) {
      _channel!.invokeMethod('updateConfig', widget.config.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      return const Center(
        child: Text(
          'MPAndroidChart solo está disponible en Android',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }

    return AndroidView(
      viewType: 'mpandroidchart_view',
      creationParams: widget.config.toMap(),
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        _channel = MethodChannel('mpandroidchart_view_$id');
        if (widget.onChannelCreated != null) {
          widget.onChannelCreated!(_channel!);
        }
      },
    );
  }
}
