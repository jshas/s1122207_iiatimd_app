import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class ActiveTimePersistence {
  Stream<int> getActiveTime();

  Future<void> saveActiveTime(int time);

  Future<void> resetActiveTime();

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

  final _controller = StreamController<int>();

  int? _getActiveTimeValue() {
    return _sharedPreferences.getInt(_kActiveTimePersistenceKey);
  }

  Future<void> _setActiveTimeValue(int value) =>
      _sharedPreferences.setInt(_kActiveTimePersistenceKey, value);

  void _init() {
    final activeTime = _getActiveTimeValue();

    if (activeTime != null) {
      _controller.add(activeTime);
    } else {
      _setActiveTimeValue(0);
      _controller.add(0);
    }
    // FIXME Remove Print
    print({
      'activeTime': _getActiveTimeValue().toString(),
    });
  }

  @override
  Stream<int> getActiveTime() => _controller.stream.asBroadcastStream();

  @override
  Future<void> resetActiveTime() {
    _controller.add(0);
    return _setActiveTimeValue(0);
  }

  @override
  Future<void> saveActiveTime(int time) {
    _controller.add(time);
    print({
      'storedTime': _getActiveTimeValue().toString(),
    });
    print({'timer': time});

    return _setActiveTimeValue(time);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
