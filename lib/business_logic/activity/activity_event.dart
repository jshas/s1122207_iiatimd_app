part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();


  @override
  List<Object?> get props => [];
}

class ActivityQueryRequested extends ActivityEvent {
  const ActivityQueryRequested();
  @override
  List<Object?> get props => [];
}

class ActivityAllRequested extends ActivityEvent {
  const ActivityAllRequested();

  @override
  List<Object?> get props => [];
}

class ActivityAdded extends ActivityEvent {
 final Activity activity;

  const ActivityAdded({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class ActivityUpdated extends ActivityEvent {
  final Activity activity;

  const ActivityUpdated(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityDeleted extends ActivityEvent {
  final Activity activity;

  const ActivityDeleted(this.activity);

  @override
  List<Object?> get props => [activity];
}