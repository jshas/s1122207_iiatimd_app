import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart';

abstract class ActivityRepository {
  Future<void> addNewActivity(Activity activity);

  Query<Activity> getActivityCollection();

   getDocumentById(String id);

  Future<void> deleteActivity(Activity activity);

  Stream<List<QuerySnapshot>> getActivities();

  Future<void> updateActivity(Activity activity);

  void dispose();
}

class FirebaseActivityRepository implements ActivityRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseActivityRepository({required FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final StreamController<List<QuerySnapshot>> _controller =
      StreamController<List<QuerySnapshot>>();
  final activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  @override
  Query<Activity> getActivityCollection() {
    final Query<Activity> activityQuery;
    activityQuery = activitiesCollection.withConverter(
      fromFirestore: (snapshot, _) => Activity.fromMap(snapshot),
      toFirestore: (activity, _) => activity.toMap(),
    );
    return activityQuery;
  }

  /// Allows users to add custom activities to the database
  @override
  Future<void> addNewActivity(Activity activity) {
    return activitiesCollection.add(activity.toMap());
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

  @override
  getDocumentById(String id) {
    return activitiesCollection.doc(id).get();
  }
}
