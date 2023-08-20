part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivitySuccess extends ActivityState {
  final List<Activity> listOfActivities;
  const ActivitySuccess(this.listOfActivities);

  @override
  List<Object?> get props => [listOfActivities];
}

class ActivityError extends ActivityState {
  @override
  List<Object?> get props => [];
}