part of 'timer_bloc.dart';

sealed class TimerEvent {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

final class TimerPaused extends TimerEvent {
  const TimerPaused();
}

final class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerSet extends TimerEvent {
  final TimerItem timerItem;
  const TimerSet({required this.timerItem});
}

class TimerTicked extends TimerEvent {
  final int duration;
  const TimerTicked(this.duration);

  List<Object> get props => [duration];
}
