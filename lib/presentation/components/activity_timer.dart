import 'package:flutter/material.dart';

class ActivityTimer extends StatefulWidget {
  const ActivityTimer({super.key});

  @override
  State<ActivityTimer> createState() => _ActivityTimerState();
}

class _ActivityTimerState extends State<ActivityTimer> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,
      verticalDirection: VerticalDirection.down,
      children: [
        Stack(
            alignment: Alignment(0, 0),
            fit: StackFit.expand,
            children: <Widget>[
              Text("Text"),
            ]),
      ],
    );
  }
}
