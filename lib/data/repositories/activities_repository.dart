import 'dart:async';

import '../models/activity.dart';

abstract class ActivitiesRepository {
  Future<void> addNewActivity(Activity activity);

  Future<void> deleteActivity(Activity activity);

  Stream<List<Activity>> activities();

  Future<void> updateActivity(Activity activity);
}

class FirebaseActivitiesRepository implements ActivitiesRepository {
  @override
  Future<void> addNewActivity(Activity activity) {
    // TODO: implement addNewActivity
    throw UnimplementedError();

  }

  @override
  Stream<List<Activity>> activities() {
    // TODO: implement activities
    throw UnimplementedError();
  }

  @override
  Future<void> deleteActivity(Activity activity) {
    // TODO: implement deleteActivity
    throw UnimplementedError();
  }

  @override
  Future<void> updateActivity(Activity activity) {
    // TODO: implement updateActivity
    throw UnimplementedError();
  }

}
