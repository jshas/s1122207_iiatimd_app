part of 'active_time_cubit.dart';

abstract class ActiveTimeState extends Equatable {
  final int activeTime; // In minutes
  const ActiveTimeState(this.activeTime);
}

class ActiveTimeInitial extends ActiveTimeState {
  const ActiveTimeInitial(super.activeTime);

  @override
  List<Object> get props => [activeTime];
}


