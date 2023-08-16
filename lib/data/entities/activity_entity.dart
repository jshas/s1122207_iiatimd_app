import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:smallstep/data/constants/activity_duration.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String title;
  final ActivityDuration duration;
  final String description;


  const ActivityEntity(this.id, this.title, this.duration, this.description);

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'category': duration,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, title, duration, description];

  @override
  String toString() {
    return 'ActivityEntity { id: $id, title: $title, category: $duration, $description }';
  }

  static ActivityEntity fromJson(Map<String, Object> json) {
    return ActivityEntity(
      json['id'] as String,
      json['title'] as String,
      json['category'] as ActivityDuration,
      json['description'] as String,
    );
  }

  static ActivityEntity fromSnapshot(DocumentSnapshot snap) {
    return ActivityEntity(
      snap.id,
      snap.get('title'),
      snap.get('description'),
      snap.get('category'),
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'title': title,
      'description': description,
      'category': duration,
    };
  }
}
