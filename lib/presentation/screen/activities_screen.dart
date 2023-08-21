import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/data/constants/activity_duration.dart';
import 'package:smallstep/data/repositories/activity_repository.dart';

import '../../data/models/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key, required this.title});

  final String title;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'A space for all activities selectable after completing a work timer. You can make your own with the button below.',
              style: Theme.of(context).textTheme.labelSmall),
        ),
        Divider(
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        Expanded(
          child: FirestoreListView<Activity>(
            query: context.read<ActivityRepository>().getActivityCollection(),
            emptyBuilder: (context) => const Center(
              child: Text('No activities found'),
            ),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            itemBuilder: (context, snapshot) {
              final activity = snapshot.data();
              return Column(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                ActivityCard(activity: activity),
              ]);
            },
          ),
        ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    Widget category;
    String categoryText;

    switch (activity.duration) {
      case ActivityDuration.short:
        categoryText = 'Short';
        category = const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),),
            Text('Short'),
            Text( "5-10 min"),
          ],
        );
        break;
      case ActivityDuration.medium:
        categoryText = 'Medium';
        category = const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),),
            Text('Medium'),
            Text( "10-15 min"),
          ],
        );
        break;
      case ActivityDuration.long:
        categoryText = 'Long';
        category = const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            Text('Long'),
            Text( ">20 min"),
          ],
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          style: Theme.of(context).listTileTheme.style,
          title: Text(activity.name),
          titleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity.duration.name),
              Text(activity.description),
              Text(categoryText),
            ],
          ),
          subtitleTextStyle: Theme.of(context).listTileTheme.subtitleTextStyle,
          isThreeLine: true,
          tileColor: activity.protected!
              ? Theme.of(context).hoverColor
              : Theme.of(context).colorScheme.surfaceVariant,
          dense: false,
          leading: Align(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: 1.0,
              child: category),
          trailing: activity.protected == false
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                        onRemoveActivityPressed(context,activity);
                  },
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock),
                  Text('App activity') ],
              ),
        ),
      ),
    );
  }

  void onRemoveActivityPressed(BuildContext context, Activity activity) {
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove activity'),

          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text("Are you sure you want to remove this activity?"),
              Text('(This action cannot be undone!)', style: TextStyle(fontSize: 12, color: Colors.red),),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ActivityRepository>().deleteActivity(activity);
              },
              child: const Text('Remove')),
          ],
        ));
  }
}
