import 'package:shared_preferences/shared_preferences.dart';

class SearchLocalDatasource {
  static const String _key = 'search_history';
  static const int _maxHistory = 10;

  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    return history;
  }

  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.remove(query);
    history.insert(0, query);

    if (history.length > _maxHistory) {
      history.removeLast();
    }

    await prefs.setStringList(_key, history);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
