part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {
  const ActivityInitial();

  @override
  List<Object?> get props => [];
}

class ActivityLoading extends ActivityState {

  const ActivityLoading();

  @override
  List<Object?> get props => [];
}

class ActivityChanged extends ActivityState {
  final Activity activity;

  const ActivityChanged(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivitySuccessQuery extends ActivityState {
  final Query<Activity> query;

  const ActivitySuccessQuery(this.query);

  @override
  List<Object?> get props => [query];
}

class ActivitySuccess extends ActivityState {
final List<Activity> listOfActivities;
  const ActivitySuccess(this.listOfActivities);

  @override
  List<Object?> get props => [listOfActivities];
}

class ActivityFailure extends ActivityState {
  final String error;

  const ActivityFailure(this.error);

  @override
  List<Object?> get props => [error];
}