import 'package:flutter/material.dart';

class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key, required this.title});

  final String title;

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  int currentPageIndex = 0;
  var timerAxis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.orientationOf(context) == Orientation.portrait) {
      timerAxis = Axis.vertical;
    }
    if (MediaQuery.orientationOf(context) == Orientation.landscape) {
      timerAxis = Axis.horizontal;
    }
    return Container(
      constraints: BoxConstraints(
        minHeight: 50.0,
        minWidth: 20.0,
        maxWidth: MediaQuery
            .sizeOf(context)
            .width - MediaQuery
            .of(context)
            .viewPadding
            .horizontal,
        maxHeight: MediaQuery
            .sizeOf(context)
            .height - MediaQuery
            .of(context)
            .viewPadding
            .vertical,),
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        direction: timerAxis,
        children: const [
          Spacer(),
          Placeholder(fallbackHeight: 150, fallbackWidth: 200,),
          Spacer(),
          Placeholder(fallbackHeight: 150, fallbackWidth: 200,),
          Spacer(),
          Placeholder(fallbackHeight: 150, fallbackWidth: 200,),
          Spacer(),
        ],
      ),
    );
  }
}
