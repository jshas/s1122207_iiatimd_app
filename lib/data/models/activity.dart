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
      required this.title,
      required this.duration,
      required this.description});

  /// Unique identifier of the activity.
  final String id;
  /// Title of the activity.
  final String title;
  /// Duration specified in 3 formats: short, medium and long.
  final ActivityDuration duration;
  /// Short description of the activity.
  final String description;

  /// Returns a copy of this 'Activity' with the given fields replaced with the new values.
  ///
  /// {@macro activity_item}
  Activity copyWith({
    String? id,
    String? title,
    ActivityDuration? duration,
    String? description,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      description: description ?? this.description,
    );
  }

  /// Converts a 'JsonMap' into an 'Activity'.
  static Activity fromJson(JsonMap json) => _$ActivityFromJson(json);

  /// Converts this 'Activity' into a JsonMap.
  JsonMap toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props => [id, title, duration, description];
}
