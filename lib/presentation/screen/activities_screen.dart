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
              'A space for all activities selectable after completing a work timer. Your custom activities are indicated with a darker color. Try it out with the button below!',
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
              return Column(mainAxisSize: MainAxisSize.min, children: [
                ActivityCard(activity: activity),
              ]);
            },
          ),
        ),
      ],
    );
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

    return Padding(
      padding: const EdgeInsets.all(4.0),
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
              Text(activity.description),
              Text('id: ${activity.id}'),
              Text(
                'uid: ${activity.uid}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
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
              alignment: AlignmentDirectional.center,
              widthFactor: 1.0,
              child: category),
          trailing: activity.protected == false
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<ActivityRepository>().deleteActivity(activity);
                  },
                )
              : null,
        ),
      ),
    );
  }
}
