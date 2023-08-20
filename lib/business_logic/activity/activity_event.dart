part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class ActivitiesFetched extends ActivityEvent {
  const ActivitiesFetched();

  @override
  List<Object?> get props => [];
}