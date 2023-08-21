import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/business_logic/authentication/authentication_bloc.dart';
import 'package:smallstep/data/constants/activity_duration.dart';
import 'package:smallstep/data/models/activity.dart';
import 'package:smallstep/business_logic/activity/activity_bloc.dart';

class AddActivityDialog extends StatefulWidget {
  const AddActivityDialog({super.key});

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  String activityName = '';
  String activityDescription = '';
  ActivityDuration activityDuration = ActivityDuration.short;
  String? uid = '';

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add Activity'),
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(hintText: "Activity name"),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        DropdownButtonFormField(
          decoration: const InputDecoration(hintText: "Activity duration"),
          onSaved: (value) {
            setState(() {
              activityDuration = value as ActivityDuration;
            });
          },
          style: Theme.of(context).textTheme.bodyMedium,
          value: activityDuration,
          onChanged: (value) {
            setState(() {
              activityDuration = value as ActivityDuration;
            });
          },
          items: ActivityDuration.values
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name),
                  ))
              .toList(),
        ),
        // Duration
        TextFormField(
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(hintText: "Activity description"),
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: (value) {
            setState(() {
              activityDescription = value;
            });
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Add'),
                onPressed: () {
                  const SnackBar(content: Text('Activity added'));
                  Navigator.of(context).pop();
                  return context.read<ActivityBloc>().add(ActivityAdded(
                          activity: Activity(
                        name: activityName,
                        duration: activityDuration,
                        uid: context
                                .read<AuthenticationBloc>()
                                .state
                                .uid
                                ?.toString() ??
                            '',
                        description: activityDescription,
                      )));
                }),
          ],
        ),
      ],
    );
  }
}
