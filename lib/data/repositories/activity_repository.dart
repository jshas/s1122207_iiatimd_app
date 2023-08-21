import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/activity.dart';

abstract class ActivityRepository {
  Future<void> addNewActivity(Activity activity);

  Query<Activity> getActivityCollection();

  Future<void> deleteActivity(Activity activity);

  Stream<List<QuerySnapshot>> getActivities();

  Future<void> updateActivity(Activity activity);

  void dispose();
}

class FirebaseActivityRepository implements ActivityRepository {
  // ignore: unused_field
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseActivityRepository({required FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final StreamController<List<QuerySnapshot>> _controller =
      StreamController<List<QuerySnapshot>>();
  final activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  @override
  Query<Activity> getActivityCollection() {
    final Query<Activity> activityQuery;
      activityQuery = activitiesCollection
      .where('uid', whereIn: [_firebaseAuth.currentUser?.uid.toString() ?? '0', '-'])
          .withConverter(
            fromFirestore: (snapshot, _) => Activity.fromMap(snapshot),
            toFirestore: (activity, _) => activity.toJson(),
          )
          .orderBy('duration', descending: true)
    .orderBy('protected', descending: false);
      return activityQuery;
  }

  /// Allows users to add custom activities to the database
  @override
  Future<void> addNewActivity(Activity activity) {
    if (_firebaseAuth.currentUser != null) {
      Activity newActivity = activity.copyWith(
          uid: _firebaseAuth.currentUser!.uid, protected: false);
      return activitiesCollection.add(newActivity.toMap());
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_NOT_LOGGED_IN',
          message: 'You must be logged in to add a custom activity.');
    }
  }

  @override

  /// Allows users to retrieve all activities stored online, including custom activities
  @override
  Stream<List<QuerySnapshot>> getActivities() =>
      _controller.stream.asBroadcastStream();

  /// Allows users to delete custom activities stored online
  @override
  Future<void> deleteActivity(Activity activity) {
    return activitiesCollection.doc(activity.id).delete();
  }

  /// Allows users to update custom activities stored online
  @override
  Future<void> updateActivity(Activity activity) {
    return activitiesCollection.doc(activity.id).update(activity.toMap());
  }

  @override
  void dispose() {
    _controller.close();
  }
}
