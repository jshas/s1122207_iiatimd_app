import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import '../../business_logic/theme/constants/theme_items.dart';

abstract class ThemePersistence {
  Stream<ThemeItem> getTheme();
  Future<void> saveTheme(ThemeItem theme);
  void dispose();
}

class ThemeRepository implements ThemePersistence {
  ThemeRepository({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences {
    _init();
  }

  final SharedPreferences _sharedPreferences;

  static const _kThemePersistenceKey = '__theme_persistence_key__';

  final _controller = StreamController<ThemeItem>();

  String? _getValue(String key) {
      return _sharedPreferences.getString(key);
  }

  Future<void> _setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);

  void _init() {
    final themeString = _getValue(_kThemePersistenceKey);
    if(themeString != null) {
      if (themeString == ThemeItem.light.name){
        _controller.add(ThemeItem.light);
      } else if (themeString == ThemeItem.dark.name) {
        _controller.add(ThemeItem.dark);
      } else {
        _controller.add(ThemeItem.system);
      }
    } else {
      _controller.add(ThemeItem.system);
    }
  }

  @override
  Stream<ThemeItem> getTheme() => _controller.stream;

  @override
  Future<void> saveTheme(ThemeItem theme) {
    _controller.add(theme);
    return _setValue(_kThemePersistenceKey, theme.name);
  }

  @override
  void dispose() => _controller.close();


}
