import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smallstep/data/models/activity.dart';
import 'package:smallstep/data/repositories/activity_repository.dart';

part 'activity_event.dart';

part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;

  ActivityBloc({required ActivityRepository activityRepository})
      : _activityRepository = activityRepository,
        super(const ActivityInitial()) {
    on<ActivityAllRequested>(_activityAllRequested);
    on<ActivityQueryRequested>(_activityQueryRequest);
    on<ActivityAdded>(_addActivity);
    on<ActivityUpdated>(_updateActivity);
    on<ActivityDeleted>(_deleteActivity);
  }

  @override
  Future<void> onChange(Change<ActivityState> change) async {
    super.onChange(change);
    if (kDebugMode) {
      print(change);
    }
  }



  Future<void> _activityAllRequested(
      ActivityAllRequested event, Emitter<ActivityState> emit) async {
    List<Activity> listOfActivities = await _activityRepository
        .getActivities()
        .asyncMap((event) => event.toList() as Activity)
        .toList();
    emit(ActivitySuccess(listOfActivities));
  }

  Future<void> _addActivity(
      ActivityAdded event, Emitter<ActivityState> emit) async {

    try {
      _activityRepository.addNewActivity(event.activity);
    } catch (e) {
      emit(ActivityFailure(e.toString()));
    }
    return emit(ActivityChanged(event.activity));
  }

  Future<void> _updateActivity(
      ActivityUpdated event, Emitter<ActivityState> emit) async {
    _activityRepository.updateActivity(event.activity);
    return emit(ActivityChanged(event.activity));
  }

  Future<void> _deleteActivity(
      ActivityDeleted event, Emitter<ActivityState> emit) async {
    _activityRepository.deleteActivity(event.activity);
    return emit(ActivityChanged(event.activity));
  }

  @override
  Future<void> close() {
    _activityRepository.dispose();
    return super.close();
  }

  Future<void> _activityQueryRequest(ActivityQueryRequested event, Emitter<ActivityState> emit) async {
    Query<Activity> listOfActivities = _activityRepository.getActivityCollection();
    emit(ActivitySuccessQuery(listOfActivities));
  }
}
