import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key, required this.title});

  final String title;

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  int currentPageIndex = 0;
  int activeTime = 30;
  Axis timerAxis = Axis.vertical;
  String _timerItem = '';

  @override
  void initState() {
    super.initState();
    _loadDuration();
  }

  Future<void> _loadDuration() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _timerItem = (prefs.getString('__timer_persistence_key__') ?? 'N/A');
    });
  }

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
        minHeight: 200.0 ,
        minWidth: 200.0,
        maxWidth: MediaQuery
            .sizeOf(context)
            .width,
            // -
            // MediaQuery
            //     .of(context)
            //     .viewPadding
            //     .horizontal,
        maxHeight: MediaQuery
            .sizeOf(context)
            .height
          // -
          //   MediaQuery
          //       .of(context)
          //       .viewPadding
          //       .vertical,
      ),
      child: Flex(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        direction: timerAxis,
        children: [
          Expanded(
              flex: 1,
              child: Center(
                child: Card(
                    color: Theme
                        .of(context)
                        .cardColor,
                    shadowColor: Theme.of(context).shadowColor,
                    elevation: 0,
                    child: Text(activeTime.toString(),
                        style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge)),
              )),
          Expanded(
              flex: 1,
              child: Center(
                child: Text(_timerItem,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge),
              )),
          Expanded(
              flex: 1,
              child: Center(child: reminderTimer(context, activeTime)),
      ),],
      ),
    );
  }
}

var reminderTimer = (context, activeTime) =>
(Container(
    height: 20,
    width: 20,
    color: Theme.of(context).cardColor,
    child: Text(activeTime.toString(),
        style: Theme
            .of(context)
            .textTheme
            .bodyLarge)
));
