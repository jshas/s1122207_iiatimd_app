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
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const _kThemePersistenceKey = '__theme_persistence_key__';

  final _controller = StreamController<ThemeItem>();

  Future<void> _setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);

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
