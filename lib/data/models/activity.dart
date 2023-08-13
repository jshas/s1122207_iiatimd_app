import 'package:equatable/equatable.dart';

class Activity {
  final String id;
  final String title;
  final ActivityDuration category;
  final String description;

  Activity(this.id, this.title, this.category, this.description);

  @override
  List<Object?> get props => [id, title, category, description];

}

enum ActivityDuration {short, medium, long}
