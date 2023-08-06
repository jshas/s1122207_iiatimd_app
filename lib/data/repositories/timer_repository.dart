import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../business_logic/timer/constants/timer_items.dart';

abstract class TimerPersistence {
  Stream<TimerItem> getTimerDuration();
  Future<void> saveTimerDuration(TimerItem timerDuration);
  void dispose();
}

class TimerRepository implements TimerPersistence {
  TimerRepository({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const _kTimerPersistenceKey = '__timer_persistence_key__';

  final _controller = StreamController<TimerItem>();

  Future<void> _setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);

  @override
  Stream<TimerItem> getTimerDuration() => _controller.stream;

  @override
  Future<void> saveTimerDuration(TimerItem timerItem) {
    _controller.add(timerItem);
    return _setValue(_kTimerPersistenceKey, timerItem.name);
  }

  @override
  void dispose() => _controller.close();
}
