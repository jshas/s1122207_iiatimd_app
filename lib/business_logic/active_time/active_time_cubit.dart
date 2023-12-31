import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:smallstep/data/repositories/active_time_repository.dart';

class ActiveTimeCubit extends Cubit<int> {
  // ignore: unused_field
  StreamSubscription<int>? _activeTimeSubscription;
  static int _activeTime = 0;
  final ActiveTimePersistence _activeTimeRepository;

  ActiveTimeCubit({required ActiveTimePersistence activeTimeRepository})
      : _activeTimeRepository = activeTimeRepository,
        super(_activeTime);

  void init() {
    getCurrentActiveTime();
  }

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    if (kDebugMode) {
      print(change);
    }
  }

  void getCurrentActiveTime() {
    // Since `getTheme()` returns a stream, we listen to the output
    _activeTimeSubscription = _activeTimeRepository.getActiveTime().listen(
      (activeTime) {
        emit(activeTime);
      },
    );
  }

  void updateActiveTime(int timeValue) {
    int activeTime = _activeTime + timeValue;
    activeTime > 0 ? _activeTime = activeTime : _activeTime = 0;
    _activeTimeRepository.saveActiveTime(_activeTime);
  }
}
