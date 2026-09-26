import re

def process_file():
    filepath = '/home/carlos/Proyectos/CM/Coin/lib/features/charts/presentation/screens/charts_gallery_screen.dart'
    with open(filepath, 'r') as f:
        content = f.read()

    # 1. Update the segmented button to have a 4th option
    # Note: We'll do the SegmentedButton update manually using replace_file_content,
    # or we can do it here. Let's do it here.
    
    # Update state variable comments
    content = content.replace('// 0: Todos (64), 1: Syncfusion (32), 2: Graphic (32)', '// 0: Todos (96), 1: Syncfusion (32), 2: Graphic (32), 3: MPAndroid (32)')
    
    segment_old = """                      ButtonSegment(
                        value: 0,
                        label: Text('Todos (64)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.dashboard_customize_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Syncfusion (32)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.bolt_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: 2,
                        label: Text('Graphic (32)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.bar_chart_rounded, size: 16),
                      ),"""
    segment_new = """                      ButtonSegment(
                        value: 0,
                        label: Text('Todos', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.dashboard_customize_rounded, size: 14),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Syncfusion', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.bolt_rounded, size: 14),
                      ),
                      ButtonSegment(
                        value: 2,
                        label: Text('Graphic', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.bar_chart_rounded, size: 14),
                      ),
                      ButtonSegment(
                        value: 3,
                        label: Text('MPAndroid', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.android_rounded, size: 14),
                      ),"""
    content = content.replace(segment_old, segment_new)

    # 2. Add ChartCatalog import if it's missing (it should be missing)
    if 'import \'../../data/datasources/chart_catalog.dart\';' not in content:
        content = content.replace('import \'charts_menu_screen.dart\';', 'import \'charts_menu_screen.dart\';\nimport \'../../data/datasources/chart_catalog.dart\';\nimport \'../widgets/mp_chart_view.dart\';\nimport \'../widgets/base/app_chart_card.dart\';')
        
    # 3. Update build method booleans
    build_old = """    final showSf = _selectedEngineIndex == 0 || _selectedEngineIndex == 1;
    final showGr = _selectedEngineIndex == 0 || _selectedEngineIndex == 2;"""
    build_new = """    final showSf = _selectedEngineIndex == 0 || _selectedEngineIndex == 1;
    final showGr = _selectedEngineIndex == 0 || _selectedEngineIndex == 2;
    final showMp = _selectedEngineIndex == 0 || _selectedEngineIndex == 3;"""
    content = content.replace(build_old, build_new)
    
    # Also update subtitle
    content = content.replace("subtitleText = 'Catálogo Completo • 64 Gráficos (32 Syncfusion + 32 Graphic)';", "subtitleText = 'Catálogo Completo • 96 Gráficos';")
    
    # 4. Update the _buildFilteredCharts signature and calls
    content = content.replace('_buildFilteredCharts(tokens, showSf, showGr)', '_buildFilteredCharts(tokens, showSf, showGr, showMp)')
    content = content.replace('List<Widget> _buildFilteredCharts(ChartThemeTokens tokens, bool showSf, bool showGr)', 'List<Widget> _buildFilteredCharts(ChartThemeTokens tokens, bool showSf, bool showGr, bool showMp)')
    
    # Update all 32 calls in _buildFilteredCharts
    content = re.sub(r'(_chart\d+[a-zA-Z]+)\(tokens, showSf, showGr\)', r'\1(tokens, showSf, showGr, showMp)', content)
    
    # 5. Update the signatures of all 32 methods and inject showMp logic
    for i in range(1, 33):
        pattern = r'(List<Widget> _chart' + str(i) + r'[a-zA-Z]+\(ChartThemeTokens tokens, bool showSf, bool showGr\)\s*\{)(.*?)(return items;\s*\})'
        
        def replacer(match):
            sig = match.group(1).replace('bool showGr)', 'bool showGr, bool showMp)')
            body = match.group(2)
            ret = match.group(3)
            
            # Find the title to use for the card
            title_match = re.search(r"title:\s*'([^']+)'", body)
            title = title_match.group(1).replace('(Syncfusion)', '(MPAndroid)') if title_match else f"Chart {i} (MPAndroid)"
            
            inject = f'''
    if (showMp) {{
      if (items.isNotEmpty) items.add(const SizedBox(height: 12));
      items.add(AppChartCard(
        title: '{title}',
        subtitle: 'Renderizado nativo con MPAndroidChart',
        badgeText: '🤖 Android #{i}',
        height: 250,
        chart: MpChartView(config: ChartCatalog.getAllCharts()[{i-1}]),
      ));
    }}
    '''
            return sig + body + inject + ret
            
        content = re.sub(pattern, replacer, content, flags=re.DOTALL)
        
    with open(filepath, 'w') as f:
        f.write(content)

if __name__ == '__main__':
    process_file()
