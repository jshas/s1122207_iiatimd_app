import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smallstep/data/data_providers/ticker.dart';
import 'package:smallstep/data/repositories/timer_repository.dart';

import 'constants/timer_items.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  /// counting down from 60
  final Ticker _ticker;
  final TimerRepository _timerRepository;
  static int _duration = 30 * 60;
  TimerItem _timerItem = TimerItem.short;

  /// to listen to the ticker stream
  StreamSubscription<int>? _tickerSubscription;

  // To retrieve the duration set in SharedPreferences
  StreamSubscription<TimerItem>? _timerSubscription;

  TimerBloc({required Ticker ticker, required TimerRepository timerRepository})
      : _ticker = ticker,
        _timerRepository = timerRepository,
        super(TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerSet>(_onSet);
  }

  void init() {
    _timerItem = getTimerItem();
    updateDuration(_timerItem);
  }

  void getCurrentTimerItem() {
    _timerSubscription = _timerRepository.getTimerDuration().listen(
      (timerName) {
        // This function returns a TimerItem from the SharedPreferences local storage
        updateDuration(timerName);
      },
    );
  }

  TimerItem getTimerItem() {
    String? value = _timerRepository.getValue();
    switch (value) {
      case 'short':
        return TimerItem.short;
      case 'medium':
        return TimerItem.medium;
      case 'long':
        return TimerItem.long;
      default:
        return TimerItem.short;
    }
  }

  // For retrieving the current timer duration from SharedPref
  void updateDuration(TimerItem timerItem) {
    int minute = 60;
    switch (timerItem) {
      case TimerItem.short:
        _duration = 15 * minute;
        break;
      case TimerItem.medium:
        _duration = 30 * minute;
        break;
      case TimerItem.long:
        _duration = 45 * minute;
        break;
      default:
        _duration = 20 * minute;
    }
  }

  // For storing and setting the new reminder duration (from settings)
  void saveDuration(TimerItem timerItem) {
    int minute = 60;
    _timerRepository.saveTimerDuration(timerItem);
    switch (timerItem) {
      case TimerItem.short:
        _duration = 15 * minute;
        break;
      case TimerItem.medium:
        _duration = 30 * minute;
        break;
      case TimerItem.long:
        _duration = 45 * minute;
        break;
      default:
        _duration = 20 * minute;
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    _timerSubscription?.cancel();
    _timerRepository.dispose();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    /// In case of there is an subscription exists, we have to cancel it
    _tickerSubscription?.cancel();

    /// triggers the TimerRunInProgress state
    // getCurrentTimerItem();
    emit(TimerRunInProgress(event.duration));

    /// makes the subscription listen to TimerTicked state
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? TimerRunInProgress(event.duration)

        /// triggers the TimerRunInProgress state
        : const TimerRunComplete());

    /// triggers TimerRunComplete state
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    /// As the timer pause, we should pause the subscription also
    _tickerSubscription?.pause();
    emit(TimerRunPause(state.duration));

    /// triggers the TimerRunPause state
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    /// As the timer resume, we must let the subscription resume also
    _tickerSubscription?.resume();
    emit(TimerRunInProgress(state.duration));

    /// triggers the TimerRunInProgress state
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    /// Timer counting finished, so we must cancel the subscription
    _tickerSubscription?.cancel();
    _timerSubscription?.cancel();
    emit(TimerInitial(_duration));
    /// triggers the TimerInitial state
  }

  void _onSet(TimerSet event, Emitter<TimerState> emit) {
    /// Get the current timerItem from the event TimerSet event.
    saveDuration(event.timerItem);
    updateDuration(event.timerItem);

    /// emit the TimerInitial state
    emit(TimerInitial(_duration));
  }
}
