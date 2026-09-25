/// Barrel export para la feature de gráficos (charts).
/// Permite consumir los modelos, mappers y los 32 tipos de gráficos
/// (20 básicos + 12 avanzados) basados en la Gramática de Gráficos (Graphic 2.7.0).

// Domain Models
export 'domain/models/chart_point.dart';

// Domain Mappers
export 'domain/mappers/crypto_chart_mapper.dart';

// Presentation Theme
export 'presentation/theme/chart_theme_tokens.dart';

// Base Container
export 'presentation/widgets/base/app_chart_card.dart';

// ----------------------------------------------------------------------
// 20 GRÁFICOS BÁSICOS
// ----------------------------------------------------------------------
// Líneas y Áreas (6)
export 'presentation/widgets/basic/lines/app_standard_line_chart.dart';
export 'presentation/widgets/basic/lines/app_smooth_area_chart.dart';
export 'presentation/widgets/basic/lines/app_step_line_chart.dart';
export 'presentation/widgets/basic/lines/app_gradient_area_chart.dart';
export 'presentation/widgets/basic/lines/app_multi_line_chart.dart';
export 'presentation/widgets/basic/lines/app_baseline_area_chart.dart';

// Barras y Columnas (6)
export 'presentation/widgets/basic/bars/app_bar_chart.dart';
export 'presentation/widgets/basic/bars/app_grouped_bar_chart.dart';
export 'presentation/widgets/basic/bars/app_stacked_bar_chart.dart';
export 'presentation/widgets/basic/bars/app_normalized_bar_chart.dart';
export 'presentation/widgets/basic/bars/app_range_bar_chart.dart';

// Circulares y Radiales (5)
export 'presentation/widgets/basic/circular/app_pie_chart.dart';
export 'presentation/widgets/basic/circular/app_donut_chart.dart';
export 'presentation/widgets/basic/circular/app_gauge_chart.dart';
export 'presentation/widgets/basic/circular/app_rose_chart.dart';
export 'presentation/widgets/basic/circular/app_radial_bar_chart.dart';

// Puntos y Radar (3)
export 'presentation/widgets/basic/points_radar/app_scatter_chart.dart';
export 'presentation/widgets/basic/points_radar/app_bubble_chart.dart';
export 'presentation/widgets/basic/points_radar/app_radar_chart.dart';

// ----------------------------------------------------------------------
// 12 GRÁFICOS AVANZADOS
// ----------------------------------------------------------------------
// Estadísticos y de Densidad (4)
export 'presentation/widgets/advanced/statistical/app_heatmap_chart.dart';
export 'presentation/widgets/advanced/statistical/app_boxplot_chart.dart';
export 'presentation/widgets/advanced/statistical/app_histogram_chart.dart';
export 'presentation/widgets/advanced/statistical/app_violin_plot_chart.dart';

// Jerárquicos y de Proporción (3)
export 'presentation/widgets/advanced/hierarchical/app_treemap_chart.dart';
export 'presentation/widgets/advanced/hierarchical/app_sunburst_chart.dart';
export 'presentation/widgets/advanced/hierarchical/app_funnel_chart.dart';

// Multidimensionales y Continuos (3)
export 'presentation/widgets/advanced/multidimensional/app_parallel_coord_chart.dart';
export 'presentation/widgets/advanced/multidimensional/app_scatter_matrix_chart.dart';
export 'presentation/widgets/advanced/multidimensional/app_band_area_chart.dart';

// Financieros y de Flujo (2)
export 'presentation/widgets/advanced/financial/app_candlestick_chart.dart';
export 'presentation/widgets/advanced/financial/app_streamgraph_chart.dart';
