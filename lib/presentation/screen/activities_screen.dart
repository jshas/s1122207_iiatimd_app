import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
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
    /*
    * Read: Scrollable List View with 1 Activity card per category (5, 10, 15 min)
    * Create: Floating Action Button => Custom activity (create DAO)
    * Update: ActivityBloc => ActivityRepository => Firebase, Cloud Firestore
    * Delete: Only for user-created files
    * */
    return FirestoreListView<Activity>(
        query: context.read<ActivityRepository>().getActivityCollection(),
        emptyBuilder: (context) => const Center(
              child: Text('No activities found'),
            ),
        errorBuilder: (context, error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        itemBuilder: (context, snapshot) {
          final activity = snapshot.data();
          if (kDebugMode) {
            print(activity);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActivityCard(activity: activity),
            ],
          );
        });
  }
}

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Short duration (5 min)",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Medium duration [10 min]",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const Divider(),
      // Long
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Long duration (15 min)",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    ]);
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
        category = const Text('5-10 min');
        break;
      case ActivityDuration.medium:
        categoryText = 'Medium';
        category = const Text('10-15 min');
        break;
      case ActivityDuration.long:
        categoryText = 'Long';
        category = const Text('15-30 min');
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        style: Theme.of(context).listTileTheme.style,
        title: Text(activity.name),
        titleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.description),
            Text('id: ${activity.id}'),
            Text('uid: ${activity.uid}', style: Theme.of(context).textTheme.labelSmall,),
            Text('protected: ${activity.protected}'),
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
        trailing: activity.protected == false ? IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<ActivityRepository>().deleteActivity(activity);
          },
        ): null,
      ),
    );
  }
}
