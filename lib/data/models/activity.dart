import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smallstep/data/constants/activity_duration.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smallstep/data/types/json_map.dart';

part 'activity.g.dart';

@immutable
@JsonSerializable()
class Activity extends Equatable {
  /// {@macro activity_item}
  const Activity(
      {required this.id,
      required this.name,
      required this.duration,
      required this.description,
      required this.uid});

  /// Unique identifier of the activity.
  final String? id;

  /// Title of the activity.
  final String name;

  /// Duration specified in 3 formats: short, medium and long.
  final ActivityDuration duration;

  /// Short description of the activity.
  final String description;

  /// Unique identifier of the user who created the activity.
  final String uid;

  /// Returns a copy of this 'Activity' with the given fields replaced with the new values.
  ///
  /// {@macro activity_item}
  Activity copyWith({
    String? id,
    String? name,
    ActivityDuration? duration,
    String? description,
    String? uid,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      uid: uid ?? this.uid,
    );
  }

  /// Converts a 'DocumentSnapshot' into an 'Activity'.
  factory Activity.fromMap(DocumentSnapshot snapshot) {
    final data = snapshot.data() as JsonMap?;
    switch (data?['duration'] as String?) {
      case 'short':
        data?['duration'] = ActivityDuration.short;
        break;
      case 'medium':
        data?['duration'] = ActivityDuration.medium;
        break;
      case 'long':
        data?['duration'] = ActivityDuration.long;
        break;
    }
    return Activity(
      id: snapshot.id,
      name: data?['name'],
      duration: data?['duration'] as ActivityDuration,
      description: data?['description'] as String,
      uid: data?['uid'] as String,
    );
  }

  /// Converts this 'Activity' into a 'Map<String, dynamic>'.
  JsonMap toMap() {
    return {
      'name': name,
      'duration': duration.name,
      'description': description,
      'uid': uid,
    };
  }

  /// Converts a 'JsonMap' into an 'Activity'.
  static Activity fromJson(JsonMap json) => _$ActivityFromJson(json);

  /// Converts this 'Activity' into a JsonMap.
  JsonMap toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props => [id, name, duration, description, uid];
}
