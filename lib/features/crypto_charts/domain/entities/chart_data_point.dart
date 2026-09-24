import 'package:flutter/material.dart';

class ChartDataPoint {
  final dynamic x;
  final num? y;
  final num? secondaryY;
  final num? high;
  final num? low;
  final num? open;
  final num? close;
  final num? size;
  final String? text;
  final Color? color;

  const ChartDataPoint({
    required this.x,
    this.y,
    this.secondaryY,
    this.high,
    this.low,
    this.open,
    this.close,
    this.size,
    this.text,
    this.color,
  });
}
