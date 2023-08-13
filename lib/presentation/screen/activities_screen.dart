import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/data/models/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key, required this.title});

  final String title;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    /*
    * Read: Scrollable List View with 1 Activity card per category (5, 10, 15 min)
    * Create: Floating Action Button => Custom activity (create DAO)
    * Update: ActivityBloc => ActivityRepository => Firebase, Cloud Firestore
    * Delete: Only for user-created files
    * */
    return ListView(
      prototypeItem: const ActivityCard(name: 'Short Walk', activityImage: null, description: "Ok", activityDuration: ActivityDuration.short, ),
    );
  }
}

class ActivityCard extends StatelessWidget {

  const ActivityCard(
      {super.key,
      required this.name,
      required this.description,
      required this.activityDuration,
      required this.activityImage});

  final String name;
  final String description;
  final ActivityDuration activityDuration;
  final Widget? activityImage;

  @override
  Widget build(BuildContext context) {
    Widget category;
    switch(activityDuration){
      case ActivityDuration.short:
        category = const Text("short");
        break;
      case ActivityDuration.medium:
        category = const Text("medium");
        break;
      case ActivityDuration.long:
        category = const Text("long");
        break;
    }

    return ListTile(
      title: Text(name),
      leading: category,
      isThreeLine: true,
      titleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
      subtitle: Text(description),
      subtitleTextStyle: Theme.of(context).listTileTheme.subtitleTextStyle,
      style: Theme.of(context).listTileTheme.style,
      trailing: Placeholder(color: Theme.of(context).colorScheme.surface),
    );

  }
}
