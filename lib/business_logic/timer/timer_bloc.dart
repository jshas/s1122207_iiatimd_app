import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'constants/timer_items.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerInitial(TimerItem.short, 15))  {
    on<TimerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
