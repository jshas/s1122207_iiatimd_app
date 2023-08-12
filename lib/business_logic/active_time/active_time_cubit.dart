import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smallstep/data/repositories/active_time_repository.dart';
import 'package:smallstep/data/repositories/theme_repository.dart';

part 'active_time_state.dart';

class ActiveTimeCubit extends Cubit<ActiveTimeState> {
  StreamSubscription<int>? _activeTimeSubscription;
  static int _activeTime = 0;
  final ActiveTimePersistence _activeTimeRepository;

  ActiveTimeCubit({required ActiveTimePersistence activeTimeRepository})
      : _activeTimeRepository = activeTimeRepository,
        super(ActiveTimeInitial(_activeTime));

  void init() {
    getCurrentActiveTime();
  }



  void getCurrentActiveTime() {
    // Since `getTheme()` returns a stream, we listen to the output
    _activeTimeSubscription = _activeTimeRepository.getActiveTime().listen(
      (activeTime) {
        emit(ActiveTimeInitial(activeTime));
      },
    );
  }

  void updateActiveTime(int timeValue) {
    int activeTime = _activeTime + timeValue;
    _activeTime = activeTime;
    _activeTimeRepository.saveActiveTime(_activeTime);
  }
}
