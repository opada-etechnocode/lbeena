import 'package:shared_preferences/shared_preferences.dart';


class DataStore {



  factory DataStore() {
    return _dataStore;
  }

  static final DataStore _dataStore = DataStore._internal();

  DataStore._internal() {

  }

  void clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> setSearchHistory(List<String> searchHistory) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setStringList('searchHistory', searchHistory);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      return prefs.getStringList('searchHistory') ?? [];
    } catch (e) {
      return [];
    }
  }
}

final dataStore = DataStore();
