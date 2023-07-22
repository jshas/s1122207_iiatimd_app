part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final TimerItem timerItem;
  final int timerDuration;
  const TimerState(this.timerItem, this.timerDuration);
}

class TimerInitial extends TimerState {
  const TimerInitial(super.timerItem, super.timerDuration);

  @override
  List<Object> get props => [timerItem, timerDuration];
}
