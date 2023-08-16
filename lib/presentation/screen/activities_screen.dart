import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/data/constants/activity_duration.dart';
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
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Short duration (5 min)",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ActivityCard(
          name: 'Short Walk',
          activityImage: null,
          description: "Ok",
          activityDuration: ActivityDuration.short,
        ),
        ActivityCard(
          name: 'Short Walk',
          activityImage: null,
          description: "Ok",
          activityDuration: ActivityDuration.short,
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Medium duration [10 min]",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ActivityCard(
          name: 'Short Walk',
          activityImage: null,
          description: "Ok",
          activityDuration: ActivityDuration.medium,
        ),
        ActivityCard(
          name: 'Short Walk',
          activityImage: null,
          description: "Ok",
          activityDuration: ActivityDuration.medium,
        ),
        Divider(),
        // Long
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Long duration (15 min)",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ActivityCard(
          name: 'Short Walk',
          activityImage: null,
          description: "Ok",
          activityDuration: ActivityDuration.long,
        ),
        ActivityCard(
          name: 'Short Walk',
          activityImage: null,
          description: "Ok",
          activityDuration: ActivityDuration.medium,
        ),
        Divider(),
      ],
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
    String categoryText;
    switch (activityDuration) {
      case ActivityDuration.short:
        categoryText = 'short';
        category = Icon(Icons.access_time_sharp);
        break;
      case ActivityDuration.medium:
        categoryText = 'medium';
        category = Icon(Icons.access_time_filled_sharp);
        break;
      case ActivityDuration.long:
        categoryText = 'long';
        category = const Icon(Icons.access_alarms_sharp);
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        style: Theme.of(context).listTileTheme.style,
        title: Text(name),
        titleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            Text(categoryText),
          ],
        ),
        subtitleTextStyle: Theme.of(context).listTileTheme.subtitleTextStyle,
        isThreeLine: true,
        tileColor: Theme.of(context).hoverColor,
        dense: false,
        leading: Align(
            alignment: AlignmentDirectional.center,
            widthFactor: 1.0,
            child: category),
        trailing: Checkbox(value: false, onChanged: (bool? value) {
          value != value;
        },
        ),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        style: Theme.of(context).listTileTheme.style,
        title: Text(name),
        titleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            category,
          ],
        ),
        subtitleTextStyle: Theme.of(context).listTileTheme.subtitleTextStyle,
        isThreeLine: true,
        tileColor: Theme.of(context).hoverColor,
        dense: false,
        leading: Align(
            alignment: AlignmentDirectional.center,
            widthFactor: 1.0,
            child: category),
      ),
    );
  }
}
