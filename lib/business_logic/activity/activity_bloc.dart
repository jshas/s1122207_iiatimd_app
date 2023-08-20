import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smallstep/data/models/activity.dart';
import 'package:smallstep/data/repositories/activity_repository.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;
  ActivityBloc(this._activityRepository) : super(ActivityInitial()) {
    on<ActivitiesFetched>(_fetchActivities);
  }

  Future<void> _fetchActivities(ActivitiesFetched event, Emitter<ActivityState> emit) async {
    List<Activity> listOfActivities = await _activityRepository.getActivities().asyncMap((event) => event.toList() as Activity).toList();
    emit(ActivitySuccess(listOfActivities));
  }
}