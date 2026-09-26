class ChartConfig {
  final String chartType;
  final bool showDescription;
  final String description;
  final ChartLegend legend;
  final Map<String, dynamic> data;
  final ChartAxis xAxis;
  final int animateX;
  final int animateY;
  final bool drawHole;

  ChartConfig({
    required this.chartType,
    this.showDescription = false,
    this.description = '',
    this.legend = const ChartLegend(enabled: true),
    required this.data,
    this.xAxis = const ChartAxis(enabled: true),
    this.animateX = 0,
    this.animateY = 0,
    this.drawHole = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'chartType': chartType,
      'showDescription': showDescription,
      'description': description,
      'legend': legend.toMap(),
      'data': data,
      'xAxis': xAxis.toMap(),
      'animateX': animateX,
      'animateY': animateY,
      'drawHole': drawHole,
    };
  }
}

class ChartLegend {
  final bool enabled;

  const ChartLegend({this.enabled = true});

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
    };
  }
}

class ChartAxis {
  final bool enabled;
  final List<String>? labels;

  const ChartAxis({this.enabled = true, this.labels});

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'labels': labels,
    };
  }
}
