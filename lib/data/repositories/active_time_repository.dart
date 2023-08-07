import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class ActiveTimePersistence {
  Stream<int> getActiveTime();
  Future<void> saveActiveTime(int time);
  Future<void> resetActiveTime();
  Stream<int> getActiveDate();
  Future<void> saveActiveDate();
  void dispose();
}

class ActiveTimeRepository implements ActiveTimePersistence {
  ActiveTimeRepository({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences {
    _init();
  }

  final SharedPreferences _sharedPreferences;

  static const _kActiveTimePersistenceKey = '__active_time_persistence_key__';
  static const _kActiveDatePersistenceKey = '__active_date_persistence_key__';

  final _controller = StreamController<int>();
  final _dateController = StreamController<int>();

  int? _getActiveTimeValue(String key) {
      return _sharedPreferences.getInt(_kActiveTimePersistenceKey);
  }

  Future<void> _setActiveTimeValue(String key, int value) =>
      _sharedPreferences.setInt(key,value);

  int? _getActiveDateValue(String key) {
    return _sharedPreferences.getInt(_kActiveDatePersistenceKey);
  }

  Future<void> _setActiveDateValue(String key, int value) =>
      _sharedPreferences.setInt(key,value);

  void _init() {
    final activeTime = _getActiveTimeValue(_kActiveTimePersistenceKey);
    final activeDate = _getActiveDateValue(_kActiveDatePersistenceKey);
    final now = DateTime.now().microsecondsSinceEpoch;

    if(activeTime != null) {
        _controller.add(activeTime);
        (activeDate != null) ? _dateController.add(activeDate) : _dateController.add(now);
      } else {
      _controller.add(30);
      (activeDate != null) ? _dateController.add(activeDate) : _dateController.add(now);
    }
  }

  @override
  Stream<int> getActiveTime() => _controller.stream.asBroadcastStream();

  @override
  Future<void> resetActiveTime() {
    _controller.add(30);
    return _setActiveTimeValue(_kActiveTimePersistenceKey, 30);
  }

  @override
  Future<void> saveActiveTime(int time) {
    _controller.add(time);
    return _setActiveTimeValue(_kActiveTimePersistenceKey, time);
  }

  @override
  Stream<int> getActiveDate() => _dateController.stream.asBroadcastStream();

  @override
  Future<void> saveActiveDate() {
    _dateController.add(30);
    return _setActiveDateValue(_kActiveDatePersistenceKey, 30);
  }

  @override
  void dispose() {
    _controller.close();
    _dateController.close();
  }
}
